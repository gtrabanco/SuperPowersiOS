//
//  SearchSuggestionsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchSuggestionsViewModelType: class {
    
    /// The search query
    var query: Variable<String> { get }
    
    /// The search suggestions
    var suggestions: Observable<[String]> { get }
}

final class SearchSuggestionsViewModel: SearchSuggestionsViewModelType {
    
    let query = Variable("")
    
    private let session = Session.comicVineSession()

    private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
        .filter { query in
            //Ignore less than 3 chars
            query.characters.count > 2
        }
        //This will avoid making unnecessary requests if the user types too fast
        .throttle(0.3, scheduler: MainScheduler.instance)
        //.map { $0.componentsSeparatedByString(" ") }
        .flatMapLatest { query in
            //When the query string changes, any ongoing request will be cancelled
            //and a new request will be made with the new query
            //
            //The results are flattened into the resulting Observer
            self.session.suggestedVolumes(query)
                //Do not forward any errors, otherwise bindings will crash
                .catchErrorJustReturn([])
        }
        .map { volumes in
            var titles: [String] = []
            
            for volume in volumes where !titles.contains(volume.title) {
                titles.append(volume.title)
            }
            
            return titles
        }
        //Make sure events are delivered in the main thread
        .observeOn(MainScheduler.instance)
        .shareReplay(1) //Buffer of events: 1 in this case
    
}

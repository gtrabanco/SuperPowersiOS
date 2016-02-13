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

    private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .map { $0.componentsSeparatedByString(" ") }
}

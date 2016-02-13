//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchResultsViewModelType: class {
    
    /// The search query
    var query: String { get }
    
    /// Called when there are new search results
    var didUpdateResults: () -> () { get set }
    
    /// The current number of search results
    var numberOfResults: Int { get }
    
    /// Returns the search result at a given position
    subscript(position: Int) -> SearchResult { get }
    
    /// Returns the volume summary at a given position
    subscript(position: Int) -> VolumeSummary { get }
    
    /// Fetches the next page of results
    func nextPage() -> Observable<Void>
}

final class SearchResultsViewModel: SearchResultsViewModelType {
    
    let query: String
    
    var didUpdateResults: () -> () = {}
    
    var numberOfResults: Int {
        // TODO: implement
        return 25
    }
    
    init(query: String) {
        self.query = query
    }
    
    subscript(position: Int) -> SearchResult {
        assert(position < numberOfResults, "Position out of range")
        
        // TODO: implement
        return SearchResult(imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg"), title: "Some title \(position)", publisherName: "Some publisher")
    }
    
    subscript(position: Int) -> VolumeSummary {
        assert(position < numberOfResults, "Position out of range")
        
        // TODO: implement
        return VolumeSummary(identifier: 0, title: "Some title \(position)", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg"), publisherName: "Some publisher")
    }
    
    func nextPage() -> Observable<Void> {
        
        /// TODO: implement
        return Observable.just(())
    }
}

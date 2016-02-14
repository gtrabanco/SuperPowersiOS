//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 09/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

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

final class SearchResultsViewModel: NSObject {
    
    //MARK: - Properties
    
    let query: String
    
    var didUpdateResults: () -> () = {}
    
    private let session = Session.comicVineSession()
    private var currentPage: UInt = 1
    
    private let store: ManagedStore
    private let writeContext: NSManagedObjectContext
    private let readContext: NSManagedObjectContext
    private let fetchResultsController: NSFetchedResultsController
    
    private var notificationObserver: NSObjectProtocol!
    
    //MARK: - Initialization
    
    init(query: String) {
        self.query = query
        self.store = try! ManagedStore.temporaryStore()
        self.writeContext = self.store.contextWithConcurrencyType(.PrivateQueueConcurrencyType)
        self.readContext = self.store.contextWithConcurrencyType(.MainQueueConcurrencyType)
        
        self.fetchResultsController = NSFetchedResultsController(
            fetchRequest: ManagedVolume.defaultFetchRequest,
            managedObjectContext: self.readContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        self.fetchResultsController.delegate = self
        try! self.fetchResultsController.performFetch()
        
        self.notificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification,
            object: self.writeContext,
            queue: nil) {
                notification in
                
                self.readContext.performBlock {
                    self.readContext.mergeChangesFromContextDidSaveNotification(notification)
                }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self.notificationObserver)
    }
    
    
    private subscript(position: Int) -> ManagedVolume {
        assert(position < numberOfResults, "Position out of range")
        
        
        let indexPath = NSIndexPath(forRow: position, inSection: 0)
        
        guard let volume = self.fetchResultsController.objectAtIndexPath(indexPath) as? ManagedVolume else {
            fatalError("The result can not be converted to ManagedVolume at position \(position)")
        }
        
        return volume
    }
}

//MARK: - SearchResultsViewModelType
extension SearchResultsViewModel: SearchResultsViewModelType {
    
    var numberOfResults: Int {
        return self.fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    subscript(position: Int) -> SearchResult {
        
        let volume: ManagedVolume = self[position]
        
        return SearchResult(
            imageURL: volume.imageURL,
            title: volume.title,
            publisherName:  volume.publisher
        )
    }
    
    subscript(position: Int) -> VolumeSummary {
        let volume: ManagedVolume = self[position]
        
        return VolumeSummary(
            identifier: volume.identifier,
            title:  volume.title,
            imageURL: volume.imageURL,
            publisherName: volume.publisher
        )
    }
    
    func nextPage() -> Observable<Void> {
        
        let context = self.writeContext
        
        return self.session.searchVolumes(self.query, page: self.currentPage++)
            .doOn(
                onNext: {
                    dictionaries in
                    let _: [ManagedVolume] = decode(dictionaries, insertIntoContext: context)
                    context.performBlockAndWait {
                        do {
                            try context.save()
                        } catch {
                            print("Could not save search results")
                            context.rollback()
                        }
                    }
                })
            .map {_ in  ()} //Convert to void
        .observeOn(MainScheduler.instance)
        .shareReplay(1)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension SearchResultsViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didUpdateResults()
    }
}


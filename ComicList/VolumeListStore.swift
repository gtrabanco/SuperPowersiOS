//
//  VolumeListStore.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 14/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

class VolumeListStore {
    
    //Singleton
    static let sharedStore = VolumeListStore(documentName: "My Comics")
    
    private let managedStore: ManagedStore
    let context: NSManagedObjectContext
    
    private init(documentName: String) {
        self.managedStore = try! ManagedStore(documentName: documentName)
        self.context = self.managedStore.contextWithConcurrencyType(.MainQueueConcurrencyType)
    }
    
    func containsVolume(identifier: Int) -> Bool {
        
        let fetchRequest = ManagedVolume.fetchRequestForVolume(identifier)
        let count = self.context.countForFetchRequest(fetchRequest, error: nil)
        
        return (count != NSNotFound) && (count > 0)
    }
    
    func removeVolume(identifier: Int) throws{
        
        let fetchRequest = ManagedVolume.fetchRequestForVolume(identifier)
        let volumes = try context.executeFetchRequest(fetchRequest) as! [ManagedVolume]
        
        if volumes.count > 0 {
            context.deleteObject(volumes[0])
        }
    }
    
    func addVolume(summary: VolumeSummary) throws {
        
        let volume = NSEntityDescription.insertNewObjectForEntityForName(ManagedVolume.entityName, inManagedObjectContext: self.context) as! ManagedVolume
        volume.identifier = summary.identifier
        volume.title      = summary.title
        volume.imageURL   = summary.imageURL
        volume.publisher  = summary.publisherName
        
        try self.context.save()
    }
}

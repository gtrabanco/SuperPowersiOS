//
//  ManagedObjectType.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 14/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData


protocol ManagedObjectType {
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultFetchRequest: NSFetchRequest { get }
}

extension ManagedObjectType {
    
    
    static var defaultFetchRequest: NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.sortDescriptors = self.defaultSortDescriptors
        
        return fetchRequest
    }
}
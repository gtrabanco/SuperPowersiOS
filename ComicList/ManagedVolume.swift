//
//  ManagedVolume.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 14/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import CoreData

final class ManagedVolume: NSManagedObject {
    @NSManaged var identifier: Int
    @NSManaged var publisher: String?
    @NSManaged var title: String
    
    @NSManaged private(set) var insertionDate: NSDate
    
    @NSManaged private var imageURLString: String?
    
    var imageURL: NSURL? {
        get {
            return self.imageURLString != nil ? NSURL(string: self.imageURLString!) : nil
        }
        
        set {
            self.imageURLString = newValue?.absoluteString
        }
    }
    
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.insertionDate = NSDate()
    }
}


extension ManagedVolume: ManagedObjectType {
    
    static var entityName: String {
        return "Volume"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "insertionDate", ascending: true)]
    }
}


extension ManagedVolume: ManagedJSONDecodable {
    
    func updateWithJSONDictionary(dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? Int, title = dictionary["name"] as? String else {
            return //This should be a throw
        }
        
        self.identifier = id
        self.title = title
        self.publisher = (dictionary as NSDictionary).valueForKeyPath("publisher.name") as? String
        self.imageURLString = (dictionary as NSDictionary).valueForKeyPath("image.small_url") as? String
        
    }
}



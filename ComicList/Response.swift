//
//  Response.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct Response {
    
    let status:Int
    let message:String
    
    var succeded: Bool {
        return self.status == 1
    }
    
    /*
    var result: JSONDictionary? {
        return payload as? JSONDictionary
    }
    
    var results: [JSONDictionary]? {
        return payload as? [JSONDictionary]
    }
    // */
    
    //private let payload: AnyObject?
    internal let payload: AnyObject?
}

extension Response:JSONDecodable {
    init?(dictionary: JSONDictionary) {
        guard let status = dictionary["status_code"] as? Int, message = dictionary["error"] as? String else {
            return nil
        }
        
        self.status = status
        self.message = message
        self.payload = dictionary["results"] //?? []
    }
}

extension Response {
    
    func result<T: JSONDecodable>()->T? {
        
        guard let dictionary = payload as? JSONDictionary else {
            return nil
        }
        
        return decode(dictionary)
    }
    
    func results<T: JSONDecodable>()->[T]? {
        
        guard let dictionaries = payload as? [JSONDictionary] else {
            return nil
        }
        
        return decode(dictionaries)
    }
}



//
//  Resource.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

typealias dict = [String:String]

enum Method:String {
    
    case GET = "GET"
    //...
}

protocol Resource {
    
    var method:Method { get }
    
    var path:String { get }
    
    var parameters: dict { get }
}


extension Resource {
    
    var method: Method {
        return .GET
    }
    
    /*
    var parameters: [String:String] {
        return[:]
    }
    // */

    func requestWithBaseURL(baseURL: NSURL) -> NSURLRequest {
        
        let URL = baseURL.URLByAppendingPathComponent(self.path)
        
        
        guard let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) else {
            
            fatalError("Unable to create URL components from \(URL)")
        }
        
        components.queryItems = parameters.map { NSURLQueryItem(name: $0, value: $1) }
        
        
        guard let finalURL = components.URL else {
            
            fatalError("Unable to retrieve a final URL")
        }
        
        
        let request = NSMutableURLRequest(URL: finalURL)
        request.HTTPMethod = self.method.rawValue
        
        
        return request
    }
}
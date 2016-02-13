//
//  Response.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

struct Response {
    
    let status:UInt
    let message:String
    
    var succeded: Bool {
        return self.status == 1
    }
    
    private let payload: AnyObject?
}

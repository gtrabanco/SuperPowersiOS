//
//  DirectoryHelpers.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

extension NSURL {
    class func temporaryFileURL() -> NSURL {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
        
        return fileURL.URLByAppendingPathComponent(NSUUID().UUIDString)
    }
    
    
    static var  documentsDirectoryURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentationDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
}

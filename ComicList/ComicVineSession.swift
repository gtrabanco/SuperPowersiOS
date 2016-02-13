//
//  ComicVineSession.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

private let comicVineKey     = "f029dbe3cd16e078ef9552e70bc7f491fe18da97"
private let comicVineBaseURL = NSURL(string: "http://www.comicvine.com/api")!

extension Session {
    // class func = static func
    class func comicVineSession() -> Session {
        return Session(baseURL: comicVineBaseURL)
    }
    
    func response(resource: Resource) -> Observable<Response> {
        return self.data(resource).map { data in
            
            guard let response: Response = decode(data) else {
                throw SessionError.CouldNotDecodeJSON
            }
            
            guard response.succeded else {
                throw SessionError.BadStatus(status: response.status, message: response.message)
            }
            
            return response
        }
    }
}

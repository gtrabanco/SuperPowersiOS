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
    
    func suggestedVolumes(query: String) -> Observable<[Volume]> {
        return self.objects(ComicVine.Suggestions(key: comicVineKey, query: query))
    }
    
    func searchVolumes(query: String, page: UInt) -> Observable<[JSONDictionary]> {
        
        return self.response(ComicVine.Search(key: comicVineKey, query: query, page: page)).map {
            response in
            
            guard let results = response.payload as? [JSONDictionary] else {
                throw SessionError.CouldNotDecodeJSON
            }
            
            return results
        }
    }
}

extension Session {
    // class func = static func
    class func comicVineSession() -> Session {
        return Session(baseURL: comicVineBaseURL)
    }
    
    func object<T:JSONDecodable>(resource: Resource) -> Observable<T> {
        return response(resource).map { r in
            guard let result: T = r.result() else {
                throw SessionError.CouldNotDecodeJSON
            }
            
            return result
        }
    }
    
    func objects<T:JSONDecodable>(resource: Resource) -> Observable<[T]> {
        return response(resource).map { r in
            guard let results: [T] = r.results() else {
                throw SessionError.CouldNotDecodeJSON
            }
            
            return results
        }
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

//
//  Session.swift
//  ComicList
//
//  Created by Gabriel Trabanco Llano on 13/2/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

enum SessionError: ErrorType {
    case CouldNotDecodeJSON
    case BadStatus(status:Int, message: String)
    case BadHTTPStatus(status:Int)
    case Other(NSError)
}

extension SessionError:CustomDebugStringConvertible {
    var debugDescription: String {
        
        switch self {
            
            case .CouldNotDecodeJSON:
                return "Could not decode JSON"
            
            case let .BadStatus(status, message):
                return "Bad status \(status), \(message)"
            
            case let .BadHTTPStatus(status):
                return "Bad HTTP Status \(status)"
            
            case let .Other(error):
                return "Other error: \(error)"
        }
    }
}

final class Session {
    
    init(baseURL: NSURL) {
        self.baseURL = baseURL
    }
    
    //MARK: - Private
    private let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    private let baseURL:NSURL
    
    
    func data(resource: Resource) -> Observable<NSData> {
        
        let request = resource.requestWithBaseURL(self.baseURL)
        
        
        return Observable.create { observer in
            
            let task = self.session.dataTaskWithRequest(request) {
                data, response, error in
                
                if let error = error {
                    
                    // TODO: manage the error
                    observer.onError(SessionError.Other(error))
                } else {
                    
                    //Check an HTTP error
                    guard let HTTPResponse = response as? NSHTTPURLResponse else {
                        fatalError("Could not get HTTP response.")
                    }
                    
                    if 200 ..< 300 ~= HTTPResponse.statusCode {
                        
                        // TODO: everything is good
                        observer.onNext(data ?? NSData())
                        observer.onCompleted()
                    } else {
                        
                        // TODO: report the error
                        observer.onError(SessionError.BadHTTPStatus(status: HTTPResponse.statusCode))
                    }
                }
            }
            
            task.resume()
            
            return AnonymousDisposable {
                task.cancel()
            }
        }
        
    }
    
}


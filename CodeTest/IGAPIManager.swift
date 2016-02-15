//
//  IGAPIManager.swift
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2015 Tactu. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionBlock = Bool -> Void

class IGAPIManager : NSObject {
    
    typealias DataHandler = AnyObject -> Void
    
    func responseHandler(completion:CompletionBlock?, handler:DataHandler) -> Response<AnyObject, NSError> -> Void {
        return { response in
            switch response.result {

            case .Success(let JSON):
                if let dict = JSON as? NSDictionary {
                    if self.checkResponse(dict) {
                        //Handle successful response
                        handler(JSON)
                    } else {
                        //If failed, return failure
                        self.handleResponseFailure(dict)
                        completion?(false)
                    }
                } else {
                    IGLog.error("Can't convert response to NSDictionary. Something's very wrong...")
                    completion?(false)
                }
                break
            
            case .Failure(let error):
                //If failed, return failure
                self.handleRequestFailure(error)
                completion?(false)
                break
            }
        }
    }
    
    // ----------------------
    // Override these methods
    // ----------------------
    
    //Handle request failures with an error
    func handleRequestFailure(error:ErrorType) {
        //Do something with the request error
    }
    
    //Sometimes request is successful but JSON contains error message. Check that here
    func checkResponse(JSON:NSDictionary) -> Bool {
        //Check the response is valid
        return true
    }
    
    //Handle error message in JSON response here
    func handleResponseFailure(JSON:NSDictionary) {
        //Do something with a response that is a failure
    }
    

    
}
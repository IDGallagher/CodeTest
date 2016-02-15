//
//  APIManager.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import Foundation
import Alamofire

class APIManager : IGAPIManager {
    
    static var shared = APIManager()
    
    //Handle request failures with an error
    override func handleRequestFailure(error: ErrorType) {
        IGLog.error("\((error as NSError).localizedDescription)")
    }
    
    //General api request with hooks for general request handling
    private func apiRequest( method: Alamofire.Method,
        _ path: String = "",
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        completion: CompletionBlock?,
        dataHandler: DataHandler ) -> Request {
            
            //Construct url
            let url:String = Constants.APIRoot + path //+ "/"
            IGLog.log("Request - \(method): \(url)")
            
            //Show activity indicator and hide on completion
            TUStatusActivityIndicator.show()
            let activityComplete:CompletionBlock = { success in
                TUStatusActivityIndicator.hide()
                completion?(success)
            }
            let activityDataHandler:DataHandler = { JSON in
                TUStatusActivityIndicator.hide()
                dataHandler(JSON)
            }
            
            return Alamofire.request(method, url, parameters: parameters).responseJSON(completionHandler: responseHandler(activityComplete, handler: activityDataHandler))
    }
    
    //Get list of sets
    func getSetList(completion:CompletionBlock? = nil) {
        apiRequest(.GET, "/api/sets/", completion: completion){ JSON in
            IGLog.log("\(JSON)")
        }
    }
    
    //Get set with a certain uid
    func getSet(uid uid:String, completion:CompletionBlock? = nil) {
        apiRequest(.GET, "/api/sets/\(uid)/", completion: completion){ JSON in
            //Parse set
            DataManager.shared.handleGetSetResponse(JSON)
            //Call api for each episode
            if let items = DataManager.shared.getItems() {
                for item in items {
                    self.getEpisode(contentUrl: item.contentUrl)
                }
            }
            completion?(true)
        }
    }
    
    //Get episode with a certain contentUrl
    func getEpisode(contentUrl contentUrl:String, completion:CompletionBlock? = nil) {
        apiRequest(.GET, contentUrl, completion: completion){ JSON in
            DataManager.shared.handleGetEpisodeResponse(JSON)
            completion?(true)
        }
    }
    
    //Get the image details from an episode's imageUrl
    func getEpisodeImage(imageUrl imageUrl:String, completion:CompletionBlock? = nil) {
        apiRequest(.GET, imageUrl, completion: completion){ JSON in
            DataManager.shared.handleGetEpisodeImageResponse(JSON)
            completion?(true)
        }
    }
}
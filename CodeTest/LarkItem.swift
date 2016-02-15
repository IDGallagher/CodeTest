//
//  LarkItem.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//


import RealmSwift

//NB: It'd be nice to use polymorphism for the different content types but RealmSwift doesn't support it yet
class LarkItem : Object {
    
    //Item
    dynamic var uid:String = ""
    dynamic var contentType:String = ""
    dynamic var position:Int = -1
    dynamic var contentUrl:String = ""
    
    //Episode
    dynamic var imageUrl:String = ""
    dynamic var title:String = ""
    dynamic var synopsis:String = ""
    dynamic var imageFileUrl:String = ""
    
    //Divider
    dynamic var heading:String = ""
    
    override class func primaryKey() -> String {
        return "uid"
    }
    
    convenience init?(itemResponse dict:NSDictionary) {
        self.init()
        
        //Item parameters
        guard
            let uid = dict["uid"] as? String,
            let contentType = dict["content_type"] as? String,
            let position = dict["position"] as? NSNumber,
            let contentUrl = dict["content_url"] as? String
            else {
                return nil
        }
        self.uid = uid
        self.contentType = contentType
        self.position = position.integerValue
        self.contentUrl = contentUrl
        
        //Divider parameters
        if contentType == "divider" {
            guard
                let heading = dict["heading"] as? String
                else {
                    return nil
            }
            self.heading = heading
        }
    }
    
    func updateWithEpisodeResponse(dict:NSDictionary) {
        guard
            let title = dict["title"] as? String,
            let synopsis = dict["synopsis"] as? String
            else {
                return
        }
        if let imageUrls = dict["image_urls"] as? NSArray, let imageUrl = imageUrls.firstObject as? String {
            self.imageUrl = imageUrl
        }
        self.title = title
        self.synopsis = synopsis
    }

    func updateWithEpisodeImageResponse(dict:NSDictionary) {
        guard
            let url = dict["url"] as? String
            else {
                return
        }
        self.imageFileUrl = url
    }
    
}

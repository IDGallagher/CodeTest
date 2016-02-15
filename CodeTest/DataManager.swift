//
//  DataManager.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import Foundation
import RealmSwift
import Bond

class DataManager : NSObject {
    
    static var shared = DataManager()
    let updatedSet = Observable<String>("")
    let updatedEpisode = Observable<String>("")
    
    func clearAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func handleGetSetResponse(JSON:AnyObject) {
        //Parse basic set info
        guard let dict = JSON as? NSDictionary, let set = LarkSet(dict:dict) else {
            return
        }
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            realm.add(set, update: true)
        }
        //Parse set items
        guard let items = dict["items"] as? NSArray else {
            return
        }
        
        for itemDict in items {
            let item  = LarkItem(itemResponse:itemDict as! NSDictionary)
            if let item = item {
                try! realm.write {
                    realm.add(item, update: true)
                    set.items.append(item)
                }
            }
        }
        let uid = set.uid
        self.updatedSet.next(uid)
    }
    
    func handleGetEpisodeResponse(JSON:AnyObject) {
        guard let dict = JSON as? NSDictionary else {
            return
        }
        //Find episode in realm
        let realm = try! Realm()
        //Search for episode by contentUrl as uid is different in episode response
        let contentUid = dict["uid"]!
        let contentUrl = "/api/episodes/\(contentUid)/"
        if let episode = realm.objects(LarkItem).filter("contentUrl = '\(contentUrl)'").first {
            try! realm.write {
                episode.updateWithEpisodeResponse(dict)
            }
            let uid = episode.uid
            self.updatedEpisode.next(uid)
            
            //If there is an image attached, call the api to fetch it
            if episode.imageUrl != "" {
                APIManager.shared.getEpisodeImage(imageUrl: episode.imageUrl)
            }
        }
    }
    
    func handleGetEpisodeImageResponse(JSON:AnyObject) {
        guard let dict = JSON as? NSDictionary else {
            return
        }
        //Find episode in realm
        let realm = try! Realm()
        //Search for episode by contentUrl as uid is different in episode response
        let contentUrl = dict["content_url"]!
        if let episode = realm.objects(LarkItem).filter("contentUrl = '\(contentUrl)'").first {
            try! realm.write {
                episode.updateWithEpisodeImageResponse(dict)
            }
            let uid = episode.uid
            self.updatedEpisode.next(uid)
        }
    }
    
    func getSet() -> LarkSet? {
        let realm = try! Realm()
        return realm.objects(LarkSet).first
    }
    
    func getItems() -> Results<LarkItem>? {
        guard let set = getSet() else {
            return nil
        }
        return set.items.sorted("position", ascending: true)
    }
    
    func getEpisode(uid:String) -> LarkItem? {
        let realm = try! Realm()
        return realm.objects(LarkItem).filter("uid = '\(uid)'").first
    }
    
}
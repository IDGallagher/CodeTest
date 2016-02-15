//
//  Set.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import RealmSwift

class LarkSet : Object {
    
    dynamic var uid:String = ""
    dynamic var title:String = ""
    
    let items = List<LarkItem>()
    
    override class func primaryKey() -> String {
        return "uid"
    }
    
    convenience init?(dict:NSDictionary) {
        self.init()
        guard
            let uid = dict["uid"] as? String,
            let title = dict["title"] as? String
            else {
                return nil
        }
        self.uid = uid
        self.title = title
    }
}

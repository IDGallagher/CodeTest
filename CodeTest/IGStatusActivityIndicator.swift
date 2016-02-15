//
//  IGStatusActivityIndicator.swift
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2015 Tactu. All rights reserved.
//

import UIKit

class TUStatusActivityIndicator {
    
    static var counter:Int = 0
    
    static func show() {
        if counter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        counter++
    }
    
    static func hide() {
        counter--
        if counter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
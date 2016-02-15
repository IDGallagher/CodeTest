//
//  IGLog.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import Foundation

public enum IGLoggingLevel : Int {
    case Default = 0
    case Warning = 1
    case Error = 2
}


public class IGLog {
    
    public class func log(message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            
            let fileNameWithExtension : String = NSString(format: "%@", file).lastPathComponent
            
            #if DEBUG
                
            #else
                print("[..] - \(fileNameWithExtension) -- \(function), Line [\(line)] -- \"\(message)\"")
            #endif
    }
    
    public class func error(message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            logLevel(message, level: .Error, function: function, file: file, line: line)
    }
    
    public class func logLevel(message: String,
        level: IGLoggingLevel,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            
            let fileNameWithExtension : NSString = NSString(format: "%@", file).lastPathComponent
            
            #if DEBUG
                
                
            #else
                print("\(loggingLevelString(level)) - \(fileNameWithExtension) -- \(function), Line [\(line)] -- \"\(message)\"")
                
            #endif
    }
    
    private class func loggingLevelString (level : IGLoggingLevel) -> String {
        
        var logLevel : String = "[..]"
        
        switch (level) {
        case (.Default):
            logLevel = "[..]"
        case (.Warning):
            logLevel = "[WARNING]"
        case (.Error):
            logLevel = "[ERROR]"
        }
        
        return logLevel
    }
    
}
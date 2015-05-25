//
//  SKObject.swift
//  SketchMe
//
//  Created by Frank Luan on 11/11/14.
//  Copyright (c) 2014 SketchMe. All rights reserved.
//

/**
Casts to an NSDictionary for JSON Deserialization

:param: object AnyObject, preferably from a network response

:returns: NSDictionary or nil
*/
func JSON(object: AnyObject?) -> NSDictionary? {
    return object as? NSDictionary
}

/**
Casts to an NSArray for JSON Deserialization

:param: object AnyObject, preferably from a network response

:returns: NSArray or an empty array
*/
func JSONArray(object: AnyObject?) -> NSArray {
    return (object as? NSArray) ?? []
}

extension NSDictionary {
    
    func bool(key: String) -> Bool? {
        return objectForKey(key) as? Bool
    }
    
    func boolValue(key: String) -> Bool {
        return bool(key) ?? false
    }
    
    func int(key: String) -> Int? {
        return objectForKey(key) as? Int
    }
    
    func intValue(key: String) -> Int {
        return int(key) ?? 0
    }
    
    func uInt(key: String) -> UInt? {
        return objectForKey(key) as? UInt
    }
    
    func uIntValue(key: String) -> UInt {
        return uInt(key) ?? 0
    }
    
    func string(key: String) -> String? {
        return objectForKey(key) as? String
    }
    
    func stringValue(key: String) -> String {
        return string(key) ?? ""
    }
    
    func objectForKeyAs<T>(key: String) -> T? {
        return objectForKey(key) as? T
    }
    
}

//
//  CHHTTPRequestSerializer.swift
//  Chartis
//
//  Created by Frank Luan on 5/24/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

import UIKit
import AFNetworking

class CHHTTPRequestSerializer: AFHTTPRequestSerializer {
    
    override func requestWithMethod(method: String!, URLString: String!, parameters: AnyObject!, error: NSErrorPointer) -> NSMutableURLRequest! {
        let mutableRequest = super.requestWithMethod(method, URLString: URLString, parameters: parameters, error: error)
        mutableRequest.timeoutInterval = 10 as NSTimeInterval
        mutableRequest.cachePolicy = .ReloadIgnoringLocalCacheData
        return mutableRequest
    }
    
}

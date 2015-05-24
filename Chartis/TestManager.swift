//
//  TestManager.swift
//  Chartis
//
//  Created by Frank Luan on 5/24/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

let APIServerAddressString = "http://192.168.2.3:3000"
//let APIServerAddressString = "https://api.sketch-off.com"
private let baseURLString = APIServerAddressString + "/api/v1/"

import UIKit
import AFNetworking
import CocoaLumberjack

class TestManager: AFHTTPSessionManager {
    
    static let sharedInstance = TestManager()
    
    var sessionToken = "fvLby9faKaIioREPztO9QA_V1zZQ2hUo8FxcLN-3"
    
    var testGroup1 = [
        TestItem(key: "feed.10", displayName: "News Feed Loading (10 items)", endpoint: "me/news_feed"),
        TestItem(key: "sketch.1", displayName: "Sketch Detail Loading", endpoint: "sketches/1")
    ]
    
    init() {
        let baseURL = NSURL(string: baseURLString)
        super.init(baseURL: baseURL, sessionConfiguration: nil)
        requestSerializer = CHHTTPRequestSerializer()
        responseSerializer = AFJSONResponseSerializer()
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - API Methods
    
    func fetchAvailableSessionToken() {
        
    }
    
    /// Returns whether the test is successfully initiated
    func runTest(item: TestItem) -> Bool {
        if item.running {
            DDLogWarn("\(item) is running. Aborting.")
            return false
        }
        item.running = true
        DDLogInfo("Starting \(item)")
        let startTime = NSDate()
        let dataTask = self.dataTaskWithHTTPMethod(item.method, URLString: item.endpoint, parameters: item.parameters, success: { (dataTask, resp) in
            let endTime = NSDate()
            let duration = endTime.timeIntervalSinceDate(startTime)
            item.resultTime = duration
            item.setNeedsDisplay()
            item.running = false
            DDLogInfo("Completing \(item)")
        }, failure: { (dataTask, error) in
            NSLog("error \(error)")
            let endTime = NSDate()
            let duration = endTime.timeIntervalSinceDate(startTime)
            item.resultTime = duration
            item.setNeedsDisplay()
            item.running = false
            DDLogInfo("Failing \(item)")
        })
        dataTask.resume()
        return true
    }
    
    override func dataTaskWithRequest(request: NSURLRequest!, completionHandler: ((NSURLResponse!, AnyObject!, NSError!) -> Void)!) -> NSURLSessionDataTask! {
        let req = request.mutableCopy() as! NSMutableURLRequest
        req.setValue(sessionToken, forHTTPHeaderField: "X-Session-Token")
        return super.dataTaskWithRequest(req, completionHandler: completionHandler)
    }
    
}

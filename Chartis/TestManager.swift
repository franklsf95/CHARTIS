//
//  TestManager.swift
//  Chartis
//
//  Created by Frank Luan on 5/24/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import CocoaLumberjack
import INTULocationManager

class TestManager: AFHTTPSessionManager {
    
    static let sharedInstance = TestManager()
    
    // Testing parameters
    
    var sessionToken = "1Ky0BbnFNG7Af1KcfAiPV4boj4Fnx2BS1sl1I9PA"
    
    // Testing items
    
    var testItems = [
        TestItem(key: "sketch_o@aws_s3_us-west-2", displayName: "Sketch Original Image (S3 us-west-2)", URL: "http://s3-us-west-2.amazonaws.com/delta-epsilon/sketches/1XCKRpedTaqv47_94tyr7Q_o.jpg"),
        TestItem(key: "sketch_v@aws_s3_us-west-2", displayName: "Sketch Overlay Image (S3 us-west-2)", URL: "http://s3-us-west-2.amazonaws.com/delta-epsilon/sketches/kEtwHZnRRYeNghLfNn55xw_v.png"),
        TestItem(key: "avatar_t@aws_s3_us-west-2", displayName: "Thumbnail Image (S3 us-west-2)", URL: "http://s3-us-west-2.amazonaws.com/delta-epsilon/sketches/OSsPotgkSuadLLMB2gXPOw_t.jpg"),
        TestItem(key: "sketch_o@aws_cdn_us-west-2", displayName: "Sketch Original Image (CDN AWS)", URL: "http://d2q7yc5ylbbgu9.cloudfront.net/sketches/1XCKRpedTaqv47_94tyr7Q_o.jpg"),
        TestItem(key: "sketch_v@aws_cdn_us-west-2", displayName: "Sketch Overlay Image (CDN AWS)", URL: "http://d2q7yc5ylbbgu9.cloudfront.net/sketches/kEtwHZnRRYeNghLfNn55xw_v.png"),
        TestItem(key: "avatar_t@aws_cdn_us-west-2", displayName: "Thumbnail Image (CDN AWS)", URL: "http://d2q7yc5ylbbgu9.cloudfront.net/sketches/OSsPotgkSuadLLMB2gXPOw_t.jpg"),
        TestItem(key: "sketch_o@aws_cdn_us-west-2", displayName: "Sketch Original Image (CDN qiniu)", URL: "http://7xjbn3.com1.z0.glb.clouddn.com/sketches/1XCKRpedTaqv47_94tyr7Q_o.jpg"),
        TestItem(key: "sketch_v@aws_cdn_us-west-2", displayName: "Sketch Overlay Image (CDN qiniu)", URL: "http://7xjbn3.com1.z0.glb.clouddn.com/sketches/kEtwHZnRRYeNghLfNn55xw_v.png"),
        TestItem(key: "avatar_t@aws_cdn_us-west-2", displayName: "Thumbnail Image (CDN qiniu)", URL: "http://7xjbn3.com1.z0.glb.clouddn.com/sketches/OSsPotgkSuadLLMB2gXPOw_t.jpg"),
        TestItem(key: "feed", displayName: "News Feed Loading", endpoint: "me/news_feed"),
        TestItem(key: "feed_availability", displayName: "News Feed Availability Check", endpoint: "me/news_feed/available", parameters: ["bottom": "2015-05-25T16:58:45.000-0700"]),
        TestItem(key: "notifications", displayName: "Notifications Loading", endpoint: "notifications"),
        TestItem(key: "notifications_count", displayName: "Unread Count Fetching", endpoint: "me/notifications_count"),
        TestItem(key: "sketch", displayName: "Sketch Detail Loading", endpoint: "sketches/2642"),
        TestItem(key: "friends", displayName: "Friends List Loading", endpoint: "friends/all"),
        TestItem(key: "friends_recent", displayName: "Recent Friends Loading", endpoint: "friends/recent"),
        TestItem(key: "user", displayName: "User Profile Loading (Small)", endpoint: "users/30"),
        TestItem(key: "user", displayName: "User Profile Loading (Large)", endpoint: "users/76081")
    ]
    
    var executing = false
    
    // MARK: - Constructors
    
    init() {
        super.init(baseURL: nil, sessionConfiguration: nil)
        requestSerializer = CHHTTPRequestSerializer()
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - API Methods
    
    var allTestsCompleted = false
    
    func runAllTests(completion: (Void -> Void)?) {
        runAllTests(0, completion: completion)
    }
    
    func runAllTests(currentIndex: Int, completion: (Void -> Void)?) {
        let item = self.testItems[currentIndex]
        runTest(item) { (_) in
            if currentIndex < count(self.testItems) - 1 {
                self.runAllTests(currentIndex + 1, completion: completion)
            } else {
                // Completion
                self.allTestsCompleted = true
                completion?()
            }
        }
    }
    
    /// Skip the first request, then measure the next 3 requests
    func runTest(item: TestItem, completion: (NSTimeInterval -> Void)?) {
        DDLogInfo("--- Start testing \(item) at \(item.URLString)")
        // Skip 1
        self.runSingleTest(item, discardResult: true) { (_) in
            // Trial 1
            self.runSingleTest(item) { (_) in
                // Trial 2
                self.runSingleTest(item) { (_) in
                    // Trial 3
                    self.runSingleTest(item) { (_) in
                        // Completion
                        var acc = 0 as Double
                        for result in item.results {
                            acc += result
                        }
                        let mean = (acc / Double(item.results.count)) as NSTimeInterval
                        
                        item.result = mean
                        item.setNeedsDisplay()
                        DDLogInfo("--- Result for \(item): \(mean)")
                        completion?(item.result)
                    }
                }
            }
        }
    }
    
    func runSingleTest(item: TestItem, discardResult: Bool = false, completion: (NSTimeInterval -> Void)?) {
        if self.executing {
            DDLogWarn("\t\t\(item) is running. Aborting.")
            return
        }
        self.executing = true
        DDLogDebug("\t\tRunning \(item)")
        switch (item.responseType) {
        case .JSON:
            self.responseSerializer = AFJSONResponseSerializer()
        case .Image:
            self.responseSerializer = AFImageResponseSerializer()
        }
        let startTime = NSDate()
        let dataTask = self.dataTaskWithHTTPMethod(item.method, URLString: item.URLString, parameters: item.parameters, success: { (dataTask, resp) in
            let endTime = NSDate()
            let duration = endTime.timeIntervalSinceDate(startTime)
            item.result = duration
            item.setNeedsDisplay()
            if !discardResult {
                item.results.append(duration)
            }
            self.executing = false
            completion?(item.result)
        }, failure: { (dataTask, error) in
            DDLogError("\t\tError \(error)")
            item.result = NSTimeInterval(TestRunFailed)
            item.setNeedsDisplay()
            self.executing = false
            DDLogDebug("\t\tFailing \(item)")
            completion?(item.result)
        })
        dataTask.resume()
    }
    
    override func dataTaskWithRequest(request: NSURLRequest!, completionHandler: ((NSURLResponse!, AnyObject!, NSError!) -> Void)!) -> NSURLSessionDataTask! {
        let req = request.mutableCopy() as! NSMutableURLRequest
        req.setValue(sessionToken, forHTTPHeaderField: "X-Session-Token")
        return super.dataTaskWithRequest(req, completionHandler: completionHandler)
    }
    
    // MARK: - Location
    
    func requestForCurrentLocation(completion: (String -> Void)?) {
        INTULocationManager.sharedInstance().requestLocationWithDesiredAccuracy(.City, timeout: 5.0, delayUntilAuthorized: true) { (location, accuracy, status) in
            if status == .Success || status == .TimedOut {
                if let location = location {
                    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                        if let placemark = placemarks.first as? CLPlacemark {
                            let country = placemark.country
                            let state = placemark.administrativeArea
                            let city = placemark.locality
                            let address = "\(city), \(state), \(country)"
                            DDLogInfo("Current Location: \(address)")
                            completion?(address)
                        }
                    }
                }
            }
            DDLogInfo("Failed to fetch current location")
            completion?("")
        }
    }
    
    // MARK: - CSV Output
    
    func CSVData() -> NSData {
        let csvString = CSVString() as NSString
        return csvString.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    func CSVString() -> String {
        var csv = "key,result (ms),displayName,method,URL,results\n"
        for item in self.testItems {
            csv += "\"\(item.key)\","
            csv += String(format: "\"%.0lf\",", item.result * 1000)
            csv += "\"\(item.displayName)\","
            csv += "\"\(item.method)\","
            csv += "\"\(item.URLString)\","
            csv += "\"\(item.results)\"\n"
        }
        return csv
    }
    
}

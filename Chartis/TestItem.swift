//
//  TestItem.swift
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

//private let APIServerAddressString = "http://192.168.2.3:3000"
private let APIServerAddressString = "https://api.sketch-off.com"
private let baseURLString = APIServerAddressString + "/api/v1/"

import UIKit

enum TestItemResponseType: Int {
    case JSON, Image
}

/// A TestItem encapsulates all parameters required to test on a single API endpoint
class TestItem: NSObject {
    
    var key = ""
    var displayName = ""
    
    var method = "GET"
    var URLString = ""
    var parameters: NSDictionary?
    var responseType = TestItemResponseType.JSON
    
    var result = NSTimeInterval(TestRunNeverStarted)
    var results = [NSTimeInterval]()
    
    weak var delegate: TestItemDisplayDelegate?
    
    // MARK: - Methods
    
    override var description: String {
        return "<TestItem: \(key)>"
    }
    
    init(key: String, displayName: String, URL: String, responseType: TestItemResponseType = .Image) {
        self.key = key
        self.displayName = displayName
        self.URLString = URL
        self.responseType = responseType
    }
    
    init(key: String, displayName: String, method: String = "GET", endpoint: String, parameters: NSDictionary? = nil, responseType: TestItemResponseType = .JSON) {
        self.key = key
        self.displayName = displayName
        self.method = method
        self.URLString = baseURLString + endpoint
        self.parameters = parameters
        self.responseType = responseType
    }
    
    // MARK: - Delegate Methods
    
    func setNeedsDisplay() {
        delegate?.updateDisplay()
    }
   
}

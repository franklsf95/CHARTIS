//
//  TestItem.swift
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

import UIKit

/// A TestItem encapsulates all parameters required to test on a single API endpoint
class TestItem: NSObject {
    
    var key = ""
    var displayName = ""
    
    var method = "GET"
    var endpoint = ""
    var parameters: NSDictionary?
    
    var running = false
    var resultTime: NSTimeInterval = -1
    
    weak var delegate: TestItemDisplayDelegate?
    
    // MARK: - Methods
    
    override var description: String {
        return "<TestItem: \(key)>"
    }
    
    init(key: String, displayName: String, method: String = "GET", endpoint: String, parameters: NSDictionary? = nil) {
        self.key = key
        self.displayName = displayName
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
    }
    
    // MARK: - Delegate Methods
    
    func setNeedsDisplay() {
        delegate?.updateDisplay()
    }
   
}

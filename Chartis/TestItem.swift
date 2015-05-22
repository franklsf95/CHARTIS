//
//  TestItem.swift
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

import UIKit

class TestItem: NSObject {
    
    dynamic var key = ""
    dynamic var displayName = ""
    dynamic var resultTime: NSTimeInterval = 0
    
    override var description: String {
        return "TestItem{\(key)}"
    }
    
    init(key: String, displayName: String) {
        self.key = key
        self.displayName = displayName
    }
   
}

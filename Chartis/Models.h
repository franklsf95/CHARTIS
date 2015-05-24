//
//  Models.h
//  Chartis
//
//  Created by Frank Luan on 5/24/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#ifndef Chartis_Models_h
#define Chartis_Models_h

#import <Foundation/Foundation.h>

#define TestRunNeverStarted -1000
#define TestRunFailed -1001

@class TestItem;

@protocol TestItemDisplayDelegate <NSObject>

@property (nonatomic, strong) TestItem *testItem;
- (void)updateDisplay;

@end

#endif

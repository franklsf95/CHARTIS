//
//  TestItemTableViewCell.h
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TestItemTableViewCell : UITableViewCell

@property (nonatomic, weak) RootViewController *delegate;
@property (nonatomic, strong) TestItem *testItem;

@end

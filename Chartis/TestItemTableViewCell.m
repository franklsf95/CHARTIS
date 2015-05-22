//
//  TestItemTableViewCell.m
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#import "TestItemTableViewCell.h"

@interface TestItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet MKButton *testButton;

@end

@implementation TestItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setTestItem:(TestItem *)testItem {
    _testItem = testItem;
    
    self.displayNameLabel.text = testItem.displayName;
}

@end

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
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation TestItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.resultLabel.textColor = [UIColor chartisOrange];
}

- (void)setTestItem:(TestItem *)testItem {
    _testItem = testItem;
    testItem.delegate = self;
    [self updateDisplay];
}

- (IBAction)testButtonTouched:(UIButton *)sender {
    [[TestManager sharedInstance] runTest:self.testItem];
}

- (void)updateDisplay {
    self.displayNameLabel.text = self.testItem.displayName;
    if (self.testItem.resultTime >= 0) {
        self.resultLabel.text = [NSString stringWithFormat:@"%.0lfms", self.testItem.resultTime * 1000];
    } else {
        self.resultLabel.text = @"--";
    }
}

@end

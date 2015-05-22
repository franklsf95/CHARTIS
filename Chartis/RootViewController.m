//
//  ViewController.m
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#import "RootViewController.h"
#import "TestItemTableViewCell.h"

enum {
    SectionAPITesting = 0
};

static NSString * const CellTestItem = @"CellTestItem";

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MKButton *startButton;

@property (nonatomic, copy) NSArray *testItems;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup background gradient
    
    _gradientLayer = [CAGradientLayer layer];
    CGColorRef color1 = [UIColor colorWithHex:0x1F2841].CGColor;
    CGColorRef color2 = [UIColor colorWithHex:0x001325].CGColor;
    _gradientLayer.colors = [NSArray arrayWithObjects:(__bridge id)color1, (__bridge id)color2, nil];
    [self.view.layer insertSublayer:_gradientLayer atIndex:0];
    
    // Setup UI - header
    
    self.startButton.backgroundColor = [UIColor chartisOrange];
    self.startButton.backgroundLayerColor = [UIColor chartisOrange];
    
    // Setup table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TestItemTableViewCell" bundle:nil] forCellReuseIdentifier:CellTestItem];
    
    // Initialize test items
    
    self.testItems = @[[[TestItem alloc] initWithKey:@"feed.10" displayName:@"News Feed Loading (10 items)"],
                       [[TestItem alloc] initWithKey:@"sketch.1" displayName:@"Sketch Detail Loading"]
                       ];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

#pragma mark - Table View styling

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SectionAPITesting) {
        return [self.testItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionAPITesting) {
        TestItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTestItem forIndexPath:indexPath];
        cell.delegate = self;
        cell.testItem = self.testItems[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - Table View headers





@end

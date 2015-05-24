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

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MKButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *serverAddressTextField;

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
    
    // Setup UI - footer
    
    self.serverAddressTextField.layer.borderColor = [UIColor clearColor].CGColor;
    self.serverAddressTextField.delegate = self;
    self.serverAddressTextField.text = [[[TestManager sharedInstance] baseURL] absoluteString];
    
    // Tune in notifications
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    // Setup table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TestItemTableViewCell" bundle:nil] forCellReuseIdentifier:CellTestItem];
    
    // Initialize test items
    
    self.testItems = [[TestManager sharedInstance] testGroup1];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


#pragma mark - Text Field delegate

- (void)handleKeyboardWillChange:(NSNotification *)notification {
    DDLogVerbose(@"%@ handles notification %@", NSStringFromClass([self class]), notification.name);
    NSNumber *curveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    CGFloat height = 0;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        NSValue *endFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        height = CGRectGetHeight([endFrameValue CGRectValue]);
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:[durationNumber doubleValue] delay:0 options:animationOptionsWithCurve([curveNumber integerValue]) animations:^{
        self.contentViewBottomConstraint.constant = height;
        [self.view layoutIfNeeded];
    } completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end

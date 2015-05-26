//
//  ViewController.m
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#import "RootViewController.h"
#import "TestItemTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "AppDelegate.h"

enum {
    SectionAPITesting = 0
};

static NSString * const CellTestItem = @"CellTestItem";

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, copy) NSString *currentLocationString;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MKButton *startButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *testingIndicator;
@property (weak, nonatomic) IBOutlet MKButton *sendButton;
@property (weak, nonatomic) IBOutlet MKLabel *versionLabel;

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
    
    NSAttributedString *aStr;
    aStr = [[NSAttributedString alloc] initWithString:@"TEST ALL" attributes:@{NSKernAttributeName: @1, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.startButton setAttributedTitle:aStr forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor chartisOrange];
    self.startButton.backgroundLayerColor = [UIColor chartisOrange];
    
    // Setup UI - footer
    
    aStr = [[NSAttributedString alloc] initWithString:@"SEND REPORT" attributes:@{NSKernAttributeName: @1, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.sendButton setAttributedTitle:aStr forState:UIControlStateNormal];
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *buildDate = [NSString stringWithUTF8String:__DATE__];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ \u03B1    %@", shortVersion, buildDate];
    
    // Tune in notifications
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    // Setup table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TestItemTableViewCell" bundle:nil] forCellReuseIdentifier:CellTestItem];
    
    // Initialize test items
    
    self.testItems = [[TestManager sharedInstance] testItems];
    [[TestManager sharedInstance] requestForCurrentLocation:^(NSString *locationString) {
        self.currentLocationString = locationString;
    }];
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
        cell.backgroundColor = [UIColor clearColor];
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

#pragma mark - Action buttons

- (IBAction)startButtonTouched:(UIButton *)sender {
    [self.testingIndicator startAnimating];
    [[TestManager sharedInstance] runAllTests:^{
        [self.testingIndicator stopAnimating];
        [UIView animateWithDuration:DefaultAnimationDuration animations:^{
            self.sendButton.backgroundColor = [UIColor chartisBlue];
            self.sendButton.backgroundLayerColor = [UIColor chartisBlue];
        }];
    }];
}

#pragma mark - Email submission

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendButtonTouched:(UIButton *)sender {
    if (![[TestManager sharedInstance] allTestsCompleted]) {
        [self alertTestsNotCompleted];
        return;
    }
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setSubject:[self emailTitle]];
    [mail setMessageBody:[self emailMessage] isHTML:NO];
    [mail setToRecipients:@[@"frank@sketchme.co"]];
    [mail addAttachmentData:[[TestManager sharedInstance] CSVData] mimeType:@"text/csv" fileName:[NSString stringWithFormat:@"%@.csv", [self testResultTitle]]];
    [mail addAttachmentData:[self applicationLogData] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.log", [self testResultTitle]]];
    [self presentViewController:mail animated:YES completion:NULL];
}

- (void)alertTestsNotCompleted {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"No test results available. Please run all tests first!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - Test Result data source

- (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)currentCarrierString {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    return [carrier carrierName];
}

- (NSString *)testResultTitle {
    return [NSString stringWithFormat:@"%@ %@ %@", [self currentDateString], [self currentCarrierString], [self currentLocationString]];
}

- (NSString *)emailTitle {
    return [NSString stringWithFormat:@"SketchMe Benchmarking Result %@", [self testResultTitle]];
}

- (NSString *)emailMessage {
    return @"Hi Frank! Attached is my test result.";
}

- (NSData *)applicationLogData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate applicationLogData];
}

@end

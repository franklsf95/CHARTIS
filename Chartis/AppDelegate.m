//
//  AppDelegate.m
//  Chartis
//
//  Created by Frank Luan on 5/21/15.
//  Copyright (c) 2015 SketchOff. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>

@interface AppDelegate ()

@property (nonatomic, copy) NSString *logFilePath;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // Add file logger
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;  // weekly
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    [DDLog addLogger:fileLogger];
    self.logFilePath = [[fileLogger currentLogFileInfo] filePath];
    
    DDLogInfo(@"====== C.H.A.R.T.I.S. starting up");

    [[PgyManager sharedPgyManager] startManagerWithAppId:@"0799efaeeefdf59499b831f0bc8421e0"];
    [[PgyManager sharedPgyManager] checkUpdate];

    return YES;
}

- (NSData *)applicationLogData {
    return [[NSFileManager defaultManager] contentsAtPath:self.logFilePath];
}

@end

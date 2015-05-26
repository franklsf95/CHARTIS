//
//  Styling.m
//  SketchMe
//
//  Created by Frank Luan on 12/6/14.
//  Copyright (c) 2014 Frank Luan. All rights reserved.
//

#import "Styling.h"

@implementation UIColor (SketchMe)

+ (instancetype)colorWithHex:(NSInteger)hex
{
    return [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16))/255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)themeAdjustedYellow
{
    return UIColorFromHex(0xFAEB2C);
}

+ (UIColor *)darkBlack
{
    return UIColorFromHex(0x1D1D1D);
}

+ (UIColor *)themeBlack
{
    return UIColorFromHex(0x333333);
}

+ (UIColor *)themeWhite
{
    return UIColorFromHex(0xF8F8F8);
}

+ (UIColor *)themeRed
{
    return UIColorFromHex(0xE64C3C);
}

+ (UIColor *)themeYellow
{
    return UIColorFromHex(0xF9E900);
}

+ (UIColor *)themeGreen
{
    return UIColorFromHex(0x0FDA6E);
}

+ (UIColor *)themeMagenta;
{
    return UIColorFromHex(0xF333B5);
}

+ (UIColor *)themeBlue
{
    return UIColorFromHex(0x08BAF9);
}

+ (UIColor *)themeOrange
{
    return UIColorFromHex(0xF37D33);
}

+ (UIColor *)chartisOrange
{
    return UIColorFromHex(0xFF3824);
}

+ (UIColor *)chartisBlue
{
    return UIColorFromHex(0x0076FF);
}

+ (UIColor *)themeRandom
{
    static NSUInteger previousIndex = -1;
    NSUInteger index;
    NSUInteger count = [[UIColor spectrum] count];
    while (true) {
        index = arc4random_uniform((unsigned int)count);
        if (index != previousIndex) break;
    }
    previousIndex = index;
    return [UIColor spectrum][index];
}

+ (NSArray *)spectrum
{
    return @[UIColorFromHex(0xF37D33),		// orange
             UIColorFromHex(0xF333B5),		// purple
             UIColorFromHex(0x0FDA6E),		// green
             UIColorFromHex(0x08BAF9),		// blue
             UIColorFromHex(0x27DAD6),		// teal
             UIColorFromHex(0xE64C3C)];		// theme red
}

@end

@implementation UIView (Styling)

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)addShadow
{
    [self addShadowWithOffset:CGSizeMake(0, 2)];
}

- (void)addShadowWithOffset:(CGSize)offset
{
    [self addShadowWithOpacity:0.2 offset:offset];
}

- (void)addShadowWithOpacity:(CGFloat)opacity offset:(CGSize)offset
{
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)sk_setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated) {
        [UIView transitionWithView:self duration:DefaultAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.hidden = hidden;
        } completion:nil];
    } else {
        self.hidden = hidden;
    }
}

@end

@implementation UINavigationController (Styling)

- (void)applyBlackTitle
{
    self.navigationBar.tintColor = [UIColor themeBlack];
    NSMutableDictionary *attr = [self.navigationBar.titleTextAttributes mutableCopy];
    [attr setObject:[UIColor themeBlack] forKey:NSForegroundColorAttributeName];
    [self.navigationBar setTitleTextAttributes:attr];
}

- (void)applyWhiteTitle
{
    self.navigationBar.tintColor = [UIColor themeWhite];
    NSMutableDictionary *attr = [self.navigationBar.titleTextAttributes mutableCopy];
    attr[NSForegroundColorAttributeName] = [UIColor themeWhite];
    [self.navigationBar setTitleTextAttributes:[attr copy]];
}

- (void)applyStyling
{    
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:adaptFor5_6(16, 17)]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:adaptFor5_6(15, 17)]} forState:UIControlStateNormal];
    
    self.navigationBar.translucent = YES;
    
    // Font for Table view header
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:13]];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (void)pop
{
    [self popViewControllerAnimated:YES];
}

@end

@implementation UIViewController (Styling)

- (UIView *)lineWithColor:(UIColor *)color
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.navigationController.navigationBar.frame), CGRectGetWidth(self.navigationController.navigationBar.frame), 1)];
    lineView.backgroundColor = color;
    return lineView;
}

@end

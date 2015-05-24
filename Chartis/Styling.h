//
//  Styling.h
//  SketchMe
//
//  Created by Frank Luan on 12/6/14.
//  Copyright (c) 2014 Frank Luan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DefaultAnimationDuration 0.3 // seconds
#define ImageFadeInDuration 0.25 // seconds
#define HUDMinimumDisplayTime 0.5 // seconds
#define DefaultCornerRadius 4

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16))/255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF))/255.0 alpha:1.0]
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define iPhone4Height 480
#define iPhone5Height 568
#define iPhone6Height 667
#define iPhone5Width 320
#define iPhone6Width 375
#define iPhone6pWidth 414

#define ScreenHighAs(y) (ScreenHeight >= (y))
#define ScreenWideAs(x) (ScreenWidth >= (x))
#define adaptFor4_5_6(w, x, y) (ScreenHighAs(iPhone5Height) ? ((ScreenHighAs(iPhone6Height) ? (y) : (x))) : (w))
#define adaptFor5_6(x, y) (ScreenWideAs(iPhone6Width) ? (y) : (x))
#define adaptFor5_6_p(x, y, z) (ScreenWideAs(iPhone6Width) ? ((ScreenWideAs(iPhone6pWidth) ? (z) : (y))) : (x))
#define autoAdapt(x) ((x) * ScreenWidth / iPhone6Width)

#define SketchSize 1080

#define AccessoryHeight adaptFor4_5_6(40, 60, 70)

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
}

@interface UIColor (Styling)

+ (instancetype)colorWithHex:(NSInteger)hex;
/// 0xFAEB2C
+ (UIColor *)themeAdjustedYellow;
/// 0x1D1D1D
+ (UIColor *)darkBlack;
/// 0x333333
+ (UIColor *)themeBlack;
/// 0xF8F8F8
+ (UIColor *)themeWhite;
/// 0xE64C3C
+ (UIColor *)themeRed;
/// 0xF9E900
+ (UIColor *)themeYellow;
/// 0x0FDA6E
+ (UIColor *)themeGreen;
/// 0xF333B5
+ (UIColor *)themeMagenta;
/// 0x08BAF9
+ (UIColor *)themeBlue;
/// 0xF37D33
+ (UIColor *)themeOrange;
/// 0xFF3824
+ (UIColor *)chartisOrange;
+ (UIColor *)themeRandom;
+ (NSArray *)spectrum;

@end

@interface UIView (Styling)

- (void)setCornerRadius:(CGFloat)radius;
- (void)addShadow;
- (void)addShadowWithOffset:(CGSize)offset;
- (void)addShadowWithOpacity:(CGFloat)opacity offset:(CGSize)offset;
- (void)sk_setHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@interface UINavigationController (Styling)

- (void)applyStyling;
- (void)applyBlackTitle;
- (void)applyWhiteTitle;
- (void)pop;

@end

@interface UIViewController (Styling)

- (UIView *)lineWithColor:(UIColor *)color;

@end
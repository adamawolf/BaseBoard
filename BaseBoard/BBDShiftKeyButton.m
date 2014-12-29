//
//  BBDShiftKeyButton.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDShiftKeyButton.h"

@implementation BBDShiftKeyButton

- (UIColor *)backgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark &&
        [self.dataSource shiftKeyState] != BBDShiftKeyStateLowercase) {
        //special background color for darkmode capilized states
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(208.0f / 255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
            static UIColor *_darkColor = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _darkColor = [UIColor colorWithWhite:(60.0f / 255.0f) alpha:1.0f];
            });
            color = _darkColor;
        } else {
            static UIColor *_lightColor = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _lightColor = [UIColor colorWithRed:(168.0f / 255.0f) green:(179.0f / 255.0f) blue:(186.0f / 255.0f) alpha:1.0f];
            });
            color = _lightColor;
        }
    }
    
    return color;
}

- (UIColor *)highlightedBackgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(40.0f / 255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor colorWithRed:(128.0f / 255.0f) green:(139.0f / 255.0f) blue:(146.0f / 255.0f) alpha:1.0f];
        });
        color = _lightColor;
    }
    
    return color;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //draw the appropriate shift key image
    UIImage *shiftKeyImage = nil;
    if ([self.dataSource shiftKeyState] == BBDShiftKeyStateLowercase) {
        shiftKeyImage = [UIImage imageNamed:@"shift_portrait"];
        shiftKeyImage = [shiftKeyImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor whiteColor] set];
    } else if ([self.dataSource shiftKeyState] == BBDShiftKeyStateUppercase) {
        shiftKeyImage = [UIImage imageNamed:@"shift_portrait"];
        shiftKeyImage = [shiftKeyImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor blackColor] set];
    } else if ([self.dataSource shiftKeyState] == BBDShiftKeyStateCapsLock) {
        shiftKeyImage = [UIImage imageNamed:@"shift_lock_portrait"];
        shiftKeyImage = [shiftKeyImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor blackColor] set];
    }
    
    CGRect keyFrame = [self keyFrame];
    CGPoint centerPoint = CGPointMake(keyFrame.origin.x + keyFrame.size.width / 2.0f, keyFrame.origin.y + keyFrame.size.height / 2.0f);
    CGPoint imageTopLeft = CGPointMake(centerPoint.x - (shiftKeyImage.size.width / 2.0f),
                                       centerPoint.y - (shiftKeyImage.size.height / 2.0f));
    [shiftKeyImage drawAtPoint:imageTopLeft blendMode:kCGBlendModeNormal alpha:1.0f];
}

@end

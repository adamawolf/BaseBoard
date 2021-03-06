//
//  BBDDarkImageKeyButton.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/14/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDDarkImageKeyButton.h"

@implementation BBDDarkImageKeyButton

- (UIColor *)symbolColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor whiteColor];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor blackColor];
        });
        color = _lightColor;
    }
    
    return color;
}

- (UIColor *)backgroundColor
{
    UIColor *color = nil;
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
    UIImage *iconImage = nil;
    if (self.keyCode == BBDKeyCodeNextKeyboard) {
        iconImage = [UIImage imageNamed:@"global_portrait"];
        iconImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[self symbolColor] set];
    } else if (self.keyCode == BBDKeyCodeDelete) {
        iconImage = [UIImage imageNamed:@"delete_portrait"];
        iconImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor whiteColor] set];
    }
    
    CGRect keyFrame = [self keyFrame];
    CGPoint centerPoint = CGPointMake(keyFrame.origin.x + keyFrame.size.width / 2.0f, keyFrame.origin.y + keyFrame.size.height / 2.0f);
    CGPoint imageTopLeft = CGPointMake(centerPoint.x - (iconImage.size.width / 2.0f),
                                       centerPoint.y - (iconImage.size.height / 2.0f));
    [iconImage drawAtPoint:imageTopLeft blendMode:kCGBlendModeNormal alpha:1.0f];
}

@end

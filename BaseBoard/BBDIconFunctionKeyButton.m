//
//  BBDIconFunctionKeyButton.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/14/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDIconFunctionKeyButton.h"

@implementation BBDIconFunctionKeyButton

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

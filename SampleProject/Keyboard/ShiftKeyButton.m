//
//  ShiftKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "ShiftKeyButton.h"

@implementation ShiftKeyButton

- (UIColor *)backgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource shiftKeyState] != ShiftKeyStateLowercase &&
        [self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(208.0f/255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        color = [super backgroundColor];
    }
    
    return color;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //draw the appropriate shift key image
    UIImage * shiftKeyImage = nil;
    if ([self.dataSource shiftKeyState] == ShiftKeyStateLowercase) {
        shiftKeyImage = [UIImage imageNamed:@"shift_portrait"];
        shiftKeyImage = [shiftKeyImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor whiteColor] set];
    } else if ([self.dataSource shiftKeyState] == ShiftKeyStateUppercase) {
        shiftKeyImage = [UIImage imageNamed:@"shift_portrait"];
        shiftKeyImage = [shiftKeyImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UIColor blackColor] set];
    } else if ([self.dataSource shiftKeyState] == ShiftKeyStateCapsLock) {
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

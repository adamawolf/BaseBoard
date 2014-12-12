//
//  ShiftKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "ShiftKeyButton.h"

@implementation ShiftKeyButton

- (instancetype)initWithKeyCode:(KeyCode)keyCode
{
    self = [super initWithKeyCode:keyCode];
    if (self) {
        self.keyBackgroundColor = [UIColor colorWithRed:(168.0f/255.0f) green:(179.0f/255.0f) blue:(186.0f/255.0f) alpha:1.0f];
        self.keyHighlightedBackgroundColor = [UIColor colorWithRed:(128.0f/255.0f) green:(139.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
        self.keyShadowColor = [UIColor colorWithRed:(136.0f/255.0f) green:(138.0f/255.0f) blue:(142.0f/255.0f) alpha:1.0f];
    }
    return self;
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
    } else if ([self.dataSource shiftKeyState] == ShiftKeyStateCapsLock) {
        shiftKeyImage = [UIImage imageNamed:@"shift_lock_portrait"];
    }
    
    CGRect keyFrame = [self keyFrame];
    CGPoint centerPoint = CGPointMake(keyFrame.origin.x + keyFrame.size.width / 2.0f, keyFrame.origin.y + keyFrame.size.height / 2.0f);
    CGPoint imageTopLeft = CGPointMake(centerPoint.x - (shiftKeyImage.size.width / 2.0f),
                                       centerPoint.y - (shiftKeyImage.size.height / 2.0f));
    [shiftKeyImage drawAtPoint:imageTopLeft blendMode:kCGBlendModeNormal alpha:1.0f];
}

@end

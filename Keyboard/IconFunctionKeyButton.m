//
//  IconFunctionKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/14/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "IconFunctionKeyButton.h"

@implementation IconFunctionKeyButton

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
    UIImage * iconImage = nil;
    if (self.keyCode == KeyCodeNextKeyboard) {
        iconImage = [UIImage imageNamed:@"global_portrait"];
    } else if (self.keyCode == KeyCodeDelete) {
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

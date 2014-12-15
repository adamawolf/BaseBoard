//
//  IconFunctionKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/14/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "IconFunctionKeyButton.h"

@implementation IconFunctionKeyButton

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

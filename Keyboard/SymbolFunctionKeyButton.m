//
//  SymbolFunctionKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/14/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "SymbolFunctionKeyButton.h"

@implementation SymbolFunctionKeyButton

- (instancetype)initWithKeyCode:(KeyCode)keyCode
{
    self = [super initWithKeyCode:keyCode];
    if (self) {
        self.shouldAutocapitalize = NO;
    }
    return self;
}

- (UIColor *)backgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(60.0f/255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor colorWithRed:(168.0f/255.0f) green:(179.0f/255.0f) blue:(186.0f/255.0f) alpha:1.0f];
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
            _darkColor = [UIColor colorWithWhite:(40.0f/255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor colorWithRed:(128.0f/255.0f) green:(139.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
        });
        color = _lightColor;
    }
    
    return color;
}

@end

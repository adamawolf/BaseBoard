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
        self.keyBackgroundColor = [UIColor colorWithRed:(168.0f/255.0f) green:(179.0f/255.0f) blue:(186.0f/255.0f) alpha:1.0f];
        self.keyHighlightedBackgroundColor = [UIColor colorWithRed:(128.0f/255.0f) green:(139.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
        self.keyShadowColor = [UIColor colorWithRed:(136.0f/255.0f) green:(138.0f/255.0f) blue:(142.0f/255.0f) alpha:1.0f];
        
        self.shouldAutocapitalize = NO;
    }
    return self;
}

@end

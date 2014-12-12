//
//  KeyView.h
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//
//  Base class for all other KeyButtons on the keyboard.
//  Draws key background and shadow shapes according to paddings.
//  The space key can use this class, all else will need to subclass.

#import <UIKit/UIKit.h>
#import "KeyController.h"

@class KeyButton;

@protocol KeyButtonDelegate <NSObject>

- (void)keyButtonDidGetTapped:(KeyButton *)keyButton;

@end

@interface KeyButton : UIButton

@property (nonatomic, weak) id<KeyButtonDelegate> delegate;
@property (nonatomic, readonly) KeyCode keyCode;
@property (nonatomic, assign) UIEdgeInsets paddings;

@property (nonatomic, strong) UIColor *keyBackgroundColor;
@property (nonatomic, strong) UIColor *keyShadowColor;
@property (nonatomic, strong) UIColor *keyHighlightedBackgroundColor;

- (instancetype)initWithKeyCode:(KeyCode)keyCode;

- (CGRect)keyFrame;

@end

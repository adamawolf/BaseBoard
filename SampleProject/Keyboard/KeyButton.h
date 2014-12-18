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

@protocol KeyButtonDataSource <NSObject>

- (UIKeyboardAppearance)keyboardAppearance;

@end

@interface KeyButton : UIButton

@property (nonatomic, weak) id<KeyButtonDelegate> delegate;
@property (nonatomic, weak) id<KeyButtonDataSource> dataSource;

@property (nonatomic, readonly) KeyCode keyCode;
@property (nonatomic, assign) UIEdgeInsets paddings;

- (UIColor *)symbolColor;
- (UIColor *)backgroundColor;
- (UIColor *)shadowColor;
- (UIColor *)highlightedBackgroundColor;

- (instancetype)initWithKeyCode:(KeyCode)keyCode;

- (CGRect)keyFrame;

@end

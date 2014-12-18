//
//  BBDKeyButton.h
//  BaseBoard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//
//  Base class for all other KeyButtons on the keyboard.
//  Draws key background and shadow shapes according to paddings.
//  The space key can use this class, all else will need to subclass.

#import <UIKit/UIKit.h>
#import "BBDKeyController.h"

@class BBDKeyButton;

@protocol BBDKeyButtonDelegate <NSObject>

- (void)keyButtonDidGetTapped:(BBDKeyButton *)keyButton;

@end

@protocol BBDKeyButtonDataSource <NSObject>

- (UIKeyboardAppearance)keyboardAppearance;

@end

@interface BBDKeyButton : UIButton

@property (nonatomic, weak) id<BBDKeyButtonDelegate> delegate;
@property (nonatomic, weak) id<BBDKeyButtonDataSource> dataSource;

@property (nonatomic, readonly) BBDKeyCode keyCode;
@property (nonatomic, assign) UIEdgeInsets paddings;

- (UIColor *)symbolColor;
- (UIColor *)backgroundColor;
- (UIColor *)shadowColor;
- (UIColor *)highlightedBackgroundColor;

- (instancetype)initWithKeyCode:(BBDKeyCode)keyCode;

- (CGRect)keyFrame;

@end

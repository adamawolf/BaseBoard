//
//  KeyView.h
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyController.h"

@class KeyButton;

@protocol KeyButtonDelegate <NSObject>

- (void)keyButtonDidGetTapped:(KeyButton *)keyButton;

@end

@protocol KeyButtonDataSource <NSObject>

- (ShiftKeyState)shiftKeyState;

@end

@interface KeyButton : UIButton

@property (nonatomic, weak) id<KeyButtonDelegate> delegate;
@property (nonatomic, weak) id<KeyButtonDataSource> dataSource;
@property (nonatomic, readonly) KeyCode keyCode;
@property (nonatomic, assign) UIEdgeInsets paddings;

- (instancetype)initWithKeyCode:(KeyCode)keyCode;

@end

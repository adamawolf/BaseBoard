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

@interface KeyButton : UIButton

@property (nonatomic, weak) id<KeyButtonDelegate> delegate;
@property (nonatomic, readonly) KeyCode keyCode;

- (instancetype)initWithKeyCode:(KeyCode)keyCode;

@end

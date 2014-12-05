//
//  TypingLogicController.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/25/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyController.h"
#import <UIKit/UIInputViewController.h>

typedef NS_ENUM(NSUInteger, TypingLogicState) {
    TypingLogicStateUnknown,
    TypingLogicStateNormal,
    TypingLogicStateTextThenSpaceTyped,
};

@class TypingLogicController;

@protocol TypingLogicControllerDelegate <NSObject>

- (void)typingLogicController:(TypingLogicController *)controller determinedShouldSetShiftKeyState:(ShiftKeyState)shiftKeyState;
- (void)typingLogicController:(TypingLogicController *)controller determinedShouldInsertText:(NSString *)text;
- (void)typingLogicControllerDeterminedShouldDeleteBackwards:(TypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:(TypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldSwitchToNumericAndSymbolsKeyPane:(TypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:(TypingLogicController *)controller;

@end

@interface TypingLogicController : NSObject

@property (nonatomic, weak) id<TypingLogicControllerDelegate> delegate;
@property (nonatomic, readonly) NSObject <UITextDocumentProxy> *textDocumentProxy;

@property (nonatomic, assign) ShiftKeyState shiftKeyState;
@property (nonatomic, readonly) TypingLogicState typingLogicState;

- (instancetype)initWithDelegate:(id<TypingLogicControllerDelegate>)delegate
            andTextDocumentProxy:(NSObject <UITextDocumentProxy> *)textDocumentProxy;

- (void)determineShiftKeyState;

- (void)processKeystrokeWithKeyCode:(KeyCode)keyCode;

@end

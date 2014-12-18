//
//  TypingLogicController.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/25/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBDKeyController.h"
#import <UIKit/UIInputViewController.h>

@class BBDTypingLogicController;

@protocol BBDTypingLogicControllerDelegate <NSObject>

- (void)typingLogicController:(BBDTypingLogicController *)controller determinedShouldSetShiftKeyState:(BBDShiftKeyState)shiftKeyState;
- (void)typingLogicController:(BBDTypingLogicController *)controller determinedShouldInsertText:(NSString *)text;
- (void)typingLogicControllerDeterminedShouldDeleteBackwards:(BBDTypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:(BBDTypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldSwitchToNumericAndSymbolsKeyPane:(BBDTypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:(BBDTypingLogicController *)controller;
- (void)typingLogicControllerDeterminedShouldSwitchToSupplemtalSymbolsKeyPane:(BBDTypingLogicController *)controller;

@end

@interface BBDTypingLogicController : NSObject

@property (nonatomic, weak) id<BBDTypingLogicControllerDelegate> delegate;
@property (nonatomic, readonly) NSObject <UITextDocumentProxy> *textDocumentProxy;

@property (nonatomic, assign) BBDShiftKeyState shiftKeyState;

- (instancetype)initWithDelegate:(id<BBDTypingLogicControllerDelegate>)delegate
            andTextDocumentProxy:(NSObject <UITextDocumentProxy> *)textDocumentProxy;

- (void)determineShiftKeyState;

- (void)processKeystrokeWithKeyCode:(BBDKeyCode)keyCode;

@end

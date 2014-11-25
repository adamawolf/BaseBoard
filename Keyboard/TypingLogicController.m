//
//  TypingLogicController.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/25/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "TypingLogicController.h"

@implementation TypingLogicController

- (instancetype)initWithDelegate:(id<TypingLogicControllerDelegate>)delegate
            andTextDocumentProxy:(NSObject <UITextDocumentProxy> *)textDocumentProxy
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _textDocumentProxy = textDocumentProxy;
        
        _shiftKeyState = ShiftKeyStateUnknown;
        _typingLogicState = TypingLogicStateUnknown;
    }
    
    return self;
}

#pragma mark - Custom Setter methods

- (void)setShiftKeyState:(ShiftKeyState)shiftKeyState
{
    ShiftKeyState initialShiftKeyState = _shiftKeyState;
    
    _shiftKeyState = shiftKeyState;
    
    if (_shiftKeyState != initialShiftKeyState) {
        [self.delegate typingLogicController:self determinedShouldSetShiftKeyState:_shiftKeyState];
    }
}

#pragma mark - Public Interface methods

- (void)determineShiftKeyState
{
    ShiftKeyState determinedState = ShiftKeyStateLowercase;
    
    if (self.textDocumentProxy.autocapitalizationType == UITextAutocapitalizationTypeSentences) {
        if (self.textDocumentProxy.hasText) {
            NSString *beforeText = self.textDocumentProxy.documentContextBeforeInput;
            NSString *afterText = self.textDocumentProxy.documentContextAfterInput;
            
            if (afterText.length == 0) {
                if (beforeText.length >= 2) {
                    NSString *lastCharacter = [beforeText substringFromIndex:beforeText.length -1];
                    NSString *secondToLastCharacter = [beforeText substringWithRange:(NSRange){beforeText.length - 2, 1}];
                    
                    if ([lastCharacter isEqualToString:@"\n"])
                    {
                        //typed text ends in a carriage return
                        determinedState = ShiftKeyStateUppercase;
                    } else if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
                        if ([secondToLastCharacter rangeOfCharacterFromSet:[TypingLogicController sentenceEndingCharacterSet]].location != NSNotFound) {
                            //typed text ends in a space preceded by a sentence ending chracter
                            determinedState = ShiftKeyStateUppercase;
                        } else if (beforeText.length >= 3) {
                            NSString *thirdToLastCharacter = [beforeText substringWithRange:(NSRange){beforeText.length - 3, 1}];
                            
                            if ([secondToLastCharacter rangeOfCharacterFromSet:[TypingLogicController potentiallySentenceEndingCharacterSet]].location != NSNotFound &&
                                [thirdToLastCharacter rangeOfCharacterFromSet:[TypingLogicController sentenceEndingCharacterSet]].location != NSNotFound ) {
                                
                            }
                            determinedState = ShiftKeyStateUppercase;
                        }
                    }
                }
            }
        }
        else {
            determinedState = ShiftKeyStateUppercase;
        } 
    } //TODO: handle autocapitialization UITextAutocapitalizationTypeAllCharacters and UITextAutocapitalizationTypeWords
}

- (void)processKeystrokeWithKeyCode:(KeyCode)keyCode
{
    if ([[KeyController textGeneratingKeyCodeIndexSet] containsIndex:keyCode]) {
        NSString *lowercaseYieldedText = [KeyController yieldedLowercaseTextForKeyCode:keyCode];
        [self.delegate typingLogicController:self determinedShouldInsertText:lowercaseYieldedText];
        //TODO: double tap space shortcut
    } else if (keyCode == KeyCodeDelete) {
        [self.delegate typingLogicControllerDeterminedShouldDeleteBackwards:self];
    } else if (keyCode == KeyCodeNextKeyboard) {
        [self.delegate typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:self];
    } //TODO shift & number pane
}

#pragma mark - Static Reference methods

+ (NSCharacterSet *)sentenceEndingCharacterSet
{
    static NSCharacterSet *_sentenceEndingCharacterSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sentenceEndingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".!?"];
    });
    
    return _sentenceEndingCharacterSet;
}

//characters that COULD be sentence ending, if they are preceded by a sentence ending character set
//i.e. the single and double quotes in the two character strings: ." and .'
+ (NSCharacterSet *)potentiallySentenceEndingCharacterSet
{
    static NSCharacterSet *_potentiallySentenceEndingCharacterSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _potentiallySentenceEndingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\"\'"];
    });
    
    return _potentiallySentenceEndingCharacterSet;
}

@end
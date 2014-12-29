//
//  BBDKeyboardViewController.m
//  BaseBoard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDKeyboardViewController.h"
#import "BBDKeyController.h"
#import "BBDKeyPositionController.h"
#import "BBDTypingLogicController.h"
#import "BBDKeyButton.h"
#import "BBDStringKeyButton.h"
#import "BBDShiftKeyButton.h"

typedef NS_ENUM(NSUInteger, KeyPane) {
    KeyPaneUnknown,
    KeyPanePrimary,
    KeyPaneNumericAndSymbols,
    KeyPaneSupplementalSymbols,
};

@interface BBDKeyboardViewController () <BBDKeyPositionDataSource, BBDKeyButtonDelegate, BBDStringKeyButtonDataSource, BBDShiftKeyButtonDataSource, BBDTypingLogicControllerDelegate>

@property (nonatomic, assign) KeyPane currentKeyPane;

@property (nonatomic, strong) BBDKeyPositionController *keyPositionController;
@property (nonatomic, strong) BBDTypingLogicController *typingLogicController;

@property (nonatomic, strong) NSMutableSet *primaryKeyPaneKeyButtons;
@property (nonatomic, strong) NSMutableSet *numericAndSymbolsKeyPaneKeyButtons;
@property (nonatomic, strong) NSMutableSet *supplementalSymbolsKeyPaneKeyButtons;

@end

@implementation BBDKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //specified for localization purposes throughout the rest of the OS
    //see http://www.w3.org/International/articles/language-tags/
    self.primaryLanguage = @"en-US";
    
    self.currentKeyPane = KeyPanePrimary;
    
    //generates CGRect frames for each key in current keypane
    self.keyPositionController = [[BBDKeyPositionController alloc] init];
    self.keyPositionController.dataSource = self;
    
    //handles key presses/gesures and associated shortcuts
    self.typingLogicController = [[BBDTypingLogicController alloc] initWithDelegate:self andTextDocumentProxy:self.textDocumentProxy];
    
    //add keys views to keyboard's inputView
    self.primaryKeyPaneKeyButtons = [NSMutableSet new];
    self.numericAndSymbolsKeyPaneKeyButtons = [NSMutableSet new];
    self.supplementalSymbolsKeyPaneKeyButtons = [NSMutableSet new];
    
    NSArray *keyViewCreationContexts = @[
                                         @{
                                             @"keyPaneRows": [BBDKeyboardViewController primaryKeyPaneRows],
                                             @"targetButtonsMutableSet": self.primaryKeyPaneKeyButtons,
                                             },
                                         @{
                                             @"keyPaneRows": [BBDKeyboardViewController numericAndSymbolsKeyPaneRows],
                                             @"targetButtonsMutableSet": self.numericAndSymbolsKeyPaneKeyButtons,
                                             },
                                         @{
                                             @"keyPaneRows": [BBDKeyboardViewController supplementalSymbolsKeyPaneRows],
                                             @"targetButtonsMutableSet": self.supplementalSymbolsKeyPaneKeyButtons,
                                             },
                                         ];
    
    [keyViewCreationContexts enumerateObjectsUsingBlock:^(NSDictionary *creationContext, NSUInteger idx, BOOL *stop) {
        NSMutableSet *keyPaneSet = creationContext[@"targetButtonsMutableSet"];
        [creationContext[@"keyPaneRows"] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
            [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger keyIndex, BOOL *stop) {
                
                BBDKeyCode currentKeyCode = [keyCodeNumber intValue];
                
                Class keyButtonClass = [BBDKeyController keyButtonClassForKeyCode:currentKeyCode];
                
                BBDKeyButton *aKeyView = [[keyButtonClass alloc] initWithKeyCode:[keyCodeNumber intValue]];
                aKeyView.delegate = self;
                aKeyView.dataSource = self;
                [self.inputView addSubview:aKeyView];
                [keyPaneSet addObject:aKeyView];
            }];
        }];
    }];
}

- (void)viewDidLayoutSubviews
{
    [self.keyPositionController reloadKeyPositions];
    
    //layout the keys
    [self.inputView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (subview.alpha > 0.0f) {
            if ([subview isKindOfClass:[BBDKeyButton class]]) {
                BBDKeyButton *keyButton = (BBDKeyButton *)subview;
                
                NSDictionary *keyDictionary = [self.keyPositionController keyDictionaryForKeyCode:keyButton.keyCode];
                if (keyDictionary) {
                    keyButton.frame = [keyDictionary[@"frame"] CGRectValue];
                    
                    if (keyDictionary[@"paddings"]) {
                        keyButton.paddings = [keyDictionary[@"paddings"] UIEdgeInsetsValue];
                    } else {
                        keyButton.paddings = UIEdgeInsetsZero;
                    }
                    
                    [keyButton setNeedsDisplay];
                }
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)textWillChange:(id<UITextInput>)textInput
{

}

- (void)textDidChange:(id<UITextInput>)textInput
{
    //for when a previously instantiated keyboard switches to handling input for a new UITextView
    [self.typingLogicController determineShiftKeyState];
}

#pragma mark - Custom setter methods

- (void)setCurrentKeyPane:(KeyPane)currentKeyPane
{
    BOOL changed = _currentKeyPane != KeyPaneUnknown && _currentKeyPane != currentKeyPane;
    
    _currentKeyPane = currentKeyPane;
    
    if (changed) {
        //show and hide appropriate sets of keys
        NSMutableSet *keySetsToShow = [NSMutableSet new];
        NSMutableSet *keySetsToHide = [NSMutableSet new];
        
        if (_currentKeyPane == KeyPanePrimary) {
            [keySetsToShow addObject:self.primaryKeyPaneKeyButtons];
            [keySetsToHide addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keySetsToHide addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        } else if (_currentKeyPane == KeyPaneNumericAndSymbols) {
            [keySetsToHide addObject:self.primaryKeyPaneKeyButtons];
            [keySetsToShow addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keySetsToHide addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        } else if (_currentKeyPane == KeyPaneSupplementalSymbols) {
            [keySetsToHide addObject:self.primaryKeyPaneKeyButtons];
            [keySetsToHide addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keySetsToShow addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        }
        
        [keySetsToShow enumerateObjectsUsingBlock:^(NSArray *keyArray, BOOL *stop) {
            [keyArray enumerateObjectsUsingBlock:^(UIView *keyView, NSUInteger idx, BOOL *stop) {
                keyView.alpha = 1.0f;
            }];
        }];
        
        [keySetsToHide enumerateObjectsUsingBlock:^(NSArray *keyArray, BOOL *stop) {
            [keyArray enumerateObjectsUsingBlock:^(UIView *keyView, NSUInteger idx, BOOL *stop) {
                keyView.alpha = 0.0f;
            }];
        }];
        
        //recalculate key positions
        [self.keyPositionController reloadKeyPositions];
        //trigger re-layout of keys
        [self.inputView setNeedsLayout];
    }
}

#pragma mark - BBDKeyPositionDataSource methods

- (CGSize)keyboardSize
{
    return self.inputView.frame.size;
}

- (NSInteger)numberOfRows
{
    return [BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane].count;
}

- (NSInteger)numberOfKeysForRow:(NSInteger)row
{
    return [[BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane][row] count];
}

- (BBDKeyCode)keyCodeForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition];
    
    return [keyCodeNumber intValue];
}

- (NSNumber *)relativeWidthForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *relativeWidth = nil; //nil => default width, meaning: share all remaining width with rest of default width keys in same row
    
    BBDKeyCode keyCode = [[BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        if (keyCode == BBDKeyCodeSpace) {
            relativeWidth = @(0.5f);
        } else if (keyCode == BBDKeyCodeReturn) {
            relativeWidth = @(0.225f);
        } else if (keyCode == BBDKeyCodeA) {
            relativeWidth = @(0.15f);
        } else if (keyCode == BBDKeyCodeL) {
            relativeWidth = @(0.15f);
        } else if (keyCode == BBDKeyCodeShift) {
            relativeWidth = @(0.15f);
        } else if (keyCode == BBDKeyCodeDelete) {
            relativeWidth = @(0.15f);
        }
    } else {
        if (keyCode == BBDKeyCodeReturn) {
            relativeWidth = @(0.15f);
        } else if (keyCode == BBDKeyCodeA) {
            relativeWidth = @(0.14f);
        } else if (keyCode == BBDKeyCodeSpace) {
            relativeWidth = @(0.6f);
        }
    }
    
    return relativeWidth;
}

- (NSValue *)marginsForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *marginsValue = nil;
    
    BBDKeyCode keyCode = [[BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    
    //vertical margins take largest of any key per row, so just specify a margin for first key in first row of each pane
    if (keyCode == BBDKeyCodeQ || keyCode == BBDKeyCode1 || keyCode == BBDKeyCodeOpenSquareBracket) {
        marginsValue = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(4.0f, 0.0f, 0.0f, 0.0f)];
    }
    
    return marginsValue;
}

- (NSValue *)paddingsForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets paddings = [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad ? UIEdgeInsetsMake(4.0f, 3.0f, 4.0f, 3.0f) : UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    
    BBDKeyCode keyCode = [[BBDKeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        CGFloat topRowButtonWidth = self.inputView.bounds.size.width / 10;
        if (keyCode == BBDKeyCodeA) {
            CGFloat oneHalfTopRowButtonWidth = floorf(topRowButtonWidth / 2);
            paddings.left += oneHalfTopRowButtonWidth;
        } else if (keyCode == BBDKeyCodeL) {
            CGFloat oneHalfTopRowButtonWidth = floorf(topRowButtonWidth / 2);
            paddings.right += oneHalfTopRowButtonWidth;
        } else if (keyCode == BBDKeyCodeShift || keyCode == BBDKeyCodeSymbolsPane || keyCode == BBDKeyCodeThirdRowNumberPane) {
            CGFloat oneQuarterTopRowButtonWidth = floorf(topRowButtonWidth / 4);
            paddings.right += oneQuarterTopRowButtonWidth;
        } else if (keyCode == BBDKeyCodeDelete) {
            CGFloat oneQuarterTopRowButtonWidth = floorf(topRowButtonWidth / 4);
            paddings.left += oneQuarterTopRowButtonWidth;
        }
    } else {
        if (keyCode == BBDKeyCodeA) {
            CGFloat oneHalfMiddleRowButtonWidth = floorf(self.inputView.bounds.size.width / 20.0f);
            paddings.left += oneHalfMiddleRowButtonWidth;
        }
    }
    
    return [NSValue valueWithUIEdgeInsets:paddings];
}

#pragma mark - BBDKeyButtonDelegate methods

- (void)keyButtonDidGetTapped:(BBDKeyButton *)keyButton
{
    NSLog(@"key press: %i", (int)keyButton.keyCode);
    
    [self.typingLogicController processKeystrokeWithKeyCode:keyButton.keyCode];
}

#pragma mark - BBDKeyButtonDataSource

- (UIKeyboardAppearance)keyboardAppearance
{
    return self.textDocumentProxy.keyboardAppearance;
}

#pragma mark - BBDStringKeyButtonDataSource methods

- (UIReturnKeyType)returnKeyType
{
    return self.textDocumentProxy.returnKeyType;
}

#pragma mark - BBDShiftKeyButtonDataSource methods

- (BBDShiftKeyState)shiftKeyState
{
    return self.typingLogicController.shiftKeyState;
}

#pragma mark - TypingLogicControllerDelegate methods

- (void)typingLogicController:(BBDTypingLogicController *)controller determinedShouldSetShiftKeyState:(BBDShiftKeyState)shiftKeyState
{
    //update all key appearances so as it switch between lowercase and uppercase symbol
    [self.inputView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[BBDKeyButton class]]) {
            BBDKeyButton *keyButton = (BBDKeyButton *)subview;
            [keyButton setNeedsDisplay];
        }
    }];
}

- (void)typingLogicController:(BBDTypingLogicController *)controller determinedShouldInsertText:(NSString *)text
{
    NSLog(@"inserted text: '%@'", text);
    
    [self.textDocumentProxy insertText:text];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)typingLogicControllerDeterminedShouldDeleteBackwards:(BBDTypingLogicController *)controller
{
    NSLog(@"deleted a character");
    
    [self.textDocumentProxy deleteBackward];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:(BBDTypingLogicController *)controller
{
    [self advanceToNextInputMode];
}

- (void)typingLogicControllerDeterminedShouldSwitchToNumericAndSymbolsKeyPane:(BBDTypingLogicController *)controller
{
    self.currentKeyPane = KeyPaneNumericAndSymbols;
}

- (void)typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:(BBDTypingLogicController *)controller
{
    self.currentKeyPane = KeyPanePrimary;
}

- (void)typingLogicControllerDeterminedShouldSwitchToSupplemtalSymbolsKeyPane:(BBDTypingLogicController *)controller
{
    self.currentKeyPane = KeyPaneSupplementalSymbols;
}

#pragma mark - Static Key Pane Configuration methods

+ (NSArray *)rowsForKeyPane:(KeyPane)keyPane
{
    if (keyPane == KeyPanePrimary) {
        return [BBDKeyboardViewController primaryKeyPaneRows];
    } else if (keyPane == KeyPaneNumericAndSymbols) {
        return [BBDKeyboardViewController numericAndSymbolsKeyPaneRows];
    } else if (keyPane == KeyPaneSupplementalSymbols) {
        return [BBDKeyboardViewController supplementalSymbolsKeyPaneRows];
    }
    
    return nil;
}

+ (NSArray *)primaryKeyPaneRows
{
    static NSArray *_primaryKeyPaneRows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
            _primaryKeyPaneRows = @[
                                    @[@(BBDKeyCodeQ), @(BBDKeyCodeW), @(BBDKeyCodeE), @(BBDKeyCodeR), @(BBDKeyCodeT), @(BBDKeyCodeY), @(BBDKeyCodeU), @(BBDKeyCodeI), @(BBDKeyCodeO), @(BBDKeyCodeP)],
                                    @[@(BBDKeyCodeA), @(BBDKeyCodeS), @(BBDKeyCodeD), @(BBDKeyCodeF), @(BBDKeyCodeG), @(BBDKeyCodeH), @(BBDKeyCodeJ), @(BBDKeyCodeK), @(BBDKeyCodeL)],
                                    @[@(BBDKeyCodeShift), @(BBDKeyCodeZ), @(BBDKeyCodeX), @(BBDKeyCodeC), @(BBDKeyCodeV), @(BBDKeyCodeB), @(BBDKeyCodeN), @(BBDKeyCodeM), @(BBDKeyCodeDelete)],
                                    @[@(BBDKeyCodeNumberPane), @(BBDKeyCodeNextKeyboard), @(BBDKeyCodeSpace), @(BBDKeyCodeReturn)],
                                    ];
        } else {
            _primaryKeyPaneRows = @[
                                    @[@(BBDKeyCodeQ), @(BBDKeyCodeW), @(BBDKeyCodeE), @(BBDKeyCodeR), @(BBDKeyCodeT), @(BBDKeyCodeY), @(BBDKeyCodeU), @(BBDKeyCodeI), @(BBDKeyCodeO), @(BBDKeyCodeP), @(BBDKeyCodeDelete)],
                                    @[@(BBDKeyCodeA), @(BBDKeyCodeS), @(BBDKeyCodeD), @(BBDKeyCodeF), @(BBDKeyCodeG), @(BBDKeyCodeH), @(BBDKeyCodeJ), @(BBDKeyCodeK), @(BBDKeyCodeL), @(BBDKeyCodeReturn)],
                                    @[@(BBDKeyCodeShift), @(BBDKeyCodeZ), @(BBDKeyCodeX), @(BBDKeyCodeC), @(BBDKeyCodeV), @(BBDKeyCodeB), @(BBDKeyCodeN), @(BBDKeyCodeM), @(BBDKeyCodeComma), @(BBDKeyCodePeriod), @(BBDKeyCodeSecondShift)],
                                    @[@(BBDKeyCodeNumberPane), @(BBDKeyCodeNextKeyboard), @(BBDKeyCodeSpace), @(BBDKeyCodeSecondNumberPane),],
                                    ];
        }
    });
    
    return _primaryKeyPaneRows;
}

+ (NSArray *)numericAndSymbolsKeyPaneRows
{
    static NSArray *_numericAndSymbolsKeyPaneRows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numericAndSymbolsKeyPaneRows = @[
                                          @[@(BBDKeyCode1), @(BBDKeyCode2), @(BBDKeyCode3), @(BBDKeyCode4), @(BBDKeyCode5), @(BBDKeyCode6), @(BBDKeyCode7), @(BBDKeyCode8), @(BBDKeyCode9), @(BBDKeyCode0)],
                                          @[@(BBDKeyCodeDash), @(BBDKeyCodeForwardSlash), @(BBDKeyCodeColon), @(BBDKeyCodeSemicolon), @(BBDKeyCodeOpenParenthesis), @(BBDKeyCodeCloseParenthesis), @(BBDKeyCodeDollar), @(BBDKeyCodeAmersand), @(BBDKeyCodeAt), @(BBDKeyCodeDoubleQuote),],
                                          @[@(BBDKeyCodeSymbolsPane), @(BBDKeyCodePeriod), @(BBDKeyCodeComma), @(BBDKeyCodeQuestionMark), @(BBDKeyCodeExclamationMark), @(BBDKeyCodeSingleQuote), @(BBDKeyCodeDelete),],
                                          @[@(BBDKeyCodePrimaryKeyPane), @(BBDKeyCodeNextKeyboard), @(BBDKeyCodeSpace), @(BBDKeyCodeReturn),],
                                          ];
    });
    
    return _numericAndSymbolsKeyPaneRows;
}

+ (NSArray *)supplementalSymbolsKeyPaneRows
{
    static NSArray *_numericAndSymbolsKeyPaneRows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numericAndSymbolsKeyPaneRows = @[
                                          @[@(BBDKeyCodeOpenSquareBracket), @(BBDKeyCodeCloseSquareBracket), @(BBDKeyCodeOpenCurlyBracket), @(BBDKeyCodeCloseCurlyBracket), @(BBDKeyCodePoundSign), @(BBDKeyCodePercent), @(BBDKeyCodeCaret), @(BBDKeyCodeAsterisk), @(BBDKeyCodePlus), @(BBDKeyCodeEqual)],
                                          @[@(BBDKeyCodeUnderscore), @(BBDKeyCodeBackSlash), @(BBDKeyCodeVerticalBar), @(BBDKeyCodeTilde), @(BBDKeyCodeLessThan), @(BBDKeyCodeGreaterThan), @(BBDKeyCodeEuro), @(BBDKeyCodePound), @(BBDKeyCodeYen), @(BBDKeyCodeBullet),],
                                          @[@(BBDKeyCodeThirdRowNumberPane), @(BBDKeyCodePeriod), @(BBDKeyCodeComma), @(BBDKeyCodeQuestionMark), @(BBDKeyCodeExclamationMark), @(BBDKeyCodeSingleQuote), @(BBDKeyCodeDelete),],
                                          @[@(BBDKeyCodePrimaryKeyPane), @(BBDKeyCodeNextKeyboard), @(BBDKeyCodeSpace), @(BBDKeyCodeReturn),],
                                          ];
    });
    
    return _numericAndSymbolsKeyPaneRows;
}

@end

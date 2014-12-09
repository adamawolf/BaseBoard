//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyButton.h"
#import "KeyController.h"
#import "KeyPositionController.h"
#import "TypingLogicController.h"

typedef NS_ENUM(NSUInteger, KeyPane) {
    KeyPaneUnknown,
    KeyPanePrimary,
    KeyPaneNumericAndSymbols,
    KeyPaneSupplementalSymbols,
};

@interface KeyboardViewController () <KeyPositionDataSource, KeyButtonDelegate, KeyButtonDataSource, TypingLogicControllerDelegate>

@property (nonatomic, assign) KeyPane currentKeyPane;

@property (nonatomic, strong) KeyPositionController *keyPositionController;
@property (nonatomic, strong) TypingLogicController *typingLogicController;

@property (nonatomic, strong) NSArray *primaryKeyPaneKeyButtons;
@property (nonatomic, strong) NSArray *numericAndSymbolsKeyPaneKeyButtons;
@property (nonatomic, strong) NSArray *supplementalSymbolsKeyPaneKeyButtons;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentKeyPane = KeyPanePrimary;
    
    self.keyPositionController = [[KeyPositionController alloc] init];
    self.keyPositionController.dataSource = self;
    
    self.typingLogicController = [[TypingLogicController alloc] initWithDelegate:self andTextDocumentProxy:self.textDocumentProxy];
    
    //add keys
    //REFACTOR TODO: DRY fix this code
    NSMutableArray *primaryKeyPaneKeys = [NSMutableArray new];
    [[KeyboardViewController primaryKeyPaneRows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger keyIndex, BOOL *stop) {
            
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
            [primaryKeyPaneKeys addObject:aKeyView];
        }];
    }];;
    self.primaryKeyPaneKeyButtons = primaryKeyPaneKeys;
    
    NSMutableArray *numericAndSymbolsKeyPaneKeys = [NSMutableArray new];
    [[KeyboardViewController numericAndSymbolsKeyPaneRows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger keyIndex, BOOL *stop) {
            
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
            [numericAndSymbolsKeyPaneKeys addObject:aKeyView];
        }];
    }];;
    self.numericAndSymbolsKeyPaneKeyButtons = numericAndSymbolsKeyPaneKeys;
    
    NSMutableArray *supplementalSymbolsKeyPaneKeys = [NSMutableArray new];
    [[KeyboardViewController supplementalSymbolsKeyPaneRows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger keyIndex, BOOL *stop) {
            
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
            [supplementalSymbolsKeyPaneKeys addObject:aKeyView];
        }];
    }];;
    self.supplementalSymbolsKeyPaneKeyButtons = supplementalSymbolsKeyPaneKeys;
}

- (void)viewDidLayoutSubviews
{
    [self.keyPositionController reloadKeyPositions];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[KeyButton class]]) {
            KeyButton *keyButton = (KeyButton *)subview;
            
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
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)textWillChange:(id<UITextInput>)textInput
{
    // The app is about to change the document's contents. Perform any preparation here.
    NSLog(@"textWillChange");
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    NSLog(@"textDidChange");
    
    [self.typingLogicController determineShiftKeyState];
}

#pragma mark - Custom setter methods

- (void)setCurrentKeyPane:(KeyPane)currentKeyPane
{
    BOOL changed = _currentKeyPane != currentKeyPane;
    
    _currentKeyPane = currentKeyPane;
    
    if (changed) {
        //show and hide appropriate sets of keys
        NSMutableSet *keysToShow = [NSMutableSet new];
        NSMutableSet *keysToHide = [NSMutableSet new];
        
        if (_currentKeyPane == KeyPanePrimary) {
            [keysToShow addObject:self.primaryKeyPaneKeyButtons];
            [keysToHide addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keysToHide addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        } else if (_currentKeyPane == KeyPaneNumericAndSymbols) {
            [keysToHide addObject:self.primaryKeyPaneKeyButtons];
            [keysToShow addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keysToHide addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        } else if (_currentKeyPane == KeyPaneSupplementalSymbols) {
            [keysToHide addObject:self.primaryKeyPaneKeyButtons];
            [keysToHide addObject:self.numericAndSymbolsKeyPaneKeyButtons];
            [keysToShow addObject:self.supplementalSymbolsKeyPaneKeyButtons];
        }
        
        [keysToShow enumerateObjectsUsingBlock:^(NSArray *keyArray, BOOL *stop) {
            [keyArray enumerateObjectsUsingBlock:^(UIView *keyView, NSUInteger idx, BOOL *stop) {
                keyView.alpha = 1.0f;
            }];
        }];
        
        [keysToHide enumerateObjectsUsingBlock:^(NSArray *keyArray, BOOL *stop) {
            [keyArray enumerateObjectsUsingBlock:^(UIView *keyView, NSUInteger idx, BOOL *stop) {
                keyView.alpha = 0.0f;
            }];
        }];
        
        //trigger re-layout of keys
        [self.keyPositionController reloadKeyPositions];
        [self.view setNeedsLayout]; //TODO: confirm this triggers viewDidLayoutSubviews
    }
}

#pragma mark - Static data methods

+ (NSArray *)rowsForKeyPane:(KeyPane)keyPane
{
    if (keyPane == KeyPanePrimary) {
        return [KeyboardViewController primaryKeyPaneRows];
    } else if (keyPane == KeyPaneNumericAndSymbols) {
        return [KeyboardViewController numericAndSymbolsKeyPaneRows];
    } else if (keyPane == KeyPaneSupplementalSymbols) {
        return [KeyboardViewController supplementalSymbolsKeyPaneRows];
    }
    
    return nil;
}

+ (NSArray *)primaryKeyPaneRows
{
    static NSArray *_primaryKeyPaneRows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _primaryKeyPaneRows = @[
                                @[@(KeyCodeQ), @(KeyCodeW), @(KeyCodeE), @(KeyCodeR), @(KeyCodeT), @(KeyCodeY), @(KeyCodeU), @(KeyCodeI), @(KeyCodeO), @(KeyCodeP)],
                                @[@(KeyCodeA), @(KeyCodeS), @(KeyCodeD), @(KeyCodeF), @(KeyCodeG), @(KeyCodeH), @(KeyCodeJ), @(KeyCodeK), @(KeyCodeL)],
                                @[@(KeyCodeShift), @(KeyCodeZ), @(KeyCodeX), @(KeyCodeC), @(KeyCodeV), @(KeyCodeB), @(KeyCodeN), @(KeyCodeM), @(KeyCodeDelete)],
                                @[@(KeyCodeNumberPane), @(KeyCodeNextKeyboard), @(KeyCodeSpace), @(KeyCodeReturn)],
                                ];
    });
    
    return _primaryKeyPaneRows;
}

+ (NSArray *)numericAndSymbolsKeyPaneRows
{
    static NSArray *_numericAndSymbolsKeyPaneRows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numericAndSymbolsKeyPaneRows = @[
                                @[@(KeyCode1), @(KeyCode2), @(KeyCode3), @(KeyCode4), @(KeyCode5), @(KeyCode6), @(KeyCode7), @(KeyCode8), @(KeyCode9), @(KeyCode0)],
                                @[@(KeyCodeDash), @(KeyCodeForwardSlash), @(KeyCodeColon), @(KeyCodeSemicolon), @(KeyCodeOpenParenthesis), @(KeyCodeCloseParenthesis), @(KeyCodeDollar), @(KeyCodeAmersand), @(KeyCodeAt), @(KeyCodeDoubleQuote),],
                                @[@(KeyCodeSymbolsPane), @(KeyCodePeriod), @(KeyCodeComma), @(KeyCodeQuestionMark), @(KeyCodeExclamationMark), @(KeyCodeSingleQuote), @(KeyCodeDelete),],
                                @[@(KeyCodePrimaryKeyPane), @(KeyCodeNextKeyboard), @(KeyCodeSpace), @(KeyCodeReturn),],
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
                                          @[@(KeyCodeOpenSquareBracket), @(KeyCodeCloseSquareBracket), @(KeyCodeOpenCurlyBracket), @(KeyCodeCloseCurlyBracket), @(KeyCodePoundSign), @(KeyCodePercent), @(KeyCodeCaret), @(KeyCodeAsterisk), @(KeyCodePlus), @(KeyCodeEqual)],
                                          @[@(KeyCodeUnderscore), @(KeyCodeBackSlash), @(KeyCodeVerticalBar), @(KeyCodeTilde), @(KeyCodeLessThan), @(KeyCodeGreaterThan), @(KeyCodeEuro), @(KeyCodePound), @(KeyCodeYen), @(KeyCodeBullet),],
                                          @[@(KeyCodeNumberPane), @(KeyCodePeriod), @(KeyCodeComma), @(KeyCodeQuestionMark), @(KeyCodeExclamationMark), @(KeyCodeSingleQuote), @(KeyCodeDelete),],
                                          @[@(KeyCodePrimaryKeyPane), @(KeyCodeNextKeyboard), @(KeyCodeSpace), @(KeyCodeReturn),],
                                          ];
    });
    
    return _numericAndSymbolsKeyPaneRows;
}

#pragma mark - KeyPositionDataSource methods

- (CGSize)keyboardSize
{
    return self.view.frame.size;
}

- (NSInteger)numberOfRows
{
    return [KeyboardViewController rowsForKeyPane:self.currentKeyPane].count;
}

- (NSInteger)numberOfKeysForRow:(NSInteger)row
{
    return [[KeyboardViewController rowsForKeyPane:self.currentKeyPane][row] count];
}

- (KeyCode)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition];
    
    return [keyCodeNumber intValue];
}

- (NSNumber *)relativeWidthForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *relativeWidth = nil;
    
    KeyCode keyCode = [[KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    if (keyCode == KeyCodeSpace) {
        relativeWidth = @(0.55f);
    } else if (keyCode == KeyCodeA) {
        relativeWidth = @(0.15f);
    } else if (keyCode == KeyCodeL) {
        relativeWidth = @(0.15f);
    } else if (keyCode == KeyCodeShift) {
        relativeWidth = @(0.15f);
    } else if (keyCode == KeyCodeDelete) {
        relativeWidth = @(0.15f);
    }
    
    return relativeWidth;
}

- (NSValue *)marginsForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *marginsValue = nil;
    
    KeyCode keyCode = [[KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    
    //first key in first row of each pane
    if (keyCode == KeyCodeQ || keyCode == KeyCode1 || keyCode == KeyCodeOpenSquareBracket) {
        //give the row a top margin
        marginsValue = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(4.0f, 0.0f, 0.0f, 0.0f)];
    }
    
    return marginsValue;
}

- (NSValue *)paddingsForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets paddings = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    
    KeyCode keyCode = [[KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition] integerValue];
    
    if (keyCode == KeyCodeA) {
        CGFloat oneHalfTopRowButtonWidth = floorf(self.view.bounds.size.width / 20.0f);
        paddings = UIEdgeInsetsMake(2.0f, 2.0f + oneHalfTopRowButtonWidth, 2.0f, 2.0f);
    } else if (keyCode == KeyCodeL)
    {
        CGFloat oneHalfTopRowButtonWidth = floorf(self.view.bounds.size.width / 20.0f);
        paddings = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f + oneHalfTopRowButtonWidth);
    }
    else if (keyCode == KeyCodeShift) {
        CGFloat oneQuarterTopRowButtonWidth = floorf(self.view.bounds.size.width / 40.0f);
        paddings = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f + oneQuarterTopRowButtonWidth);
    } else if (keyCode == KeyCodeDelete) {
        CGFloat oneQuarterTopRowButtonWidth = floorf(self.view.bounds.size.width / 40.0f);
        paddings = UIEdgeInsetsMake(2.0f, 2.0f + oneQuarterTopRowButtonWidth, 2.0f, 2.0f);
    }
    
    return [NSValue valueWithUIEdgeInsets:paddings];
}

#pragma mark - KeyButtonDelegate methods

- (void)keyButtonDidGetTapped:(KeyButton *)keyButton
{
    NSLog(@"key press: %i", (int)keyButton.keyCode);
    
    [self.typingLogicController processKeystrokeWithKeyCode:keyButton.keyCode];
}

#pragma mark - KeyButtonDataSource methods

- (ShiftKeyState)shiftKeyState
{
    return self.typingLogicController.shiftKeyState;
}

#pragma mark - TypingLogicControllerDelegate methods

- (void)typingLogicController:(TypingLogicController *)controller determinedShouldSetShiftKeyState:(ShiftKeyState)shiftKeyState
{
    //update all key appearances
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[KeyButton class]]) {
            KeyButton *keyButton = (KeyButton *)subview;
            [keyButton setNeedsDisplay];
        }
    }];
}

- (void)typingLogicController:(TypingLogicController *)controller determinedShouldInsertText:(NSString *)text
{
    NSLog(@"inserted text: %@", text);
    
    [self.textDocumentProxy insertText:text];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)typingLogicControllerDeterminedShouldDeleteBackwards:(TypingLogicController *)controller
{
    NSLog(@"deleted text");
    
    [self.textDocumentProxy deleteBackward];
    
    [self.typingLogicController determineShiftKeyState];
}

- (void)typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:(TypingLogicController *)controller
{
    [self advanceToNextInputMode];
}

- (void)typingLogicControllerDeterminedShouldSwitchToNumericAndSymbolsKeyPane:(TypingLogicController *)controller
{
    self.currentKeyPane = KeyPaneNumericAndSymbols;
}

- (void)typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:(TypingLogicController *)controller
{
    self.currentKeyPane = KeyPanePrimary;
}

- (void)typingLogicControllerDeterminedShouldSwitchToSupplemtalSymbolsKeyPane:(TypingLogicController *)controller
{
    self.currentKeyPane = KeyPaneSupplementalSymbols;
}

@end

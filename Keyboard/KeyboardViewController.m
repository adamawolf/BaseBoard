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
    [self.typingLogicController determineShiftKeyState];
    
    //add keys
    NSMutableArray *primaryKeyPaneKeys = [NSMutableArray new];
    [[KeyboardViewController primaryKeyPaneRows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger idx, BOOL *stop) {
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
            [primaryKeyPaneKeys addObject:aKeyView];
        }];
    }];;
    self.primaryKeyPaneKeyButtons = primaryKeyPaneKeys;
    
    NSMutableArray *numericAndSymbolsKeyPaneKeys = [NSMutableArray new];
    [[KeyboardViewController numericAndSymbolsKeyPaneRows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger idx, BOOL *stop) {
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
            [numericAndSymbolsKeyPaneKeys addObject:aKeyView];
        }];
    }];;
    self.numericAndSymbolsKeyPaneKeyButtons = numericAndSymbolsKeyPaneKeys;
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
                [keyButton setNeedsDisplay];
            }
        }
    }];
}

- (void)textWillChange:(id<UITextInput>)textInput
{
    // The app is about to change the document's contents. Perform any preparation here.
    NSLog(@"textWillChange");
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    NSLog(@"textDidChange");
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
        } else if (_currentKeyPane == KeyPaneNumericAndSymbols) {
            [keysToHide addObject:self.primaryKeyPaneKeyButtons];
            [keysToShow addObject:self.numericAndSymbolsKeyPaneKeyButtons];
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

#pragma mark - KeyPositionDataSource methods

- (CGSize)keyboardSize
{
    return self.view.frame.size;
}

- (NSInteger)numberOfRows
{
    return [KeyboardViewController rowsForKeyPane:self.currentKeyPane].count;
}

- (CGFloat)minimumIntraRowSpacing
{
    return 4.0f;
}

- (NSInteger)numberOfKeysForRow:(NSInteger)row
{
    return [[KeyboardViewController rowsForKeyPane:self.currentKeyPane][row] count];
}

- (CGFloat)minimumIntraKeySpacingForRow:(NSInteger)row
{
    return 3.0f;
}

- (KeyCode)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition];
    
    return [keyCodeNumber intValue];
}

- (NSInteger)strideForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [KeyboardViewController rowsForKeyPane:self.currentKeyPane][indexPath.keyRow][indexPath.keyPosition];
    
    NSInteger stride = 1;
    
    if ([keyCodeNumber intValue] == KeyCodeShift) {
        stride = 2;
    } else if ([keyCodeNumber intValue] == KeyCodeDelete) {
        stride = 2;
    } else if ([keyCodeNumber intValue] == KeyCodeSpace) {
        stride = 4;
    } else if ([keyCodeNumber intValue] == KeyCodeReturn) {
        stride = 2;
    }
    
    return stride;
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

@end

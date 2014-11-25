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

@property (nonatomic, strong) KeyPositionController *keyPositionController;
@property (nonatomic, strong) TypingLogicController *typingLogicController;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyPositionController = [[KeyPositionController alloc] init];
    self.keyPositionController.dataSource = self;
    
    self.typingLogicController = [[TypingLogicController alloc] initWithDelegate:self andTextDocumentProxy:self.textDocumentProxy];
    [self.typingLogicController determineShiftKeyState];
    
    //add keys
    //KEYPANE TODO: have this be keypane specific
    [[KeyboardViewController rows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger idx, BOOL *stop) {
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
            aKeyView.dataSource = self;
            [self.view addSubview:aKeyView];
        }];
    }];;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
    NSLog(@"textWillChange");
}

- (void)textDidChange:(id<UITextInput>)textInput {
    NSLog(@"textDidChange");
}

#pragma mark - Static data methods

+ (NSArray *)rows
{
    static NSArray *_rows = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rows = @[
                  @[@(KeyCodeQ), @(KeyCodeW), @(KeyCodeE), @(KeyCodeR), @(KeyCodeT), @(KeyCodeY), @(KeyCodeU), @(KeyCodeI), @(KeyCodeO), @(KeyCodeP)],
                  @[@(KeyCodeA), @(KeyCodeS), @(KeyCodeD), @(KeyCodeF), @(KeyCodeG), @(KeyCodeH), @(KeyCodeJ), @(KeyCodeK), @(KeyCodeL)],
                  @[@(KeyCodeShift), @(KeyCodeZ), @(KeyCodeX), @(KeyCodeC), @(KeyCodeV), @(KeyCodeB), @(KeyCodeN), @(KeyCodeM), @(KeyCodeDelete)],
                  @[@(KeyCodeNumberPane), @(KeyCodeNextKeyboard), @(KeyCodeSpace), @(KeyCodeReturn)],
                  ];
    });
    
    return _rows;
}

#pragma mark - KeyPositionDataSource methods

- (CGSize)keyboardSize
{
    return self.view.frame.size;
}

- (NSInteger)numberOfRows
{
    return [KeyboardViewController rows].count;
}

- (CGFloat)minimumIntraRowSpacing
{
    return 4.0f;
}

- (NSInteger)numberOfKeysForRow:(NSInteger)row
{
    return [[KeyboardViewController rows][row] count];
}

- (CGFloat)minimumIntraKeySpacingForRow:(NSInteger)row
{
    return 3.0f;
}

- (KeyCode)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [KeyboardViewController rows][indexPath.keyRow][indexPath.keyPosition];
    
    return [keyCodeNumber intValue];
}

- (NSInteger)strideForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *keyCodeNumber = [KeyboardViewController rows][indexPath.keyRow][indexPath.keyPosition];
    
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
    NSLog(@"key press: %lu", keyButton.keyCode);
    
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

@end

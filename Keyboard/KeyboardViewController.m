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

typedef NS_ENUM(NSUInteger, KeyPane) {
    KeyPaneUnknown,
    KeyPanePrimary,
    KeyPaneNumericAndSymbols,
    KeyPaneSupplementalSymbols,
};

@interface KeyboardViewController () <KeyPositionDataSource, KeyButtonDelegate>

@property (nonatomic, strong) KeyPositionController *keyPositionController;
@property (nonatomic, strong) UIButton *nextKeyboardButton;

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
    
    //add keys
    //KEYPANE TODO: have this be keypane specific
    [[KeyboardViewController rows] enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(NSNumber *keyCodeNumber, NSUInteger idx, BOOL *stop) {
            KeyButton *aKeyView = [[KeyButton alloc] initWithKeyCode:[keyCodeNumber intValue]];
            aKeyView.delegate = self;
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
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
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
    
    if (keyButton.keyCode == KeyCodeNextKeyboard) {
        [self advanceToNextInputMode];
    }
}

@end

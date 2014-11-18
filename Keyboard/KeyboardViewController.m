//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyView.h"
#import "KeyPositionController.h"

typedef NS_ENUM(NSUInteger, KeyPane) {
    KeyPaneUnknown,
    KeyPanePrimary,
    KeyPaneNumericAndSymbols,
    KeyPaneSupplementalSymbols,
};

@interface KeyboardViewController () <KeyPositionDataSource>

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
    
    // Perform custom UI setup here
    //    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //
    //    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    //    [self.nextKeyboardButton sizeToFit];
    //    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.view addSubview:self.nextKeyboardButton];
    //
    //    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    //    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    //    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
    
    
    //    //Add some keys

}

- (void)viewDidLayoutSubviews
{
//    if (self.view.subviews.count == 0) {
        NSArray *rows = [self.keyPositionController allKeyPositionRows];
    
    NSLog(@"drawing rows: %@", rows);
    
        [rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
            [row enumerateObjectsUsingBlock:^(NSDictionary *keyDictionary, NSUInteger idx, BOOL *stop) {
                KeyView *aKeyView = [[KeyView alloc] initWithSymbol:keyDictionary[@"symbol"]];
                aKeyView.frame = [keyDictionary[@"frame"] CGRectValue];
                [self.view addSubview:aKeyView];
            }];
        }];
//    }
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
                  @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"],
                  @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"],
                  @[@"shift", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"delete"],
                  @[@"number pane", @"next keyboard", @"space", @"return"],
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

- (NSString *)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    return [KeyboardViewController rows][indexPath.keyRow][indexPath.keyPosition];
}

- (NSInteger)strideForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *symbol = [KeyboardViewController rows][indexPath.keyRow][indexPath.keyPosition];
    
    if ([symbol isEqualToString:@"space"]) {
        return 3;
    }
    
    return 1;
}

@end

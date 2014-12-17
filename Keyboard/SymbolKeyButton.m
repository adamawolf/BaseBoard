//
//  SymbolKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "SymbolKeyButton.h"

@implementation SymbolKeyButton

- (instancetype)initWithKeyCode:(KeyCode)keyCode
{
    self = [super initWithKeyCode:keyCode];
    if (self) {
        _shouldAutocapitalize = YES;
    }
    return self;
}

- (UIFont *)symbolFont
{
    static UIFont *_symbolFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _symbolFont = [UIFont systemFontOfSize: [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 23.0f : 19.0];
    });
    
    return _symbolFont;
}

- (void)drawRect:(CGRect)rect
{
    //draws standard key background
    [super drawRect:rect];
    
    CGRect keyFrame = [self keyFrame];
    
    NSString *symbol = [KeyController symbolForKeyCode:self.keyCode];
    
    BOOL isUpperCase = ([self.dataSource shiftKeyState] == ShiftKeyStateUppercase ||
                        [self.dataSource shiftKeyState] == ShiftKeyStateCapsLock);
    
    if (self.shouldAutocapitalize && isUpperCase) {
        symbol = [symbol uppercaseString];
    }
    
    NSDictionary *fontAttributes = @{
                                     NSFontAttributeName: [self symbolFont],
                                     NSForegroundColorAttributeName: self.symbolColor
                                     };
    CGSize symbolSize = [symbol sizeWithAttributes:fontAttributes];
    CGSize keySize = keyFrame.size;
    [symbol drawInRect:CGRectMake(
                                  keyFrame.origin.x + ((keySize.width - symbolSize.width) / 2.0f),
                                  keyFrame.origin.y + ((keySize.height - symbolSize.height) / 2.0f),
                                  symbolSize.width,
                                  symbolSize.height)
        withAttributes:fontAttributes];
}

@end

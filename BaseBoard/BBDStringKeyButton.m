//
//  BBDStringKeyButton.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDStringKeyButton.h"

@implementation BBDStringKeyButton

- (instancetype)initWithKeyCode:(NSUInteger)keyCode
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
        _symbolFont = [UIFont systemFontOfSize: [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad ? 19.0f : 23.0];
    });
    
    return _symbolFont;
}

- (void)drawRect:(CGRect)rect
{
    //draws standard key background
    [super drawRect:rect];
    
    CGRect keyFrame = [self keyFrame];
    
    NSString *symbol = nil;
    if (self.keyCode != BBDKeyCodeReturn) {
        symbol = [BBDKeyController textualSymbolForKeyCode:self.keyCode];
    } else {
        symbol = [BBDStringKeyButton returnKeyTextForReturnKeyType:[self.dataSource returnKeyType]];
    }
    
    BOOL isUpperCase = ([self.dataSource shiftKeyState] == BBDShiftKeyStateUppercase ||
                        [self.dataSource shiftKeyState] == BBDShiftKeyStateCapsLock);
    
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

+ (NSString *)returnKeyTextForReturnKeyType:(UIReturnKeyType)returnKeyType
{
    NSString *text;
    
    switch (returnKeyType) {
        case UIReturnKeyDefault:
            text = NSLocalizedString(@"return", @"return");
            break;
        case UIReturnKeyGo:
            text = NSLocalizedString(@"go", @"go");
            break;
        case UIReturnKeyGoogle:
            text = NSLocalizedString(@"search", @"search");
            break;
        case UIReturnKeyJoin:
            text = NSLocalizedString(@"join", @"join");
            break;
        case UIReturnKeyNext:
            text = NSLocalizedString(@"next", @"next");
            break;
        case UIReturnKeyRoute:
            text = NSLocalizedString(@"route", @"route");
            break;
        case UIReturnKeySearch:
            text = NSLocalizedString(@"search", @"search");
            break;
        case UIReturnKeySend:
            text = NSLocalizedString(@"send", @"send");
            break;
        case UIReturnKeyYahoo:
            text = NSLocalizedString(@"search", @"search");
            break;
        case UIReturnKeyDone:
            text = NSLocalizedString(@"done", @"done");
            break;
        case UIReturnKeyEmergencyCall:
            text = NSLocalizedString(@"call", @"call");
            break;
            
        default:
            text = NSLocalizedString(@"return", @"return");
            break;
    }
    
    return text;
}

@end

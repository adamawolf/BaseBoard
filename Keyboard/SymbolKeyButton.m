//
//  SymbolKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "SymbolKeyButton.h"

@implementation SymbolKeyButton

- (void)drawRect:(CGRect)rect
{
    //draws standard key background
    [super drawRect:rect];
    
    CGRect keyFrame = [self keyFrame];
    
    NSDictionary *fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    
    NSString *symbol = [KeyController symbolForKeyCode:self.keyCode forShiftKeyState:[self.dataSource shiftKeyState]];
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

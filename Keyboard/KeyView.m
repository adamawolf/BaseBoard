//
//  KeyView.m
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyView.h"

@implementation KeyView

- (instancetype)initWithSymbol:(NSString *)symbol
{
    self = [super init];
    if (self) {
        _symbol = symbol;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithWhite:0.9 alpha:1.0f] set];
    CGContextFillRect(context, rect);
    
    [self.symbol drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
}


@end

//
//  KeyView.m
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyView.h"

@interface KeyView ()

@property (nonatomic, strong, readwrite) NSString *symbol;
@property (nonatomic, assign) CGFloat shadowHeight;

@end

@implementation KeyView

- (instancetype)initWithSymbol:(NSString *)symbol
{
    self = [super init];
    if (self) {
        _symbol = symbol;
        
        _shadowHeight = 1.5f;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGSize keySize = [self keySize];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, self.shadowHeight, keySize.width, keySize.height) cornerRadius:4.0f];
    [[UIColor colorWithRed:(136.0f/255.0f) green:(138.0f/255.0f) blue:(142.0f/255.0f) alpha:1.0f] set];
    [bezierPath fill];
    
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, keySize.width, keySize.height) cornerRadius:4.0f];
    [[UIColor whiteColor] set];
    [bezierPath fill];
    
    NSDictionary *fontAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGSize symbolSize = [self.symbol sizeWithAttributes:fontAttributes];
    [self.symbol drawInRect:CGRectMake(
                                       (keySize.width - symbolSize.width) / 2.0f,
                                       (keySize.height - symbolSize.height) / 2.0f,
                                       symbolSize.width,
                                       symbolSize.height)
             withAttributes:fontAttributes];
}

#pragma mark - Dimension Helper methods

- (CGSize)keySize
{    
    return CGSizeMake(self.frame.size.width, self.frame.size.height - self.shadowHeight);
}


@end

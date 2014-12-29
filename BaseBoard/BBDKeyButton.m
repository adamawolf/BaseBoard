//
//  BBDKeyButton.m
//  BaseBoard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDKeyButton.h"

@interface BBDKeyButton ()

@property (nonatomic, readwrite) NSUInteger keyCode;
@property (nonatomic, assign) CGFloat shadowHeight;

@end

@implementation BBDKeyButton

- (instancetype)initWithKeyCode:(NSUInteger)keyCode
{
    self = [super init];
    if (self) {
        _keyCode = keyCode;
        
        _shadowHeight = 1.5f;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addTarget:self action:@selector(touchUpInsideDidFire:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setDataSource:(id<BBDKeyButtonDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self setNeedsDisplay];
}

- (UIColor *)symbolColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor whiteColor];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor blackColor];
        });
        color = _lightColor;
    }
    
    return color;
}

- (UIColor *)backgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(90.0f / 255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor whiteColor];
        });
        color = _lightColor;
    }
    
    return color;
}

- (UIColor *)shadowColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(15.0f / 255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor colorWithRed:(136.0f / 255.0f) green:(138.0f / 255.0f) blue:(142.0f / 255.0f) alpha:1.0f];
        });
        color = _lightColor;
    }
    
    return color;
}

- (UIColor *)highlightedBackgroundColor
{
    UIColor *color = nil;
    if ([self.dataSource keyboardAppearance] == UIKeyboardAppearanceDark) {
        static UIColor *_darkColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _darkColor = [UIColor colorWithWhite:(60.0f / 255.0f) alpha:1.0f];
        });
        color = _darkColor;
    } else {
        static UIColor *_lightColor = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _lightColor = [UIColor colorWithWhite:.8 alpha:1.0f];
        });
        color = _lightColor;
    }
    
    return color;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGRect keyFrame = [self keyFrame];
    CGRect shadowFrame = CGRectMake(keyFrame.origin.x, keyFrame.origin.y + self.shadowHeight, keyFrame.size.width, keyFrame.size.height);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:shadowFrame cornerRadius:4.0f];
    [[self shadowColor] set];
    [bezierPath fill];
    
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:keyFrame cornerRadius:4.0f];
    if (self.highlighted == NO) {
        [[self backgroundColor] set];
    } else {
        [[self highlightedBackgroundColor] set];
    }
    [bezierPath fill];
}

#pragma mark - Dimension Helper methods

- (CGRect)keyFrame
{
    return CGRectMake(self.paddings.left,
                      self.paddings.top,
                      self.frame.size.width - (self.paddings.left + self.paddings.right),
                      self.frame.size.height - (self.paddings.top + self.paddings.bottom + self.shadowHeight));
}

#pragma mark - Action methods

- (void)touchUpInsideDidFire:(BBDKeyButton *)sender
{
    [self.delegate keyButtonDidGetTapped:sender];
}

@end

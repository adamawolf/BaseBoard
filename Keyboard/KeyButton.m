//
//  KeyView.m
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyButton.h"

@interface KeyButton ()

@property (nonatomic, readwrite) KeyCode keyCode;
@property (nonatomic, assign) CGFloat shadowHeight;

@end

@implementation KeyButton

- (instancetype)initWithKeyCode:(KeyCode)keyCode
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
    [[UIColor colorWithRed:(136.0f/255.0f) green:(138.0f/255.0f) blue:(142.0f/255.0f) alpha:1.0f] set];
    [bezierPath fill];
    
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:keyFrame cornerRadius:4.0f];
    if (self.highlighted == NO) {
        [[UIColor whiteColor] set];
    } else {
        [[UIColor colorWithWhite:.8 alpha:1.0f] set];
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

- (void)touchUpInsideDidFire:(KeyButton *)sender
{
    [self.delegate keyButtonDidGetTapped:sender];
}

@end

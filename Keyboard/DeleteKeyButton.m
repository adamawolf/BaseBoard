//
//  DeleteKeyButton.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/15/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "DeleteKeyButton.h"

static NSTimeInterval const kDeleteRepeatTimeInterval = 0.2f;
static NSInteger const kNumDeletesForLargeStride = 9;
static NSInteger const kLargeDeleteStringCharacterCount = 6;

@interface DeleteKeyButton ()

@property (nonatomic, strong) NSTimer *deleteRepeatTimer;
@property (nonatomic, assign) NSInteger deleteRepeatCount;

@end

@implementation DeleteKeyButton

- (instancetype)initWithKeyCode:(KeyCode)keyCode
{
    self = [super initWithKeyCode:keyCode];
    
    if (self) {
        [self addTarget:self action:@selector(handleBeginTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(handleEndTouchDown:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchDragOutside];
    }
    
    return self;
}

#pragma mark - Action methods

- (void)touchUpInsideDidFire:(KeyButton *)sender
{
    [self handleEndTouchDown:sender];
    
    if (self.deleteRepeatCount == 0) {
        //handle a simple tap
        [self.delegate keyButtonDidGetTapped:sender];
    }
}

- (void)handleBeginTouchDown:(id)sender
{
    self.deleteRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:kDeleteRepeatTimeInterval target:self selector:@selector(deleteRepeatTimerFired:) userInfo:nil repeats:NO];
}

- (void)deleteRepeatTimerFired:(id)sender
{
    NSInteger charactersToDelete = 1;
    if (self.deleteRepeatCount >= kNumDeletesForLargeStride) {
        charactersToDelete = kLargeDeleteStringCharacterCount;
    }
    
    for (int i = 0; i < charactersToDelete; i++) {
        [self.delegate keyButtonDidGetTapped:self];
    }
    
    self.deleteRepeatCount += 1;
    self.deleteRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:kDeleteRepeatTimeInterval target:self selector:@selector(deleteRepeatTimerFired:) userInfo:nil repeats:NO];
}

- (void)handleEndTouchDown:(id)sender
{
    [self.deleteRepeatTimer invalidate];
    self.deleteRepeatTimer = nil;
    
    self.deleteRepeatCount = 0;;
}

@end

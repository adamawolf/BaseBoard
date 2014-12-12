//
//  ShiftKeyButton.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyButton.h"

@protocol ShiftKeyButtonDataSource <NSObject>

- (ShiftKeyState)shiftKeyState;

@end

@interface ShiftKeyButton : KeyButton

@property (nonatomic, weak) id<ShiftKeyButtonDataSource> dataSource;

@end

//
//  BBDShiftKeyButton.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//
//  Draws a different symbol for various shift key states (lowercase, uppercase, locked).

#import "BBDKeyButton.h"

@protocol BBDShiftKeyButtonDataSource <BBDKeyButtonDataSource>

- (BBDShiftKeyState)shiftKeyState;

@end

@interface BBDShiftKeyButton : BBDKeyButton

@property (nonatomic, weak) id<BBDShiftKeyButtonDataSource> dataSource;

@end

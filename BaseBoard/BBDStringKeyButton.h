//
//  BBDStringKeyButton.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//
//  A KeyButton that draws a NSString as it's symbol using Core Graphics.
//  e.g. the 'A' key

#import "BBDKeyButton.h"

@protocol BBDStringKeyButtonDataSource <BBDKeyButtonDataSource>

- (BBDShiftKeyState)shiftKeyState;
- (UIReturnKeyType)returnKeyType;

@end

@interface BBDStringKeyButton : BBDKeyButton

@property (nonatomic, weak) id<BBDStringKeyButtonDataSource> dataSource;
@property (nonatomic, assign) BOOL shouldAutocapitalize;

@end

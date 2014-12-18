//
//  BBDSymbolKeyButton.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//
//  A KeyButton that draws its symbol directly using Core Graphics.
//  e.g. the 'A' key

#import "BBDKeyButton.h"

@protocol BBDSymbolKeyButtonDataSource <BBDKeyButtonDataSource>

- (BBDShiftKeyState)shiftKeyState;
- (UIReturnKeyType)returnKeyType;

@end

@interface BBDSymbolKeyButton : BBDKeyButton

@property (nonatomic, weak) id<BBDSymbolKeyButtonDataSource> dataSource;
@property (nonatomic, assign) BOOL shouldAutocapitalize;

@end

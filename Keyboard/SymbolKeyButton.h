//
//  SymbolKeyButton.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//
//  A KeyButton that draws its symbol directly using Core Graphics.
//  e.g. the 'A' key

#import "KeyButton.h"

@protocol SymbolKeyButtonDataSource <NSObject>

- (ShiftKeyState)shiftKeyState;

@end

@interface SymbolKeyButton : KeyButton

@property (nonatomic, weak) id<SymbolKeyButtonDataSource> dataSource;
@property (nonatomic, assign) BOOL shouldAutocapitalize;

@end

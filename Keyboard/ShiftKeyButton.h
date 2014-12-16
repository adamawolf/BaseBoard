//
//  ShiftKeyButton.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "FunctionKeyButton.h"

@protocol ShiftKeyButtonDataSource <KeyButtonDataSource>

- (ShiftKeyState)shiftKeyState;

@end

@interface ShiftKeyButton : FunctionKeyButton

@property (nonatomic, weak) id<ShiftKeyButtonDataSource> dataSource;

@end

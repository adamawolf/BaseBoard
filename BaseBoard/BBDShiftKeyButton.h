//
//  BBDShiftKeyButton.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 12/11/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDFunctionKeyButton.h"

@protocol BBDShiftKeyButtonDataSource <BBDKeyButtonDataSource>

- (BBDShiftKeyState)shiftKeyState;

@end

@interface BBDShiftKeyButton : BBDFunctionKeyButton

@property (nonatomic, weak) id<BBDShiftKeyButtonDataSource> dataSource;

@end

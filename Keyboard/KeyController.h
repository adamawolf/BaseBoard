//
//  KeyController.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/18/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KeyCode) {
    KeyCodeInvalid,
    //first row
    KeyCodeQ,
    KeyCodeW,
    KeyCodeE,
    KeyCodeR,
    KeyCodeT,
    KeyCodeY,
    KeyCodeU,
    KeyCodeI,
    KeyCodeO,
    KeyCodeP,
    //second row
    KeyCodeA,
    KeyCodeS,
    KeyCodeD,
    KeyCodeF,
    KeyCodeG,
    KeyCodeH,
    KeyCodeJ,
    KeyCodeK,
    KeyCodeL,
    //third row
    KeyCodeShift,
    KeyCodeZ,
    KeyCodeX,
    KeyCodeC,
    KeyCodeV,
    KeyCodeB,
    KeyCodeN,
    KeyCodeM,
    KeyCodeDelete,
    //bottom row
    KeyCodeNumberPane,
    KeyCodeNextKeyboard,
    KeyCodeSpace,
    KeyCodeReturn,
};

@interface KeyController : NSObject

+ (NSString *)symbolForKeyCode:(KeyCode)keyCode;

@end

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
    //number and symbol pane
    //first row
    KeyCode1,
    KeyCode2,
    KeyCode3,
    KeyCode4,
    KeyCode5,
    KeyCode6,
    KeyCode7,
    KeyCode8,
    KeyCode9,
    KeyCode0,
    //second row
    KeyCodeDash,
    KeyCodeForwardSlash,
    KeyCodeColon,
    KeyCodeSemicolon,
    KeyCodeOpenParenthesis,
    KeyCodeCloseParenthesis,
    KeyCodeDollar,
    KeyCodeAmersand,
    KeyCodeAt,
    KeyCodeDoubleQuote,
    //third row
    KeyCodeSymbolsPane,
    KeyCodePeriod,
    KeyCodeComma,
    KeyCodeQuestionMark,
    KeyCodeExclamationMark,
    KeyCodeSingleQuote,
    //KeyCodeNumberPaneDelete,          //use same keycode as primary keys
    //fourth row
    KeyCodePrimaryKeyPane,
    //KeyCodeNumberPaneNextKeyboard,    //use same keycode as primary keys
    //KeyCodeNumberPaneSpace,
    //KeyCodeNumberPaneReturn,
    //supplemantal symbol pane
    //first row
    KeyCodeOpenSquareBracket,
    KeyCodeCloseSquareBracket,
    KeyCodeOpenCurlyBracket,
    KeyCodeCloseCurlyBracket,
    KeyCodePoundSign,
    KeyCodePercent,
    KeyCodeCaret,
    KeyCodeAsterisk,
    KeyCodePlus,
    KeyCodeEqual,
    //second row
    KeyCodeUnderscore,
    KeyCodeBackSlash,
    KeyCodeVerticalBar,
    KeyCodeTilde,
    KeyCodeLessThan,
    KeyCodeGreaterThan,
    KeyCodeEuro,
    KeyCodePound,
    KeyCodeYen,
    KeyCodeBullet,
    //third row
    //KeyCodeNumberPane,
    //KeyCodeSymbolsPane,
    //KeyCodePeriod,
    //KeyCodeComma,
    //KeyCodeQuestionMark,
    //KeyCodeExclamationMark,
    //KeyCodeSingleQuote,
    //KeyCodeNumberPaneDelete,
    //fourth row
    //KeyCodePrimaryKeyPane,
    //KeyCodeNumberPaneNextKeyboard,
    //KeyCodeNumberPaneSpace,
    //KeyCodeNumberPaneReturn,
};

typedef NS_ENUM(NSUInteger, ShiftKeyState) {
    ShiftKeyStateUnknown,
    ShiftKeyStateLowercase,
    ShiftKeyStateUppercase,
    ShiftKeyStateCapsLock,
};

@interface KeyController : NSObject

+ (Class)keyButtonClassForKeyCode:(KeyCode)keyCode;

+ (NSString *)symbolForKeyCode:(KeyCode)keyCode;
+ (NSString *)yieldedLowercaseTextForKeyCode:(KeyCode)keyCode forShiftKeyState:(ShiftKeyState)shiftKeyState;

+ (NSIndexSet *)simpleTextGeneratingKeyCodeIndexSet;

@end

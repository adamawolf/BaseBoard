//
//  BBDKeyController.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/18/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BBDKeyCode) {
    BBDKeyCodeInvalid,
    //first row
    BBDKeyCodeQ,
    BBDKeyCodeW,
    BBDKeyCodeE,
    BBDKeyCodeR,
    BBDKeyCodeT,
    BBDKeyCodeY,
    BBDKeyCodeU,
    BBDKeyCodeI,
    BBDKeyCodeO,
    BBDKeyCodeP,
    //second row
    BBDKeyCodeA,
    BBDKeyCodeS,
    BBDKeyCodeD,
    BBDKeyCodeF,
    BBDKeyCodeG,
    BBDKeyCodeH,
    BBDKeyCodeJ,
    BBDKeyCodeK,
    BBDKeyCodeL,
    //third row
    BBDKeyCodeShift,
    BBDKeyCodeZ,
    BBDKeyCodeX,
    BBDKeyCodeC,
    BBDKeyCodeV,
    BBDKeyCodeB,
    BBDKeyCodeN,
    BBDKeyCodeM,
    BBDKeyCodeDelete,
    BBDKeyCodeSecondShift, //iPad only
    //bottom row
    BBDKeyCodeNumberPane,
    BBDKeyCodeNextKeyboard,
    BBDKeyCodeSpace,
    BBDKeyCodeReturn,
    BBDKeyCodeSecondNumberPane, //iPad only
    //number and symbol pane
    //first row
    BBDKeyCode1,
    BBDKeyCode2,
    BBDKeyCode3,
    BBDKeyCode4,
    BBDKeyCode5,
    BBDKeyCode6,
    BBDKeyCode7,
    BBDKeyCode8,
    BBDKeyCode9,
    BBDKeyCode0,
    //second row
    BBDKeyCodeDash,
    BBDKeyCodeForwardSlash,
    BBDKeyCodeColon,
    BBDKeyCodeSemicolon,
    BBDKeyCodeOpenParenthesis,
    BBDKeyCodeCloseParenthesis,
    BBDKeyCodeDollar,
    BBDKeyCodeAmersand,
    BBDKeyCodeAt,
    BBDKeyCodeDoubleQuote,
    //third row
    BBDKeyCodeSymbolsPane,
    BBDKeyCodePeriod,
    BBDKeyCodeComma,
    BBDKeyCodeQuestionMark,
    BBDKeyCodeExclamationMark,
    BBDKeyCodeSingleQuote,
    //fourth row
    BBDKeyCodePrimaryKeyPane,
    //supplemantal symbol pane
    //first row
    BBDKeyCodeOpenSquareBracket,
    BBDKeyCodeCloseSquareBracket,
    BBDKeyCodeOpenCurlyBracket,
    BBDKeyCodeCloseCurlyBracket,
    BBDKeyCodePoundSign,
    BBDKeyCodePercent,
    BBDKeyCodeCaret,
    BBDKeyCodeAsterisk,
    BBDKeyCodePlus,
    BBDKeyCodeEqual,
    //second row
    BBDKeyCodeUnderscore,
    BBDKeyCodeBackSlash,
    BBDKeyCodeVerticalBar,
    BBDKeyCodeTilde,
    BBDKeyCodeLessThan,
    BBDKeyCodeGreaterThan,
    BBDKeyCodeEuro,
    BBDKeyCodePound,
    BBDKeyCodeYen,
    BBDKeyCodeBullet,
    //third row
    BBDKeyCodeThirdRowNumberPane,
    //fourth row
};

typedef NS_ENUM(NSUInteger, BBDShiftKeyState) {
    BBDShiftKeyStateUnknown,
    BBDShiftKeyStateLowercase,
    BBDShiftKeyStateUppercase,
    BBDShiftKeyStateCapsLock,
};

@interface BBDKeyController : NSObject

+ (Class)keyButtonClassForKeyCode:(BBDKeyCode)keyCode;

//text to be drawn on a key view for particular key code
+ (NSString *)textualSymbolForKeyCode:(BBDKeyCode)keyCode;

//text yielded by a 
+ (NSString *)yieldedLowercaseTextForKeyCode:(BBDKeyCode)keyCode;

//set of keycodes which just result in adding
+ (NSIndexSet *)simpleTextGeneratingKeyCodeIndexSet;

@end

//
//  KeyController.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/18/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyController.h"

#import "KeyButton.h"
#import "SymbolKeyButton.h"
#import "ShiftKeyButton.h"
#import "SymbolFunctionKeyButton.h"
#import "IconFunctionKeyButton.h"

@implementation KeyController

+ (Class)keyButtonClassForKeyCode:(KeyCode)keyCode
{
    Class class = [SymbolKeyButton class];
    
    if (keyCode == KeyCodeSpace) {
        class = [KeyButton class];
    } else if (keyCode == KeyCodeShift) {
        class = [ShiftKeyButton class];
    } else if (keyCode == KeyCodeNumberPane ||
               keyCode == KeyCodeReturn ||
               keyCode == KeyCodeSymbolsPane ||
               keyCode == KeyCodePrimaryKeyPane) {
        class = [SymbolFunctionKeyButton class];
    } else if (keyCode == KeyCodeDelete ||
               keyCode == KeyCodeNextKeyboard) {
        class = [IconFunctionKeyButton class];
    }
    
    return class;
}

+ (NSString *)symbolForKeyCode:(KeyCode)keyCode
{
    NSString *symbol = @"";
    
    switch (keyCode) {
        case KeyCodeQ:
            symbol = @"q";
            break;
        case KeyCodeW:
            symbol = @"w";
            break;
        case KeyCodeE:
            symbol = @"e";
            break;
        case KeyCodeR:
            symbol = @"r";
            break;
        case KeyCodeT:
            symbol = @"t";
            break;
        case KeyCodeY:
            symbol = @"y";
            break;
        case KeyCodeU:
            symbol = @"u";
            break;
        case KeyCodeI:
            symbol = @"i";
            break;
        case KeyCodeO:
            symbol = @"o";
            break;
        case KeyCodeP:
            symbol = @"p";
            break;
        case KeyCodeA:
            symbol = @"a";
            break;
        case KeyCodeS:
            symbol = @"s";
            break;
        case KeyCodeD:
            symbol = @"d";
            break;
        case KeyCodeF:
            symbol = @"f";
            break;
        case KeyCodeG:
            symbol = @"g";
            break;
        case KeyCodeH:
            symbol = @"h";
            break;
        case KeyCodeJ:
            symbol = @"j";
            break;
        case KeyCodeK:
            symbol = @"k";
            break;
        case KeyCodeL:
            symbol = @"l";
            break;
        case KeyCodeZ:
            symbol = @"z";
            break;
        case KeyCodeX:
            symbol = @"x";
            break;
        case KeyCodeC:
            symbol = @"c";
            break;
        case KeyCodeV:
            symbol = @"v";
            break;
        case KeyCodeB:
            symbol = @"b";
            break;
        case KeyCodeN:
            symbol = @"n";
            break;
        case KeyCodeM:
            symbol = @"m";
            break;
        case KeyCodeDelete:
            symbol = @"<";
            break;
        case KeyCodeNumberPane:
            symbol = @"123";
            break;
        case KeyCodeNextKeyboard:
            symbol = @"*";
            break;
        case KeyCodeSpace:
            symbol = @" ";
            break;
        case KeyCodeReturn:
            symbol = @"return";
            break;
        case KeyCode1:
            symbol = @"1";
            break;
        case KeyCode2:
            symbol = @"2";
            break;
        case KeyCode3:
            symbol = @"3";
            break;
        case KeyCode4:
            symbol = @"4";
            break;
        case KeyCode5:
            symbol = @"5";
            break;
        case KeyCode6:
            symbol = @"6";
            break;
        case KeyCode7:
            symbol = @"7";
            break;
        case KeyCode8:
            symbol = @"8";
            break;
        case KeyCode9:
            symbol = @"9";
            break;
        case KeyCode0:
            symbol = @"0";
            break;
        case KeyCodeDash:
            symbol = @"-";
            break;
        case KeyCodeForwardSlash:
            symbol = @"/";
            break;
        case KeyCodeColon:
            symbol = @":";
            break;
        case KeyCodeSemicolon:
            symbol = @";";
            break;
        case KeyCodeOpenParenthesis:
            symbol = @"(";
            break;
        case KeyCodeCloseParenthesis:
            symbol = @")";
            break;
        case KeyCodeDollar:
            symbol = @"$";
            break;
        case KeyCodeAmersand:
            symbol = @"&";
            break;
        case KeyCodeAt:
            symbol = @"@";
            break;
        case KeyCodeDoubleQuote:
            symbol = @"\"";
            break;
        case KeyCodeSymbolsPane:
            symbol = @"#+=";
            break;
        case KeyCodePeriod:
            symbol = @".";
            break;
        case KeyCodeComma:
            symbol = @",";
            break;
        case KeyCodeQuestionMark:
            symbol = @"?";
            break;
        case KeyCodeExclamationMark:
            symbol = @"!";
            break;
        case KeyCodeSingleQuote:
            symbol = @"'";
            break;
        case KeyCodePrimaryKeyPane:
            symbol = @"ABC";
            break;
        case KeyCodeOpenSquareBracket:
            symbol = @"[";
            break;
        case KeyCodeCloseSquareBracket:
            symbol = @"]";
            break;
        case KeyCodeOpenCurlyBracket:
            symbol = @"{";
            break;
        case KeyCodeCloseCurlyBracket:
            symbol = @"}";
            break;
        case KeyCodePoundSign:
            symbol = @"#";
            break;
        case KeyCodePercent:
            symbol = @"%";
            break;
        case KeyCodeCaret:
            symbol = @"^";
            break;
        case KeyCodeAsterisk:
            symbol = @"*";
            break;
        case KeyCodePlus:
            symbol = @"+";
            break;
        case KeyCodeEqual:
            symbol = @"=";
            break;
        case KeyCodeUnderscore:
            symbol = @"_";
            break;
        case KeyCodeBackSlash:
            symbol = @"\\";
            break;
        case KeyCodeVerticalBar:
            symbol = @"|";
            break;
        case KeyCodeTilde:
            symbol = @"~";
            break;
        case KeyCodeLessThan:
            symbol = @"<";
            break;
        case KeyCodeGreaterThan:
            symbol = @">";
            break;
        case KeyCodeEuro:
            symbol = @"€";
            break;
        case KeyCodePound:
            symbol = @"£";
            break;
        case KeyCodeYen:
            symbol = @"¥";
            break;
        case KeyCodeBullet:
            symbol = @"•";
            break;
        default:
            break;
    }
    
    return symbol;
}

+ (NSString *)yieldedLowercaseTextForKeyCode:(KeyCode)keyCode forShiftKeyState:(ShiftKeyState)shiftKeyState
{
    NSString *yieldedText = nil;
    BOOL isUpperCase = shiftKeyState == ShiftKeyStateUppercase || shiftKeyState == ShiftKeyStateCapsLock;
    
    switch (keyCode) {
        case KeyCodeQ:
            yieldedText = @"q";
            break;
        case KeyCodeW:
            yieldedText = @"w";
            break;
        case KeyCodeE:
            yieldedText = @"e";
            break;
        case KeyCodeR:
            yieldedText = @"r";
            break;
        case KeyCodeT:
            yieldedText = @"t";
            break;
        case KeyCodeY:
            yieldedText = @"y";
            break;
        case KeyCodeU:
            yieldedText = @"u";
            break;
        case KeyCodeI:
            yieldedText = @"i";
            break;
        case KeyCodeO:
            yieldedText = @"o";
            break;
        case KeyCodeP:
            yieldedText = @"p";
            break;
        case KeyCodeA:
            yieldedText = @"a";
            break;
        case KeyCodeS:
            yieldedText = @"s";
            break;
        case KeyCodeD:
            yieldedText = @"d";
            break;
        case KeyCodeF:
            yieldedText = @"f";
            break;
        case KeyCodeG:
            yieldedText = @"g";
            break;
        case KeyCodeH:
            yieldedText = @"h";
            break;
        case KeyCodeJ:
            yieldedText = @"j";
            break;
        case KeyCodeK:
            yieldedText = @"k";
            break;
        case KeyCodeL:
            yieldedText = @"l";
            break;
        case KeyCodeShift:
            yieldedText = @"^";
            break;
        case KeyCodeZ:
            yieldedText = @"z";
            break;
        case KeyCodeX:
            yieldedText = @"x";
            break;
        case KeyCodeC:
            yieldedText = @"c";
            break;
        case KeyCodeV:
            yieldedText = @"v";
            break;
        case KeyCodeB:
            yieldedText = @"b";
            break;
        case KeyCodeN:
            yieldedText = @"n";
            break;
        case KeyCodeM:
            yieldedText = @"m";
            break;
        case KeyCodeSpace:
            yieldedText = @" ";
            break;
        case KeyCodeReturn:
            yieldedText = @"\n";
            break;
        case KeyCode1:
            yieldedText = @"1";
            break;
        case KeyCode2:
            yieldedText = @"2";
            break;
        case KeyCode3:
            yieldedText = @"3";
            break;
        case KeyCode4:
            yieldedText = @"4";
            break;
        case KeyCode5:
            yieldedText = @"5";
            break;
        case KeyCode6:
            yieldedText = @"6";
            break;
        case KeyCode7:
            yieldedText = @"7";
            break;
        case KeyCode8:
            yieldedText = @"8";
            break;
        case KeyCode9:
            yieldedText = @"9";
            break;
        case KeyCode0:
            yieldedText = @"0";
            break;
        case KeyCodeDash:
            yieldedText = @"-";
            break;
        case KeyCodeForwardSlash:
            yieldedText = @"/";
            break;
        case KeyCodeColon:
            yieldedText = @":";
            break;
        case KeyCodeSemicolon:
            yieldedText = @";";
            break;
        case KeyCodeOpenParenthesis:
            yieldedText = @"(";
            break;
        case KeyCodeCloseParenthesis:
            yieldedText = @")";
            break;
        case KeyCodeDollar:
            yieldedText = @"$";
            break;
        case KeyCodeAmersand:
            yieldedText = @"&";
            break;
        case KeyCodeAt:
            yieldedText = @"@";
            break;
        case KeyCodeDoubleQuote:
            yieldedText = @"\"";
            break;
        case KeyCodePeriod:
            yieldedText = @".";
            break;
        case KeyCodeComma:
            yieldedText = @",";
            break;
        case KeyCodeQuestionMark:
            yieldedText = @"?";
            break;
        case KeyCodeExclamationMark:
            yieldedText = @"!";
            break;
        case KeyCodeSingleQuote:
            yieldedText = @"'";
            break;
        case KeyCodeOpenSquareBracket:
            yieldedText = @"[";
            break;
        case KeyCodeCloseSquareBracket:
            yieldedText = @"]";
            break;
        case KeyCodeOpenCurlyBracket:
            yieldedText = @"{";
            break;
        case KeyCodeCloseCurlyBracket:
            yieldedText = @"}";
            break;
        case KeyCodePoundSign:
            yieldedText = @"#";
            break;
        case KeyCodePercent:
            yieldedText = @"%";
            break;
        case KeyCodeCaret:
            yieldedText = @"^";
            break;
        case KeyCodeAsterisk:
            yieldedText = @"*";
            break;
        case KeyCodePlus:
            yieldedText = @"+";
            break;
        case KeyCodeEqual:
            yieldedText = @"=";
            break;
        case KeyCodeUnderscore:
            yieldedText = @"_";
            break;
        case KeyCodeBackSlash:
            yieldedText = @"\\";
            break;
        case KeyCodeVerticalBar:
            yieldedText = @"|";
            break;
        case KeyCodeTilde:
            yieldedText = @"~";
            break;
        case KeyCodeLessThan:
            yieldedText = @"<";
            break;
        case KeyCodeGreaterThan:
            yieldedText = @">";
            break;
        case KeyCodeEuro:
            yieldedText = @"€";
            break;
        case KeyCodePound:
            yieldedText = @"£";
            break;
        case KeyCodeYen:
            yieldedText = @"¥";
            break;
        case KeyCodeBullet:
            yieldedText = @"•";
            break;
        default:
            break;
    }
    
    if (isUpperCase) {
        yieldedText = [yieldedText uppercaseString];
    }
    
    return yieldedText;
}

+ (NSIndexSet *)simpleTextGeneratingKeyCodeIndexSet
{
    static NSIndexSet *_simpleTextGeneratingKeyCodeIndexSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
        
        //effecient, but depends on ENUM order in .h
        //first pane
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodeQ, KeyCodeL - KeyCodeQ + 1}];
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodeZ, KeyCodeM - KeyCodeZ + 1}];
        [mutableIndexSet addIndex:KeyCodeReturn];
        //second pane
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCode1, KeyCodeDoubleQuote - KeyCode1 + 1}];
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodePeriod, KeyCodeSingleQuote - KeyCodePeriod + 1}];
        //third pane
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodeOpenSquareBracket, KeyCodeBullet - KeyCodeOpenSquareBracket + 1}];
        
        _simpleTextGeneratingKeyCodeIndexSet = mutableIndexSet;
    });
    
    return _simpleTextGeneratingKeyCodeIndexSet;
}

@end

//
//  BBDKeyController.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/18/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDKeyController.h"

#import "BBDKeyButton.h"
#import "BBDStringKeyButton.h"
#import "BBDShiftKeyButton.h"
#import "BBDDarkStringKeyButton.h"
#import "BBDDarkImageKeyButton.h"
#import "BBDDeleteKeyButton.h"

@implementation BBDKeyController

+ (Class)keyButtonClassForKeyCode:(BBDKeyCode)keyCode
{
    Class class = [BBDStringKeyButton class];
    
    if (keyCode == BBDKeyCodeSpace) {
        class = [BBDKeyButton class];
    } else if (keyCode == BBDKeyCodeShift ||
               keyCode == BBDKeyCodeSecondShift) {
        class = [BBDShiftKeyButton class];
    } else if (keyCode == BBDKeyCodeNumberPane ||
               keyCode == BBDKeyCodeSecondNumberPane ||
               keyCode == BBDKeyCodeThirdRowNumberPane ||
               keyCode == BBDKeyCodeReturn ||
               keyCode == BBDKeyCodeSymbolsPane ||
               keyCode == BBDKeyCodePrimaryKeyPane) {
        class = [BBDDarkStringKeyButton class];
    } else if (keyCode == BBDKeyCodeNextKeyboard) {
        class = [BBDDarkImageKeyButton class];
    } else if (keyCode == BBDKeyCodeDelete) {
        class = [BBDDeleteKeyButton class];
    }
    
    return class;
}

+ (NSString *)textualSymbolForKeyCode:(BBDKeyCode)keyCode
{
    NSString *symbol = @"";
    
    switch (keyCode) {
        case BBDKeyCodeQ:
            symbol = @"q";
            break;
        case BBDKeyCodeW:
            symbol = @"w";
            break;
        case BBDKeyCodeE:
            symbol = @"e";
            break;
        case BBDKeyCodeR:
            symbol = @"r";
            break;
        case BBDKeyCodeT:
            symbol = @"t";
            break;
        case BBDKeyCodeY:
            symbol = @"y";
            break;
        case BBDKeyCodeU:
            symbol = @"u";
            break;
        case BBDKeyCodeI:
            symbol = @"i";
            break;
        case BBDKeyCodeO:
            symbol = @"o";
            break;
        case BBDKeyCodeP:
            symbol = @"p";
            break;
        case BBDKeyCodeA:
            symbol = @"a";
            break;
        case BBDKeyCodeS:
            symbol = @"s";
            break;
        case BBDKeyCodeD:
            symbol = @"d";
            break;
        case BBDKeyCodeF:
            symbol = @"f";
            break;
        case BBDKeyCodeG:
            symbol = @"g";
            break;
        case BBDKeyCodeH:
            symbol = @"h";
            break;
        case BBDKeyCodeJ:
            symbol = @"j";
            break;
        case BBDKeyCodeK:
            symbol = @"k";
            break;
        case BBDKeyCodeL:
            symbol = @"l";
            break;
        case BBDKeyCodeZ:
            symbol = @"z";
            break;
        case BBDKeyCodeX:
            symbol = @"x";
            break;
        case BBDKeyCodeC:
            symbol = @"c";
            break;
        case BBDKeyCodeV:
            symbol = @"v";
            break;
        case BBDKeyCodeB:
            symbol = @"b";
            break;
        case BBDKeyCodeN:
            symbol = @"n";
            break;
        case BBDKeyCodeM:
            symbol = @"m";
            break;
        case BBDKeyCodeDelete:
            symbol = @"<";
            break;
        case BBDKeyCodeNumberPane:
        case BBDKeyCodeSecondNumberPane:
        case BBDKeyCodeThirdRowNumberPane:
            symbol = @"123";
            break;
        case BBDKeyCodeNextKeyboard:
            symbol = @"*";
            break;
        case BBDKeyCodeSpace:
            symbol = @" ";
            break;
        case BBDKeyCodeReturn:
            symbol = @"return";
            break;
        case BBDKeyCode1:
            symbol = @"1";
            break;
        case BBDKeyCode2:
            symbol = @"2";
            break;
        case BBDKeyCode3:
            symbol = @"3";
            break;
        case BBDKeyCode4:
            symbol = @"4";
            break;
        case BBDKeyCode5:
            symbol = @"5";
            break;
        case BBDKeyCode6:
            symbol = @"6";
            break;
        case BBDKeyCode7:
            symbol = @"7";
            break;
        case BBDKeyCode8:
            symbol = @"8";
            break;
        case BBDKeyCode9:
            symbol = @"9";
            break;
        case BBDKeyCode0:
            symbol = @"0";
            break;
        case BBDKeyCodeDash:
            symbol = @"-";
            break;
        case BBDKeyCodeForwardSlash:
            symbol = @"/";
            break;
        case BBDKeyCodeColon:
            symbol = @":";
            break;
        case BBDKeyCodeSemicolon:
            symbol = @";";
            break;
        case BBDKeyCodeOpenParenthesis:
            symbol = @"(";
            break;
        case BBDKeyCodeCloseParenthesis:
            symbol = @")";
            break;
        case BBDKeyCodeDollar:
            symbol = @"$";
            break;
        case BBDKeyCodeAmersand:
            symbol = @"&";
            break;
        case BBDKeyCodeAt:
            symbol = @"@";
            break;
        case BBDKeyCodeDoubleQuote:
            symbol = @"\"";
            break;
        case BBDKeyCodeSymbolsPane:
            symbol = @"#+=";
            break;
        case BBDKeyCodePeriod:
            symbol = @".";
            break;
        case BBDKeyCodeComma:
            symbol = @",";
            break;
        case BBDKeyCodeQuestionMark:
            symbol = @"?";
            break;
        case BBDKeyCodeExclamationMark:
            symbol = @"!";
            break;
        case BBDKeyCodeSingleQuote:
            symbol = @"'";
            break;
        case BBDKeyCodePrimaryKeyPane:
            symbol = @"ABC";
            break;
        case BBDKeyCodeOpenSquareBracket:
            symbol = @"[";
            break;
        case BBDKeyCodeCloseSquareBracket:
            symbol = @"]";
            break;
        case BBDKeyCodeOpenCurlyBracket:
            symbol = @"{";
            break;
        case BBDKeyCodeCloseCurlyBracket:
            symbol = @"}";
            break;
        case BBDKeyCodePoundSign:
            symbol = @"#";
            break;
        case BBDKeyCodePercent:
            symbol = @"%";
            break;
        case BBDKeyCodeCaret:
            symbol = @"^";
            break;
        case BBDKeyCodeAsterisk:
            symbol = @"*";
            break;
        case BBDKeyCodePlus:
            symbol = @"+";
            break;
        case BBDKeyCodeEqual:
            symbol = @"=";
            break;
        case BBDKeyCodeUnderscore:
            symbol = @"_";
            break;
        case BBDKeyCodeBackSlash:
            symbol = @"\\";
            break;
        case BBDKeyCodeVerticalBar:
            symbol = @"|";
            break;
        case BBDKeyCodeTilde:
            symbol = @"~";
            break;
        case BBDKeyCodeLessThan:
            symbol = @"<";
            break;
        case BBDKeyCodeGreaterThan:
            symbol = @">";
            break;
        case BBDKeyCodeEuro:
            symbol = @"€";
            break;
        case BBDKeyCodePound:
            symbol = @"£";
            break;
        case BBDKeyCodeYen:
            symbol = @"¥";
            break;
        case BBDKeyCodeBullet:
            symbol = @"•";
            break;
        default:
            break;
    }
    
    return symbol;
}

+ (NSString *)yieldedLowercaseTextForKeyCode:(BBDKeyCode)keyCode
{
    NSString *yieldedText = nil;
    
    switch (keyCode) {
        case BBDKeyCodeQ:
            yieldedText = @"q";
            break;
        case BBDKeyCodeW:
            yieldedText = @"w";
            break;
        case BBDKeyCodeE:
            yieldedText = @"e";
            break;
        case BBDKeyCodeR:
            yieldedText = @"r";
            break;
        case BBDKeyCodeT:
            yieldedText = @"t";
            break;
        case BBDKeyCodeY:
            yieldedText = @"y";
            break;
        case BBDKeyCodeU:
            yieldedText = @"u";
            break;
        case BBDKeyCodeI:
            yieldedText = @"i";
            break;
        case BBDKeyCodeO:
            yieldedText = @"o";
            break;
        case BBDKeyCodeP:
            yieldedText = @"p";
            break;
        case BBDKeyCodeA:
            yieldedText = @"a";
            break;
        case BBDKeyCodeS:
            yieldedText = @"s";
            break;
        case BBDKeyCodeD:
            yieldedText = @"d";
            break;
        case BBDKeyCodeF:
            yieldedText = @"f";
            break;
        case BBDKeyCodeG:
            yieldedText = @"g";
            break;
        case BBDKeyCodeH:
            yieldedText = @"h";
            break;
        case BBDKeyCodeJ:
            yieldedText = @"j";
            break;
        case BBDKeyCodeK:
            yieldedText = @"k";
            break;
        case BBDKeyCodeL:
            yieldedText = @"l";
            break;
            break;
        case BBDKeyCodeZ:
            yieldedText = @"z";
            break;
        case BBDKeyCodeX:
            yieldedText = @"x";
            break;
        case BBDKeyCodeC:
            yieldedText = @"c";
            break;
        case BBDKeyCodeV:
            yieldedText = @"v";
            break;
        case BBDKeyCodeB:
            yieldedText = @"b";
            break;
        case BBDKeyCodeN:
            yieldedText = @"n";
            break;
        case BBDKeyCodeM:
            yieldedText = @"m";
            break;
        case BBDKeyCodeSpace:
            yieldedText = @" ";
            break;
        case BBDKeyCodeReturn:
            yieldedText = @"\n";
            break;
        case BBDKeyCode1:
            yieldedText = @"1";
            break;
        case BBDKeyCode2:
            yieldedText = @"2";
            break;
        case BBDKeyCode3:
            yieldedText = @"3";
            break;
        case BBDKeyCode4:
            yieldedText = @"4";
            break;
        case BBDKeyCode5:
            yieldedText = @"5";
            break;
        case BBDKeyCode6:
            yieldedText = @"6";
            break;
        case BBDKeyCode7:
            yieldedText = @"7";
            break;
        case BBDKeyCode8:
            yieldedText = @"8";
            break;
        case BBDKeyCode9:
            yieldedText = @"9";
            break;
        case BBDKeyCode0:
            yieldedText = @"0";
            break;
        case BBDKeyCodeDash:
            yieldedText = @"-";
            break;
        case BBDKeyCodeForwardSlash:
            yieldedText = @"/";
            break;
        case BBDKeyCodeColon:
            yieldedText = @":";
            break;
        case BBDKeyCodeSemicolon:
            yieldedText = @";";
            break;
        case BBDKeyCodeOpenParenthesis:
            yieldedText = @"(";
            break;
        case BBDKeyCodeCloseParenthesis:
            yieldedText = @")";
            break;
        case BBDKeyCodeDollar:
            yieldedText = @"$";
            break;
        case BBDKeyCodeAmersand:
            yieldedText = @"&";
            break;
        case BBDKeyCodeAt:
            yieldedText = @"@";
            break;
        case BBDKeyCodeDoubleQuote:
            yieldedText = @"\"";
            break;
        case BBDKeyCodePeriod:
            yieldedText = @".";
            break;
        case BBDKeyCodeComma:
            yieldedText = @",";
            break;
        case BBDKeyCodeQuestionMark:
            yieldedText = @"?";
            break;
        case BBDKeyCodeExclamationMark:
            yieldedText = @"!";
            break;
        case BBDKeyCodeSingleQuote:
            yieldedText = @"'";
            break;
        case BBDKeyCodeOpenSquareBracket:
            yieldedText = @"[";
            break;
        case BBDKeyCodeCloseSquareBracket:
            yieldedText = @"]";
            break;
        case BBDKeyCodeOpenCurlyBracket:
            yieldedText = @"{";
            break;
        case BBDKeyCodeCloseCurlyBracket:
            yieldedText = @"}";
            break;
        case BBDKeyCodePoundSign:
            yieldedText = @"#";
            break;
        case BBDKeyCodePercent:
            yieldedText = @"%";
            break;
        case BBDKeyCodeCaret:
            yieldedText = @"^";
            break;
        case BBDKeyCodeAsterisk:
            yieldedText = @"*";
            break;
        case BBDKeyCodePlus:
            yieldedText = @"+";
            break;
        case BBDKeyCodeEqual:
            yieldedText = @"=";
            break;
        case BBDKeyCodeUnderscore:
            yieldedText = @"_";
            break;
        case BBDKeyCodeBackSlash:
            yieldedText = @"\\";
            break;
        case BBDKeyCodeVerticalBar:
            yieldedText = @"|";
            break;
        case BBDKeyCodeTilde:
            yieldedText = @"~";
            break;
        case BBDKeyCodeLessThan:
            yieldedText = @"<";
            break;
        case BBDKeyCodeGreaterThan:
            yieldedText = @">";
            break;
        case BBDKeyCodeEuro:
            yieldedText = @"€";
            break;
        case BBDKeyCodePound:
            yieldedText = @"£";
            break;
        case BBDKeyCodeYen:
            yieldedText = @"¥";
            break;
        case BBDKeyCodeBullet:
            yieldedText = @"•";
            break;
        default:
            break;
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
        [mutableIndexSet addIndexesInRange:(NSRange){BBDKeyCodeQ, BBDKeyCodeL - BBDKeyCodeQ + 1}];
        [mutableIndexSet addIndexesInRange:(NSRange){BBDKeyCodeZ, BBDKeyCodeM - BBDKeyCodeZ + 1}];
        [mutableIndexSet addIndex:BBDKeyCodeReturn];
        //second pane
        [mutableIndexSet addIndexesInRange:(NSRange){BBDKeyCode1, BBDKeyCodeDoubleQuote - BBDKeyCode1 + 1}];
        [mutableIndexSet addIndexesInRange:(NSRange){BBDKeyCodePeriod, BBDKeyCodeSingleQuote - BBDKeyCodePeriod + 1}];
        //third pane
        [mutableIndexSet addIndexesInRange:(NSRange){BBDKeyCodeOpenSquareBracket, BBDKeyCodeBullet - BBDKeyCodeOpenSquareBracket + 1}];
        
        _simpleTextGeneratingKeyCodeIndexSet = mutableIndexSet;
    });
    
    return _simpleTextGeneratingKeyCodeIndexSet;
}

@end

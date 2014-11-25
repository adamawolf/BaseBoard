//
//  KeyController.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/18/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyController.h"

@implementation KeyController

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
        case KeyCodeShift:
            symbol = @"^";
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
            symbol = @"RET";
            break;
        //TODO: add keys from second two panes
        default:
            break;
    }

    return symbol;
}

+ (NSString *)yieldedLowercaseTextForKeyCode:(KeyCode)keyCode
{
    NSString *yieldedText = nil;
    
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
        //TODO: add keys from second two panes
        default:
            break;
    }
    
    return yieldedText;
}

+ (NSIndexSet *)textGeneratingKeyCodeIndexSet
{
    static NSIndexSet *_textGeneratingKeyCodeIndexSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
        
        //effecient, but depends on ENUM order in .h
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodeQ, KeyCodeL - KeyCodeQ + 1}];
        [mutableIndexSet addIndexesInRange:(NSRange){KeyCodeZ, KeyCodeM - KeyCodeZ + 1}];
        [mutableIndexSet addIndex:KeyCodeSpace];
        [mutableIndexSet addIndex:KeyCodeReturn];
        
        _textGeneratingKeyCodeIndexSet = mutableIndexSet;
    });
    
    return _textGeneratingKeyCodeIndexSet;
}

@end

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
        default:
            break;
    }

    return symbol;
}

@end

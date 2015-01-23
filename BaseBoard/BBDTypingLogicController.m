//
//  TypingLogicController.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/25/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDTypingLogicController.h"

static const NSTimeInterval kMaxDoubleTapInterval = 0.3f;
static NSString *const kEnglishISO639dashOneCode = @"en";

@interface BBDTypingLogicController ()

@property NSDate *lastShiftPressDate;
@property NSDate *lastSpacePressDate;

@property (nonatomic, weak) id<BBDTypingLogicControllerDelegate> delegate;
@property (nonatomic, readonly) NSObject <UITextDocumentProxy> *textDocumentProxy;

@end

@implementation BBDTypingLogicController

- (instancetype)initWithDelegate:(id<BBDTypingLogicControllerDelegate>)delegate
            andTextDocumentProxy:(NSObject <UITextDocumentProxy> *)textDocumentProxy
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _textDocumentProxy = textDocumentProxy;
        
        _shiftKeyState = BBDShiftKeyStateUnknown;
        
        _lastShiftPressDate = [NSDate distantPast];
        _lastSpacePressDate = [NSDate distantPast];
    }
    
    return self;
}

#pragma mark - Custom Setter methods

- (void)setShiftKeyState:(BBDShiftKeyState)shiftKeyState
{
    BBDShiftKeyState initialShiftKeyState = _shiftKeyState;
    
    _shiftKeyState = shiftKeyState;
    
    if (_shiftKeyState != initialShiftKeyState) {
        [self.delegate typingLogicController:self determinedShouldSetShiftKeyState:_shiftKeyState];
    }
}

#pragma mark - Public Interface methods

- (void)determineShiftKeyState
{
    if (self.shiftKeyState == BBDShiftKeyStateCapsLock) {
        return;
    }
    
    BBDShiftKeyState determinedState = BBDShiftKeyStateLowercase;
    
    if (self.textDocumentProxy.autocapitalizationType == UITextAutocapitalizationTypeSentences) {
        NSString *beforeText = self.textDocumentProxy.documentContextBeforeInput;
        NSString *afterText = self.textDocumentProxy.documentContextAfterInput;
        
        if (afterText.length == 0) {
            if (beforeText.length == 0) {
                determinedState = BBDShiftKeyStateUppercase;
            } else if (beforeText.length == 1) {
                NSString *lastCharacter = [beforeText substringFromIndex:beforeText.length - 1];
                if ([lastCharacter isEqualToString:@"\n"]) {
                    //typed text ends in a carriage return
                    //NOTE: we get into this case (beforeText.length == 1) when the user types two subsequent \n
                    determinedState = BBDShiftKeyStateUppercase;
                }
            } else if (beforeText.length >= 2) {
                NSString *lastCharacter = [beforeText substringFromIndex:beforeText.length - 1];
                NSString *secondToLastCharacter = [beforeText substringWithRange:(NSRange){beforeText.length - 2, 1}];
                
                if ([lastCharacter isEqualToString:@"\n"]) {
                    //typed text ends in a carriage return
                    determinedState = BBDShiftKeyStateUppercase;
                } else if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
                    if ([secondToLastCharacter rangeOfCharacterFromSet:[BBDTypingLogicController sentenceEndingCharacterSet]].location != NSNotFound) {
                        //typed text ends in a space preceded by a sentence ending chracter
                        determinedState = BBDShiftKeyStateUppercase;
                    } else if (beforeText.length >= 3) {
                        NSString *thirdToLastCharacter = [beforeText substringWithRange:(NSRange){beforeText.length - 3, 1}];
                        
                        if ([secondToLastCharacter rangeOfCharacterFromSet:[BBDTypingLogicController potentiallySentenceEndingCharacterSet]].location != NSNotFound &&
                            [thirdToLastCharacter rangeOfCharacterFromSet:[BBDTypingLogicController sentenceEndingCharacterSet]].location != NSNotFound ) {
                            determinedState = BBDShiftKeyStateUppercase;
                        }
                    }
                }
            }
        }
    } else if (self.textDocumentProxy.autocapitalizationType == UITextAutocapitalizationTypeAllCharacters) {
        determinedState = BBDShiftKeyStateUppercase;
    } else if (self.textDocumentProxy.autocapitalizationType == UITextAutocapitalizationTypeWords) {
        NSString *beforeText = self.textDocumentProxy.documentContextBeforeInput;
        
        if (beforeText.length == 0) {
            determinedState = BBDShiftKeyStateUppercase;
        } else {
            NSString *lastCharacter = [beforeText substringFromIndex:beforeText.length - 1];
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
                determinedState = BBDShiftKeyStateUppercase;
            }
        }
    }
    
    [self setShiftKeyState:determinedState];
}

- (void)processKeystrokeWithKeyCode:(NSUInteger)keyCode
{
    if ([[BBDKeyController simpleTextGeneratingKeyCodeIndexSet] containsIndex:keyCode]) {
        NSString *yieldedText = [BBDKeyController yieldedLowercaseTextForKeyCode:keyCode];
        BOOL isUpperCase = self.shiftKeyState == BBDShiftKeyStateUppercase || self.shiftKeyState == BBDShiftKeyStateCapsLock;
        if (isUpperCase) {
            yieldedText = [yieldedText uppercaseString];
        }
        [self.delegate typingLogicController:self determinedShouldInsertText:yieldedText];
    } else if (keyCode == BBDKeyCodeSpace) {
        //get last word typed before this space it be inserted
        NSString *beforeText = self.textDocumentProxy.documentContextBeforeInput;
        NSArray *words = [beforeText componentsSeparatedByString:@" "];
        NSString *lastWord = [words lastObject];
        
        if (lastWord) {
            UITextChecker *aTextCheckter = [[UITextChecker alloc] init];
            
            NSLog(@"last word to check: '%@'", lastWord);
            
            //check for mispelling
            NSString *paddedLastWord = [NSString stringWithFormat:@" %@ ", lastWord];
            NSRange misspellingRange = [aTextCheckter rangeOfMisspelledWordInString:paddedLastWord range:(NSRange){0, paddedLastWord.length} startingAt:0 wrap:YES language:kEnglishISO639dashOneCode];
            
            BOOL isMisspelling = misspellingRange.location != NSNotFound;
            
            if (isMisspelling) {
                NSLog(@"is misspelling: %@", isMisspelling ? @"YES" : @"NO");
                
                //check for completions and corrections
                NSArray *guesses = [aTextCheckter guessesForWordRange:(NSRange){0,lastWord.length} inString:lastWord language:kEnglishISO639dashOneCode];
                NSLog(@"guesses: %@", guesses);
                
                NSString *correction = [guesses firstObject];
                if (correction) {
                    //delete chracters of last word
                    for (int i = 0; i < lastWord.length; i++) {
                        [self.delegate typingLogicControllerDeterminedShouldDeleteBackwards:self];
                    }
                    //insert correction
                    [self.delegate typingLogicController:self determinedShouldInsertText:correction];
                }
            }
            
            NSLog(@"\n");
        }
        
        //check for double tap space shortcur
        NSDate *spacePressDate = [NSDate date];
        NSTimeInterval timeSinceLastSpacePress = [spacePressDate timeIntervalSinceDate:self.lastSpacePressDate];
        
        if (timeSinceLastSpacePress < kMaxDoubleTapInterval) {
            [self.delegate typingLogicControllerDeterminedShouldDeleteBackwards:self];
            [self.delegate typingLogicController:self determinedShouldInsertText:@". "];
        } else {
            [self.delegate typingLogicController:self determinedShouldInsertText:@" "];
        }
        //no matter what pane we're on, tapping space takes us back to primary
        [self.delegate typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:self];
        
        self.lastSpacePressDate = spacePressDate;
    } else if (keyCode == BBDKeyCodeDelete) {
        [self.delegate typingLogicControllerDeterminedShouldDeleteBackwards:self];
    } else if (keyCode == BBDKeyCodeNextKeyboard) {
        [self.delegate typingLogicControllerDeterminedShouldAdvanceToNextKeyboard:self];
    } else if (keyCode == BBDKeyCodeShift || keyCode == BBDKeyCodeSecondShift) {
        NSDate *shiftPressDate = [NSDate date];
        
        NSTimeInterval timeSinceLastShiftPress = [shiftPressDate timeIntervalSinceDate:self.lastShiftPressDate];
        if (timeSinceLastShiftPress < kMaxDoubleTapInterval) {
            [self setShiftKeyState:BBDShiftKeyStateCapsLock];
        } else {
            BOOL isLowercase = self.shiftKeyState == BBDShiftKeyStateLowercase || self.shiftKeyState == BBDShiftKeyStateUnknown;
            if (isLowercase) {
                [self setShiftKeyState:BBDShiftKeyStateUppercase];
            } else {
                [self setShiftKeyState:BBDShiftKeyStateLowercase];
            }
        }
        
        self.lastShiftPressDate = shiftPressDate;
    } else if (keyCode == BBDKeyCodeNumberPane || keyCode == BBDKeyCodeSecondNumberPane || keyCode == BBDKeyCodeThirdRowNumberPane) {
        [self.delegate typingLogicControllerDeterminedShouldSwitchToNumericAndSymbolsKeyPane:self];
    } else if (keyCode == BBDKeyCodePrimaryKeyPane) {
        [self.delegate typingLogicControllerDeterminedShouldSwitchToPrimaryKeyPane:self];
    } else if (keyCode == BBDKeyCodeSymbolsPane) {
        [self.delegate typingLogicControllerDeterminedShouldSwitchToSupplemtalSymbolsKeyPane:self];
    }
}

#pragma mark - Static Reference methods

+ (NSCharacterSet *)sentenceEndingCharacterSet
{
    static NSCharacterSet *_sentenceEndingCharacterSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sentenceEndingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".!?"];
    });
    
    return _sentenceEndingCharacterSet;
}

//characters that COULD be sentence ending, if they are preceded by a sentence ending character set
//i.e. the single and double quotes in the two character strings: ." and .'
+ (NSCharacterSet *)potentiallySentenceEndingCharacterSet
{
    static NSCharacterSet *_potentiallySentenceEndingCharacterSet = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _potentiallySentenceEndingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\"\'"];
    });
    
    return _potentiallySentenceEndingCharacterSet;
}

@end

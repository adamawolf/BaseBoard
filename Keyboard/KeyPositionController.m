//
//  KeyPositionController.m
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/17/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import "KeyPositionController.h"

@interface KeyPositionController ()

@property (nonatomic, strong) NSMutableDictionary *keyDictionariesKeyedByKeyCode;

@end

@implementation KeyPositionController

- (void)reloadKeyPositions
{
    self.keyDictionariesKeyedByKeyCode = nil;
    
    CGSize keyboardSize = [self.dataSource keyboardSize];
    if (CGSizeEqualToSize(keyboardSize, CGSizeZero)) {
        return;
    }
    
    self.keyDictionariesKeyedByKeyCode = [NSMutableDictionary new];
    
    NSInteger numRows = [self.dataSource numberOfRows];
    
    CGFloat intraRowSpacing = [self.dataSource minimumIntraRowSpacing];
    CGFloat availableHeightForRows = keyboardSize.height - ((numRows + 1) * intraRowSpacing);
    CGFloat exactHeightPerRow = availableHeightForRows / numRows;
    CGFloat heightPerRow = floorf(exactHeightPerRow);
    
    //TODO: calculate surplus extra pixels to allocate to rows as needed
    
    for (NSInteger currentRow = 0; currentRow < numRows; currentRow++) {
        CGFloat rowYPos = intraRowSpacing + ((currentRow * heightPerRow) + (currentRow * intraRowSpacing));
        
        NSMutableArray *keysInRow = [NSMutableArray new];
        
        NSInteger numKeysInRow = [self.dataSource numberOfKeysForRow:currentRow];
        NSInteger totalStride = 0;
        for (NSInteger currentKeyPosition = 0; currentKeyPosition < numKeysInRow; currentKeyPosition++) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForKeyPosition:currentKeyPosition inKeyRow:currentRow];
            
            NSMutableDictionary *keyDictionary = [NSMutableDictionary new];
            keyDictionary[@"keyCode"] = @([self.dataSource symbolForKeyAtIndexPath:currentIndexPath]);
            keyDictionary[@"stride"] = @([self.dataSource strideForKeyAtIndexPath:currentIndexPath]);
            
            totalStride += [keyDictionary[@"stride"] integerValue];
            
            [keysInRow addObject:keyDictionary];
        }
        
        CGFloat intraKeySpacing = [self.dataSource minimumIntraKeySpacingForRow:currentRow];
        
        CGFloat availableWidthForKeys = keyboardSize.width - ((totalStride + 1) * intraKeySpacing);
        CGFloat exactWidthPerStride = availableWidthForKeys / totalStride;
        CGFloat widthPerStride = floorf(exactWidthPerStride);
        
        //TODO: calculate surplus extra pixels to allocate to the keys as needed
        
        __block CGFloat currentXPos = intraKeySpacing; //starting left spacing
        [keysInRow enumerateObjectsUsingBlock:^(NSMutableDictionary *keyDictionary, NSUInteger currentKeyPosition, BOOL *stop) {
            NSInteger keyStride = [keyDictionary[@"stride"] integerValue];
            CGFloat keyWidth = widthPerStride * keyStride + (intraKeySpacing * (keyStride - 1));
            
            keyDictionary[@"frame"] = [NSValue valueWithCGRect:CGRectMake(currentXPos, rowYPos, keyWidth, heightPerRow)];
            currentXPos += keyWidth + intraKeySpacing;
            
            self.keyDictionariesKeyedByKeyCode[keyDictionary[@"keyCode"]] = keyDictionary;
        }];
    }
}

- (NSDictionary *)keyDictionaryForKeyCode:(KeyCode)keyCode
{
    if (!self.keyDictionariesKeyedByKeyCode) {
        [self reloadKeyPositions];
    }
    
    return self.keyDictionariesKeyedByKeyCode[@(keyCode)];
}

@end


@implementation NSIndexPath (KeyPositionControllerAdditions)

+ (NSIndexPath *)indexPathForKeyPosition:(NSInteger)keyPosition inKeyRow:(NSInteger)keyRow
{
    NSUInteger indexArr[] = {keyPosition, keyRow};
    
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArr length:2];
    
    return indexPath;
}

- (NSInteger)keyPosition
{
    return [self indexAtPosition:0];
}

- (NSInteger)keyRow
{
    return [self indexAtPosition:1];
}

@end
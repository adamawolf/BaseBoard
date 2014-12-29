//
//  BBDKeyPositionController.m
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/17/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "BBDKeyPositionController.h"

@interface BBDKeyPositionController ()

@property (nonatomic, strong) NSMutableDictionary *keyDictionariesKeyedByKeyCode;

@end

@implementation BBDKeyPositionController

- (void)reloadKeyPositions
{
    self.keyDictionariesKeyedByKeyCode = nil;
    
    CGSize keyboardSize = [self.dataSource keyboardSize];
    if (CGSizeEqualToSize(keyboardSize, CGSizeZero)) {
        return;
    }
    
    self.keyDictionariesKeyedByKeyCode = [NSMutableDictionary new];
    
    NSInteger numRows = [self.dataSource numberOfRows];
    
    //calculate height per row, which is totalHeight sans space needed for row margins
    CGFloat totalRowVerticalMargins = 0.0f;
    for (int rowIndex = 0; rowIndex < numRows; rowIndex++) {
        NSInteger numKeysInRow = [self.dataSource numberOfKeysForRow:rowIndex];
        
        //build up data structure representing data for each key in this row
        CGFloat largestTopMargin = 0.0f;
        CGFloat largestBottomMargin = 0.0f;
        for (int keyIndex = 0; keyIndex < numKeysInRow; keyIndex++) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForKeyPosition:keyIndex inKeyRow:rowIndex];
            NSValue *marginsValue = [self.dataSource marginsForKeyAtIndexPath:currentIndexPath];
            if (marginsValue) {
                UIEdgeInsets currentMargins = [marginsValue UIEdgeInsetsValue];
                
                largestTopMargin = MAX(largestTopMargin, currentMargins.top);
                largestBottomMargin = MAX(largestBottomMargin, currentMargins.bottom);
            }
        }
        
        totalRowVerticalMargins += (largestTopMargin + largestBottomMargin);
    }
    
    CGFloat availableHeight = keyboardSize.height - totalRowVerticalMargins;
    
    CGFloat heightPerRow = floorf(availableHeight / numRows);
    
    CGFloat runningY = 0.0f;
    for (int rowIndex = 0; rowIndex < numRows; rowIndex++) {
        NSInteger numKeysInRow = [self.dataSource numberOfKeysForRow:rowIndex];
        
        //build up data structure representing data for each key in this row
        //calculate the largest top and bottom margin values for any key in this row
        CGFloat largestTopMargin = 0.0f;
        CGFloat largestBottomMargin = 0.0f;
        NSMutableArray *keyDictionaries = [NSMutableArray new];
        for (int keyIndex = 0; keyIndex < numKeysInRow; keyIndex++) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForKeyPosition:keyIndex inKeyRow:rowIndex];
            
            NSMutableDictionary *keyDictionary = [NSMutableDictionary new];
            
            NSValue *marginsValue = [self.dataSource marginsForKeyAtIndexPath:currentIndexPath];
            if (marginsValue) {
                keyDictionary[@"margins"] = marginsValue;
                
                UIEdgeInsets currentMargins = [marginsValue UIEdgeInsetsValue];
                largestTopMargin = MAX(largestTopMargin, currentMargins.top);
                largestBottomMargin = MAX(largestBottomMargin, currentMargins.bottom);
            }
            
            NSNumber *relativeWidthNumber = [self.dataSource relativeWidthForKeyAtIndexPath:currentIndexPath];
            if (relativeWidthNumber) {
                keyDictionary[@"relativeWidth"] = relativeWidthNumber;
            }
            [keyDictionaries addObject:keyDictionary];
        }
        
        //adjust yPos to account for this row's effective top margin
        runningY += largestTopMargin;
        
        //calculate available width which relateiveWidth keys are relative to (total width sans space needed to satistfy margins)
        __block CGFloat totalRowHorizontalMargins = 0.0f;
        [keyDictionaries enumerateObjectsUsingBlock:^(NSDictionary *currentKeyDictionary, NSUInteger idx, BOOL *stop) {
            NSValue *marginsValue = currentKeyDictionary[@"margins"];
            if (marginsValue) {
                UIEdgeInsets margins = [marginsValue UIEdgeInsetsValue];
                totalRowHorizontalMargins += margins.left + margins.right;
            }
        }];
        __block CGFloat availableWidth = keyboardSize.width - totalRowHorizontalMargins;
        
        //asign widths to all relativePercent specified keys
        __block CGFloat widthAssignedToRelativeWidthKeys = 0.0f;
        [keyDictionaries enumerateObjectsUsingBlock:^(NSMutableDictionary *currentKeyDictionary, NSUInteger idx, BOOL *stop) {
            NSNumber *relativeWidthNumber = currentKeyDictionary[@"relativeWidth"];
            if (relativeWidthNumber) {
                CGFloat relativeWidth = [relativeWidthNumber floatValue];
                CGFloat width = floorf(relativeWidth * availableWidth);
                
                currentKeyDictionary[@"width"] = @(width);
                widthAssignedToRelativeWidthKeys += width;
            } else {
                currentKeyDictionary[@"width"] = @(0.0f);
            }
        }];
        
        //assign remaining width to all non-relativePercent specified keys evently
        CGFloat remainingWidthToAssign = availableWidth - widthAssignedToRelativeWidthKeys;
        int currentAssignmentIndex = 0;
        while (remainingWidthToAssign > 0.0f) {
            NSMutableDictionary *keyDictionary = keyDictionaries[currentAssignmentIndex];
            
            if (!keyDictionary[@"relativeWidth"]) {
                keyDictionary[@"width"] = @([keyDictionary[@"width"] floatValue] + 1.0f);
                remainingWidthToAssign -= 1.0f;
            }
            
            currentAssignmentIndex++;
            currentAssignmentIndex %= numKeysInRow;
        }
        
        //create and store result dictionary
        __block CGFloat runningX = 0.0f;
        [keyDictionaries enumerateObjectsUsingBlock:^(NSDictionary *currentKeyDictionary, NSUInteger keyIndex, BOOL *stop) {

            UIEdgeInsets margins = UIEdgeInsetsZero;
            NSValue *marginsValue = currentKeyDictionary[@"margins"];
            if (marginsValue) {
                margins = [marginsValue UIEdgeInsetsValue];
            }
            
            runningX += margins.left;
    
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForKeyPosition:keyIndex inKeyRow:rowIndex];
            NSNumber *keyCodeNumber = @([self.dataSource keyCodeForKeyAtIndexPath:currentIndexPath]);
            CGRect frame = CGRectMake(runningX, runningY, [currentKeyDictionary[@"width"] floatValue], heightPerRow);
            runningX += frame.size.width;
            
            self.keyDictionariesKeyedByKeyCode[keyCodeNumber] = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                                @"keyCode": keyCodeNumber,
                                                                                                                @"frame": [NSValue valueWithCGRect:frame],
                                                                                                                }];
            runningX += margins.right;
            
            NSValue *paddingsValue = [self.dataSource paddingsForKeyAtIndexPath:currentIndexPath];
            if (paddingsValue) {
                self.keyDictionariesKeyedByKeyCode[keyCodeNumber][@"paddings"] = paddingsValue;
            }
        }];
        
        runningY += heightPerRow;
        runningY += largestBottomMargin;
    }
}

- (NSDictionary *)keyDictionaryForKeyCode:(NSUInteger)keyCode
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
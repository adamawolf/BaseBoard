//
//  BBDKeyPositionController.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/17/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBDKeyController.h"

@protocol  BBDKeyPositionDataSource <NSObject>

- (CGSize)keyboardSize; //used to infer the key width and height

- (NSInteger)numberOfRows;

- (NSInteger)numberOfKeysForRow:(NSInteger)row;

- (NSNumber *)relativeWidthForKeyAtIndexPath:(NSIndexPath *)indexPath;  //relative to 1.0
- (NSValue *)marginsForKeyAtIndexPath:(NSIndexPath *)indexPath;         //px subtracted from total available
- (NSValue *)paddingsForKeyAtIndexPath:(NSIndexPath *)indexPath;       //internal to bounds of each key

- (BBDKeyCode)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBDKeyPositionController : NSObject

@property (nonatomic, weak) id<BBDKeyPositionDataSource>dataSource;

- (void)reloadKeyPositions;
- (NSDictionary *)keyDictionaryForKeyCode:(BBDKeyCode)keyCode;

@end

@interface NSIndexPath (KeyPositionControllerAdditions)

+ (NSIndexPath *)indexPathForKeyPosition:(NSInteger)keyPosition inKeyRow:(NSInteger)keyRow;

@property(nonatomic,readonly) NSInteger keyPosition;
@property(nonatomic,readonly) NSInteger keyRow;

@end

//
//  BBDKeyPositionController.h
//  BaseBoard
//
//  Created by Adam A. Wolf on 11/17/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//imn0tt3ll1ng

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBDKeyController.h"

@protocol BBDKeyPositionDataSource;

@interface BBDKeyPositionController : NSObject

@property (nonatomic, weak) id<BBDKeyPositionDataSource>dataSource;

- (void)reloadKeyPositions;
- (NSDictionary *)keyDictionaryForKeyCode:(BBDKeyCode)keyCode;

@end

@protocol BBDKeyPositionDataSource <NSObject>

//used to determine total available width
- (CGSize)keyboardSize;

- (NSInteger)numberOfRows;
- (NSInteger)numberOfKeysForRow:(NSInteger)row;

- (BBDKeyCode)keyCodeForKeyAtIndexPath:(NSIndexPath *)indexPath;

//a fraction between 0 and 1.0, 1.0 representing width remaining after subtracting margins
- (NSNumber *)relativeWidthForKeyAtIndexPath:(NSIndexPath *)indexPath;
//pixels subtracted from total available width
- (NSValue *)marginsForKeyAtIndexPath:(NSIndexPath *)indexPath;
//internal to bounds of each key. as such, doesn't affect a key's calculated frame
- (NSValue *)paddingsForKeyAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSIndexPath (KeyPositionControllerAdditions)

+ (NSIndexPath *)indexPathForKeyPosition:(NSInteger)keyPosition inKeyRow:(NSInteger)keyRow;

@property (nonatomic, readonly) NSInteger keyPosition;
@property (nonatomic, readonly) NSInteger keyRow;

@end

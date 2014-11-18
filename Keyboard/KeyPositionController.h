//
//  KeyPositionController.h
//  ExperimentalKeyboard
//
//  Created by Adam A. Wolf on 11/17/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol  KeyPositionDataSource <NSObject>

- (CGSize)keyboardSize;

- (NSInteger)numberOfRows;
- (CGFloat)minimumIntraRowSpacing;

- (NSInteger)numberOfKeysForRow:(NSInteger)row;
- (CGFloat)minimumIntraKeySpacingForRow:(NSInteger)row;

- (NSString *)symbolForKeyAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)strideForKeyAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface KeyPositionController : NSObject

@property (nonatomic, weak) id<KeyPositionDataSource>dataSource;

- (NSArray *)allKeyPositionRows;

@end

@interface NSIndexPath (KeyPositionControllerAdditions)

+ (NSIndexPath *)indexPathForKeyPosition:(NSInteger)keyPosition inKeyRow:(NSInteger)keyRow;

@property(nonatomic,readonly) NSInteger keyPosition;
@property(nonatomic,readonly) NSInteger keyRow;

@end

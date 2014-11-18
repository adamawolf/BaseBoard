//
//  KeyView.h
//  ExperimentalKeyboard
//
//  Created by Adam Wolf on 10/16/14.
//  Copyright (c) 2014 Flairify LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyView : UIView

@property (nonatomic, strong, readonly) NSString *symbol;

- (instancetype)initWithSymbol:(NSString *)symbol;

@end

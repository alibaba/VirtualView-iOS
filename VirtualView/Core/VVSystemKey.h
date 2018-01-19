//
//  VVSystemKey.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVSystemKey : NSObject

+ (VVSystemKey *)shareInstance __deprecated;

@property(nonatomic, readonly)NSArray* keyArray;
@property(nonatomic, readonly)NSDictionary* keyDictionary;

@property (nonatomic, assign) CGFloat rate __deprecated_msg("use VVConfig.pointRatio");

- (void)registerWidget:(NSString *)className withIndex:(short)index __deprecated_msg("use [VVNodeClassMapper registerClassName:forID:]");
- (NSString *)classNameForIndex:(short)index __deprecated_msg("use [VVNodeClassMapper classNameForID:]");

@end

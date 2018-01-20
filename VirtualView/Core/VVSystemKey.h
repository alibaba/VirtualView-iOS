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

+ (nonnull VVSystemKey *)shareInstance __deprecated;

//@property (nonatomic, strong, readonly, nonnull) NSDictionary *keyDictionary __deprecated_msg("use [VVBinaryStringMapper stringForKey:]");

@property (nonatomic, assign) CGFloat rate __deprecated_msg("use VVConfig.pointRatio");

//- (nullable NSString *)classNameForIndex:(short)index __deprecated_msg("use [VVNodeClassMapper classNameForID:]");
//- (void)registerWidget:(nonnull NSString *)className withIndex:(short)index __deprecated_msg("use [VVNodeClassMapper registerClassName:forID:]");

@end

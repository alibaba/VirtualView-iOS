//
//  VVPropertyExpressionSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"
#import "VVExpression.h"

@interface VVPropertyExpressionSetter : VVPropertySetter

@property (nonatomic, strong, readonly, nullable) VVExpression *expression;

/**
 Return an expression setter if the expression string is valid.

 @param key               Property key.
 @param expressionString  Expression string.
 @return                  An expression setter or nil.
 */
+ (nullable VVPropertySetter *)setterWithPropertyKey:(int)key expressionString:(nullable NSString *)expressionString;

@end

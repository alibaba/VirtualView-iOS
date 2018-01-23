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

@property (nonatomic, assign, readonly) int valueType;

/**
 Return an expression setter if the expression string is valid.
 Will return nil is expression string is a const expression.

 @param key               Property key.
 @param expressionString  Expression string.
 @return                  An expression setter or nil.
 */
+ (nullable VVPropertyExpressionSetter *)setterWithPropertyKey:(int)key expressionString:(nullable NSString *)expressionString;

@end

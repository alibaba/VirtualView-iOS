//
//  VVExpression.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVExpression : NSObject

/**
 Return an expression if the expression string is valid.
 If you want to use this method of subclasses directly, please trim the string at first.

 @param string  Expression string
 @return        An expression or nil.
 */
+ (nullable VVExpression *)expressionWithString:(nonnull NSString *)string;

- (nullable NSString *)valueWithDict:(nullable NSDictionary *)dict;

@end

@interface VVConstExpression : VVExpression

@end

@interface VVVariableExpression : VVExpression

@end

@interface VVIifExpression : VVExpression

@end

//
//  VVExpression.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVExpression.h"

@implementation VVExpression

+ (VVExpression *)expressionWithString:(NSString *)string
{
    VVExpression *expression = nil;
    if (string && string.length > 0) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (string.length > 0) {
            if ([string hasPrefix:@"@{"]) {
                expression = [VVIifExpression expressionWithString:string];
            } else if ([string hasPrefix:@"${"]) {
                expression = [VVVariableExpression expressionWithString:string];
            }
        }
    }
    if (!expression) {
        expression = [VVConstExpression expressionWithString:string];
    }
    return expression;
}

- (NSString *)valueWithDict:(NSDictionary *)dict
{
    // override me
    return nil;
}

@end

//################################################################
#pragma mark -

@interface VVConstExpression ()

@property (nonatomic, copy) NSString *value;

@end

@implementation VVConstExpression

+ (VVExpression *)expressionWithString:(NSString *)string
{
    VVConstExpression *expression = [VVConstExpression new];
    expression.value = string;
    return expression;
}

- (NSString *)valueWithDict:(NSDictionary *)dict
{
    return self.value;
}

@end

//################################################################
#pragma mark -

@interface VVVariableExpression ()

@end

@implementation VVVariableExpression

@end

//################################################################
#pragma mark -

@interface VVIifExpression ()

@property (nonatomic, strong) VVExpression *conditionExpression;
@property (nonatomic, strong) VVExpression *trueExpression;
@property (nonatomic, strong) VVExpression *falseExpression;

@end

@implementation VVIifExpression

+ (VVExpression *)expressionWithString:(NSString *)string
{
    VVIifExpression *expression = nil;
    if ([string hasPrefix:@"@{"]) {
        
    }
    return expression;
}

- (NSString *)valueWithDict:(NSDictionary *)dict
{
    NSString *conditionValue = [self.conditionExpression valueWithDict:dict];
    if (conditionValue && conditionValue.length > 0 && [conditionValue isEqualToString:@"false"] == NO) {
        return [self.trueExpression valueWithDict:dict];
    } else {
        return [self.falseExpression valueWithDict:dict];
    }
}

@end

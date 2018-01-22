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
        if (string.length > 3) {
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

- (id)resultWithObject:(id)object
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

- (id)resultWithObject:(id)object
{
    return self.value;
}

@end

//################################################################
#pragma mark -

@interface VVVariableExpression ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) VVExpression *nextExpression;

@end

@implementation VVVariableExpression

+ (VVExpression *)expressionWithString:(NSString *)string
{
    VVVariableExpression *expression = nil;
    if ([string hasPrefix:@"${"] && [string hasSuffix:@"}"]) {
        string = [string substringWithRange:NSMakeRange(2, string.length - 3)];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (string.length > 0) {
            if (![string hasPrefix:@"["]) {
                string = [@"." stringByAppendingString:string];
            }
            expression = [self private_ExpressionWithString:string];
        }
    }
    return expression;
}

+ (VVVariableExpression *)private_ExpressionWithString:(NSString *)string
{
    static NSCharacterSet *nextCharacterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nextCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"[."];
    });
    VVVariableExpression *expression = nil;
    if ([string hasPrefix:@"["]) {
        NSRange range = [string rangeOfString:@"]"];
        if (range.location != NSNotFound) {
            NSString *indexString = [string substringWithRange:NSMakeRange(1, range.location - 1)];
            expression = [VVVariableExpression new];
            expression.index = [indexString integerValue];
            string = [string substringFromIndex:range.location + 1];
        } else {
            string = nil;
        }
    } else if ([string hasPrefix:@"."]) {
        NSRange range = [string rangeOfCharacterFromSet:nextCharacterSet options:0 range:NSMakeRange(1, string.length - 1)];
        if (range.location != NSNotFound) {
            NSString *key = [string substringWithRange:NSMakeRange(1, range.location - 1)];
            expression = [VVVariableExpression new];
            expression.key = key;
            string = [string substringFromIndex:range.location];
        } else {
            expression = [VVVariableExpression new];
            expression.key = [string substringFromIndex:1];
            string = nil;
        }
    }
    if (expression && string && string.length > 0) {
        expression.nextExpression = [self private_ExpressionWithString:string];
    }
    return expression;
}

- (instancetype)init
{
    if (self = [super init]) {
        _index = -1;
    }
    return self;
}

- (id)resultWithObject:(id)object
{
    if (object) {
        id nextObject = nil;
        if (self.index >= 0 && [object isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)object;
            if (self.index < array.count) {
                nextObject = [array objectAtIndex:self.index];
            }
        } else if (self.key && self.key.length > 0 && [object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict =(NSDictionary *)object;
            nextObject = [dict objectForKey:self.key];
        }
        if (self.nextExpression) {
            return [self.nextExpression resultWithObject:nextObject];
        } else {
            return nextObject;
        }
    }
    return nil;
}

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
    if ([string hasPrefix:@"@{"] && [string hasSuffix:@"}"]) {
        string = [string substringWithRange:NSMakeRange(2, string.length - 3)];
        NSRange range1 = [string rangeOfString:@"?"];
        NSRange range2 = [string rangeOfString:@":"];
        if (range1.location != NSNotFound && range2.location != NSNotFound && range2.location > range1.location) {
            NSString *conditionString = [string substringToIndex:range1.location];
            NSString *trueString = [string substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
            NSString *falseString = [string substringFromIndex:range2.location + 1];
            VVExpression *conditionExpression = [VVExpression expressionWithString:conditionString];
            VVExpression *trueExpression = [VVExpression expressionWithString:trueString];
            VVExpression *falseExpression = [VVExpression expressionWithString:falseString];
            if (conditionExpression && trueExpression && falseExpression) {
                expression = [VVIifExpression new];
                expression.conditionExpression = conditionExpression;
                expression.trueExpression = trueExpression;
                expression.falseExpression = falseExpression;
            }
        }
    }
    return expression;
}

- (id)resultWithObject:(id)object
{
    if (object && ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])) {
        id conditionObject = [self.conditionExpression resultWithObject:object];
        if (conditionObject) {
            if ([conditionObject isKindOfClass:[NSString class]]
                && [(NSString *)conditionObject length] > 0
                && [(NSString *)conditionObject isEqualToString:@"false"]) {
                return [self.falseExpression resultWithObject:object];
            } else {
                return [self.trueExpression resultWithObject:object];
            }
        } else {
            return [self.falseExpression resultWithObject:object];
        }
    }
    return nil;
}

@end

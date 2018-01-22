//
//  VVPropertyExpressionSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyExpressionSetter.h"

@interface VVPropertyExpressionSetter ()

@property (nonatomic, strong, readwrite) VVExpression *expression;

@end

@implementation VVPropertyExpressionSetter

+ (VVPropertySetter *)setterWithPropertyKey:(int)key expressionString:(NSString *)expressionString
{
    if (expressionString && expressionString.length > 0) {
        expressionString = [expressionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (expressionString.length > 0 && ([expressionString hasPrefix:@"@{"] || [expressionString hasPrefix:@"${"])) {
            VVExpression *expression = [VVExpression expressionWithString:expressionString];
            if (expression && [expression isKindOfClass:[VVConstExpression class]] == NO) {
                VVPropertyExpressionSetter *setter = [[self alloc] initWithPropertyKey:key];
                setter.expression = expression;
                return setter;
            }
        }
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@; expression = %@>", self.class, self, self.name, self.expression];
}

- (BOOL)isExpression
{
    return YES;
}

- (void)applyToNode:(VVBaseNode *)node withDict:(NSDictionary *)dict
{
    if (self.expression) {
        NSString *value = [self.expression resultWithObject:dict];
        [node setStringValue:value forKey:self.key];
    } else {
        [node setStringValue:nil forKey:self.key];
    }
}

@end

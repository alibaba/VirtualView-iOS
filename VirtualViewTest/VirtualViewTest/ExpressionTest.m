//
//  ExpressionTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/VVExpression.h>

@interface VVVariableExpression ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) VVExpression *nextExpression;

@end

//################################################################
#pragma mark -

@interface VVIifExpression ()

@property (nonatomic, strong) VVExpression *conditionExpression;
@property (nonatomic, strong) VVExpression *trueExpression;
@property (nonatomic, strong) VVExpression *falseExpression;

@end

//################################################################
#pragma mark -

@interface ExpressionTest : XCTestCase

@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, strong) NSDictionary *testDict;
@property (nonatomic, strong) NSDictionary *testDataDict;

@end

@implementation ExpressionTest

- (void)setUp {
    [super setUp];
    self.testArray = @[@"123", @"456"];
    self.testDict = @{@"a" : @"123"};
    self.testDataDict = @{
        @"a" : @[@"123", @"456"],
        @"b" : @"true",
        @"c" : @"false"
    };
}

- (void)tearDown {
    [super tearDown];
}

- (void)testConstExpression {
    assertThat([VVExpression expressionWithString:@"@{aaa"], isA([VVConstExpression class]));
    assertThat([VVExpression expressionWithString:@"${aaa"], isA([VVConstExpression class]));
    assertThat([VVExpression expressionWithString:@"{aaa}"], isA([VVConstExpression class]));

    VVConstExpression *expression = (id)[VVExpression expressionWithString:@"123"];
    assertThat(expression, isA([VVConstExpression class]));
    assertThat([expression resultWithObject:nil], equalTo(@"123"));
    assertThat([expression resultWithObject:@{}], equalTo(@"123"));
    assertThat([expression resultWithObject:@[]], equalTo(@"123"));
}

- (void)testVariableExpression {
    VVVariableExpression *expression = (id)[VVExpression expressionWithString:@"${a}"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(-1));
    assertThat(expression.key, equalTo(@"a"));
    assertThat(expression.nextExpression, nilValue());
    assertThat([expression resultWithObject:nil], nilValue());
    assertThat([expression resultWithObject:self.testArray], nilValue());
    assertThat([expression resultWithObject:self.testDict], equalTo(@"123"));
    NSArray *result = [expression resultWithObject:self.testDataDict];
    assertThatBool([result isKindOfClass:[NSArray class]], isTrue());
    assertThat(result, hasCountOf(2));
    assertThat(result, containsInAnyOrderIn(@[@"123", @"456"]));

    expression = (id)[VVExpression expressionWithString:@"${ a }"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThat(expression.key, equalTo(@"a"));
    
    expression = (id)[VVExpression expressionWithString:@"${[1]}"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(1));
    assertThat(expression.key, nilValue());
    assertThat(expression.nextExpression, nilValue());
    assertThat([expression resultWithObject:nil], nilValue());
    assertThat([expression resultWithObject:self.testArray], equalTo(@"456"));
    assertThat([expression resultWithObject:self.testDict], nilValue());
    assertThat([expression resultWithObject:self.testDataDict], nilValue());
    
    expression = (id)[VVExpression expressionWithString:@"${a[1].b.c[2][3].d}"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(-1));
    assertThat(expression.key, equalTo(@"a"));
    expression = (id)expression.nextExpression;
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(1));
    assertThat(expression.key, nilValue());
    expression = (id)expression.nextExpression;
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(-1));
    assertThat(expression.key, equalTo(@"b"));
    expression = (id)expression.nextExpression;
    assertThat(expression.key, equalTo(@"c"));
    expression = (id)expression.nextExpression;
    assertThatInteger(expression.index, equalToInteger(2));
    expression = (id)expression.nextExpression;
    assertThatInteger(expression.index, equalToInteger(3));
    expression = (id)expression.nextExpression;
    assertThat(expression.key, equalTo(@"d"));
    
    expression = (id)[VVExpression expressionWithString:@"${a[1]}"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThat([expression resultWithObject:nil], nilValue());
    assertThat([expression resultWithObject:self.testArray], nilValue());
    assertThat([expression resultWithObject:self.testDict], nilValue());
    assertThat([expression resultWithObject:self.testDataDict], equalTo(@"456"));
    
    // missing "]"
    expression = (id)[VVExpression expressionWithString:@"${a[1}"];
    assertThat(expression, isA([VVVariableExpression class]));
    assertThatInteger(expression.index, equalToInteger(-1));
    assertThat(expression.key, equalTo(@"a"));
    assertThat(expression.nextExpression, nilValue());
}

- (void)testIifExpression {
    VVIifExpression *expression = (id)[VVExpression expressionWithString:@"@{1?2:3}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVConstExpression class]));
    assertThat(expression.trueExpression, isA([VVConstExpression class]));
    assertThat(expression.falseExpression, isA([VVConstExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{${a}?2:3}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVVariableExpression class]));
    assertThat(expression.trueExpression, isA([VVConstExpression class]));
    assertThat(expression.falseExpression, isA([VVConstExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{1?${a}:3}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVConstExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVConstExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{1?2:${a}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVConstExpression class]));
    assertThat(expression.trueExpression, isA([VVConstExpression class]));
    assertThat(expression.falseExpression, isA([VVVariableExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{${a}?${b}:3}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVVariableExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVConstExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{1?${a}:${b}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVConstExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVVariableExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{${a}?${b}:${c}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVVariableExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVVariableExpression class]));

    expression = (id)[VVExpression expressionWithString:@"@{${a}?${b}:@{${c}?${d}:${e}}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat(expression.conditionExpression, isA([VVVariableExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVIifExpression class]));
    assertThat([(VVVariableExpression *)expression.conditionExpression key], equalTo(@"a"));
    assertThat([(VVVariableExpression *)expression.trueExpression key], equalTo(@"b"));
    expression = (id)expression.falseExpression;
    assertThat(expression.conditionExpression, isA([VVVariableExpression class]));
    assertThat(expression.trueExpression, isA([VVVariableExpression class]));
    assertThat(expression.falseExpression, isA([VVVariableExpression class]));
    assertThat([(VVVariableExpression *)expression.conditionExpression key], equalTo(@"c"));
    assertThat([(VVVariableExpression *)expression.trueExpression key], equalTo(@"d"));
    assertThat([(VVVariableExpression *)expression.falseExpression key], equalTo(@"e"));

    expression = (id)[VVExpression expressionWithString:@"@{${a}?${a[0]}:${a[1]}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat([expression resultWithObject:self.testDataDict], equalTo(@"123"));
    
    expression = (id)[VVExpression expressionWithString:@"@{${b}?${a[0]}:${a[1]}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat([expression resultWithObject:self.testDataDict], equalTo(@"123"));
    
    expression = (id)[VVExpression expressionWithString:@"@{${c}?${a[0]}:${a[1]}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat([expression resultWithObject:self.testDataDict], equalTo(@"456"));
    
    expression = (id)[VVExpression expressionWithString:@"@{${d}?${a[0]}:${a[1]}}"];
    assertThat(expression, isA([VVIifExpression class]));
    assertThat([expression resultWithObject:self.testDataDict], equalTo(@"456"));
}

@end

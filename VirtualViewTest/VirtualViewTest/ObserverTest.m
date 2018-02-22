//
//  ObserverTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/NSObject+VVObserver.h>

@interface ObserverTest : XCTestCase

@property (nonatomic, assign) CGRect rectValue;
@property (nonatomic, assign) NSInteger intValue;
@property (nonatomic, strong) NSString *stringValue;

@end

@implementation ObserverTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIntValue {
    __block NSInteger result;
    __block NSInteger times;
    [self vv_addObserverForKeyPath:@"intValue" block:^(id _Nonnull value) {
        result = [value integerValue];
        times++;
    }];
    
    self.intValue = 10;
    assertThatInteger(result, equalToInteger(10));
    assertThatInteger(times, equalToInteger(1));
    
    self.intValue = 10;
    assertThatInteger(result, equalToInteger(10));
    assertThatInteger(times, equalToInteger(1));
    
    self.intValue = 20;
    assertThatInteger(result, equalToInteger(20));
    assertThatInteger(times, equalToInteger(2));
    
    [self vv_removeObserverForKeyPath:@"intValue"];
    
    self.intValue = 30;
    assertThatInteger(result, equalToInteger(20));
    assertThatInteger(times, equalToInteger(2));
}

- (void)testStringValue {
    [self vv_addObserverForKeyPath:@"stringValue" selector:@selector(updateIntValue:)];
    
    self.stringValue = @"10";
    assertThatInteger(self.intValue, equalToInteger(10));
    
    self.stringValue = @"20";
    assertThatInteger(self.intValue, equalToInteger(20));
    
    [self vv_removeAllObservers];
    
    self.stringValue = @"30";
    assertThatInteger(self.intValue, equalToInteger(20));
}

- (void)updateIntValue:(id)stringValue {
    self.intValue = [stringValue integerValue];
}

- (void) testSizeValue {
    __block CGSize result;
    __block NSInteger times;
    [self vv_addObserverForKeyPath:@"sizeValue" block:^(id _Nonnull value) {
        result = [value sizeValue];
        times++;
    }];
    
    self.rectValue = CGRectMake(0, 0, 10, 10);
    assertThatFloat(result.width, equalToFloat(10));
    assertThatFloat(result.height, equalToFloat(10));
    assertThatInteger(times, equalToInteger(1));
    
    self.rectValue = CGRectMake(0, 0, 20, 20);
    assertThatFloat(result.width, equalToFloat(20));
    assertThatFloat(result.height, equalToFloat(20));
    assertThatInteger(times, equalToInteger(2));
    
    self.rectValue = CGRectMake(5, 5, 20, 20);
    assertThatFloat(result.width, equalToFloat(20));
    assertThatFloat(result.height, equalToFloat(20));
    assertThatInteger(times, equalToInteger(2));
}

- (CGSize)sizeValue {
    return _rectValue.size;
}

- (void)setRectValue:(CGRect)rectValue {
    [self willChangeValueForKey:@"sizeValue"];
    _rectValue = rectValue;
    [self didChangeValueForKey:@"sizeValue"];
}

- (void)testObserveTwice {
    __block NSString *result1;
    __block NSInteger result2;
    [self vv_addObserverForKeyPath:@"stringValue" block:^(id _Nonnull value) {
        result1 = [@"=" stringByAppendingString:value];
    }];
    [self vv_addObserverForKeyPath:@"stringValue" block:^(id _Nonnull value) {
        result2 = [value integerValue];
    }];
    
    self.stringValue = @"10";
    assertThat(result1, equalTo(@"=10"));
    assertThatInteger(result2, equalToInteger(10));
}

- (void)testSelectorWithoutParam {
    [self vv_addObserverForKeyPath:@"stringValue" selector:@selector(updateIntValue)];
    
    self.stringValue = @"10";
    assertThatInteger(self.intValue, equalToInteger(-1));
}

- (void)updateIntValue {
    self.intValue = -1;
}

@end

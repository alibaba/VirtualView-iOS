//
//  TemplateManagerTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/VVTemplateManager.h>
#import <VirtualView/VVNodeClassMapper.h>
#import <VirtualView/VVVHLayout.h>
#import <VirtualView/VVDefines.h>

@interface TemplateManagerTest : XCTestCase

@end

@implementation TemplateManagerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadTemplateSync {
    VVTemplateManager *manager = [VVTemplateManager sharedManager];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [manager loadTemplateFile:[bundle pathForResource:@"NImage" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"NLine" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"NText" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"FrameLayout" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"RatioLayout" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"VHLayout" ofType:@"out"] forType:@"linear"];
    [manager loadTemplateFile:[bundle pathForResource:@"icon" ofType:@"out"] forType:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"GridItem" ofType:@"out"] forType:nil];
    assertThat(manager.loadedTypes, hasCountOf(8));
    assertThat(manager.loadedTypes, hasItem(@"GridItem"));
    assertThat(manager.loadedTypes, isNot(hasItem(@"icon")));
    assertThat(manager.loadedTypes, hasItem(@"linear"));
    assertThat([[manager versionOfType:@"GridItem"] stringValue], equalTo(@"1.0.1"));
    VVVHLayout *layout = (id)[manager createNodeTreeForType:@"NText"];
    assertThat(layout, isA([VVVHLayout class]));
    assertThatFloat(layout.layoutHeight, equalToFloat(VV_MATCH_PARENT));
}

- (void)testLoadTemplateAsync {
    XCTestExpectation *expectation = [XCTestExpectation new];
    expectation.expectedFulfillmentCount = 2;
    expectation.assertForOverFulfill = YES;
    
    VVTemplateManager *manager = [VVTemplateManager sharedManager];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NImage" ofType:@"out"] forType:@"NImage" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NLine" ofType:@"out"] forType:@"NLine" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"FrameLayout" ofType:@"out"] forType:@"FrameLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"RatioLayout" ofType:@"out"] forType:@"RatioLayout" completion:nil];
    [manager loadTemplateFile:[bundle pathForResource:@"GridItem" ofType:@"out"] forType:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"VHLayout" ofType:@"out"] forType:@"linear" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        assertThat(type, equalTo(@"linear"));
        assertThat([version stringValue], equalTo(@"1.0.1"));
        [expectation fulfill];
    }];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"icon" ofType:@"out"] forType:@"icon" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        assertThatBool(NO, isTrue());
        [expectation fulfill];
    }];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NText" ofType:@"out"] forType:@"NText" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        assertThat(type, equalTo(@"NText"));
        assertThat([version stringValue], equalTo(@"1.0.1"));
        [expectation fulfill];
    }];
    
    assertThat(manager.loadedTypes, isNot(hasItem(@"NText")));
    
    // Try to create node immediately.
    VVVHLayout *layout = (id)[manager createNodeTreeForType:@"NText"];
    assertThat(layout, isA(VVVHLayout.class));
    assertThatFloat(layout.layoutHeight, equalToFloat(VV_MATCH_PARENT));
    
    assertThat(manager.loadedTypes, hasItem(@"NText"));

    [self waitForExpectations:@[expectation] timeout:10];
    
    assertThat(manager.loadedTypes, hasCountOf(8));
    assertThat(manager.loadedTypes, hasItem(@"GridItem"));
    assertThat(manager.loadedTypes, isNot(hasItem(@"icon")));
    assertThat(manager.loadedTypes, hasItem(@"linear"));
}

- (void)testOnlyLoadTemplateOnce {
    XCTestExpectation *expectation = [XCTestExpectation new];
    expectation.expectedFulfillmentCount = 1;
    expectation.assertForOverFulfill = YES;
    
    VVTemplateManager *manager = [VVTemplateManager sharedManager];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NImage" ofType:@"out"] forType:@"NImage" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NLine" ofType:@"out"] forType:@"NLine" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"FrameLayout" ofType:@"out"] forType:@"FrameLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"RatioLayout" ofType:@"out"] forType:@"RatioLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"VHLayout" ofType:@"out"] forType:@"linear" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NText" ofType:@"out"] forType:@"NText" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        assertThatBool(NO, isTrue());
        [expectation fulfill];
    }];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NText" ofType:@"out"] forType:@"NText" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testRemoveTemplateBeforeReload {
    XCTestExpectation *expectation = [XCTestExpectation new];
    expectation.expectedFulfillmentCount = 1;
    
    VVTemplateManager *manager = [VVTemplateManager sharedManager];
    manager.removeTemplateBeforeReload = YES;
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [manager loadTemplateFile:[bundle pathForResource:@"NText" ofType:@"out"] forType:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NImage" ofType:@"out"] forType:@"NImage" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NLine" ofType:@"out"] forType:@"NLine" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"FrameLayout" ofType:@"out"] forType:@"FrameLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"RatioLayout" ofType:@"out"] forType:@"RatioLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"VHLayout" ofType:@"out"] forType:@"linear" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NText" ofType:@"out"] forType:@"NText" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        [expectation fulfill];
    }];
    
    assertThat(manager.loadedTypes, isNot(hasItem(@"NText")));
    
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testNotRemoveTemplateBeforeReload {
    XCTestExpectation *expectation = [XCTestExpectation new];
    expectation.expectedFulfillmentCount = 1;
    
    VVTemplateManager *manager = [VVTemplateManager sharedManager];
    manager.removeTemplateBeforeReload = NO;
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [manager loadTemplateFile:[bundle pathForResource:@"NText" ofType:@"out"] forType:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NImage" ofType:@"out"] forType:@"NImage" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NLine" ofType:@"out"] forType:@"NLine" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"FrameLayout" ofType:@"out"] forType:@"FrameLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"RatioLayout" ofType:@"out"] forType:@"RatioLayout" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"VHLayout" ofType:@"out"] forType:@"linear" completion:nil];
    [manager loadTemplateFileAsync:[bundle pathForResource:@"NText" ofType:@"out"] forType:@"NText" completion:^(NSString * _Nonnull type, VVVersionModel * _Nullable version) {
        [expectation fulfill];
    }];
    
    assertThat(manager.loadedTypes, hasItem(@"NText"));
    
    [self waitForExpectations:@[expectation] timeout:10];
}

@end

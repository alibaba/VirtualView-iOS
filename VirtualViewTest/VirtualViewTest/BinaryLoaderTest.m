//
//  BinaryLoaderTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/VVTemplateBinaryLoader.h>
#import <VirtualView/VVVersionModel.h>
#import <VirtualView/VVPropertySetter.h>
#import <VirtualView/VVPropertyIntSetter.h>
#import <VirtualView/VVPropertyFloatSetter.h>
#import <VirtualView/VVPropertyStringSetter.h>
#import <VirtualView/VVNodeCreater.h>

@interface BinaryLoaderTest : XCTestCase

@end

@implementation BinaryLoaderTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadIconTemplate {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"icon" ofType:@"out"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    VVTemplateBinaryLoader *loader = [VVTemplateBinaryLoader new];
    assertThatBool([loader loadTemplateData:data], isTrue());
    assertThat([loader.lastVersion stringValue], equalTo(@"1.0.13"));
    assertThat(loader.lastType, equalTo(@"icon"));
    assertThat(loader.lastCreater.nodeClassName, equalTo(@"VVVHLayout"));
    for (VVPropertySetter *setter in loader.lastCreater.propertySetters) {
        if ([setter.name isEqualToString:@"orientation"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(0));
        } else if ([setter.name isEqualToString:@"flag"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(48));
        } else if ([setter.name isEqualToString:@"height"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(-1));
        } else if ([setter.name isEqualToString:@"width"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(-1));
        } else if ([setter.name isEqualToString:@"gravity"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(32));
        } else if ([setter.name isEqualToString:@"action"]) {
            assertThat([(VVPropertyStringSetter *)setter value], equalTo(@"action"));
        }
    }
    assertThat([(VVNodeCreater *)loader.lastCreater.subCreaters[0] nodeClassName], equalTo(@"NVImageView"));
    assertThat([(VVNodeCreater *)loader.lastCreater.subCreaters[1] nodeClassName], equalTo(@"VVFrameLayout"));
    assertThat([(VVNodeCreater *)loader.lastCreater.subCreaters[2] nodeClassName], equalTo(@"NVTextView"));
}

@end

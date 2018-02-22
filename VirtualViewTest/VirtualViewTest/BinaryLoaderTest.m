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
#import <VirtualView/VVDefines.h>
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

- (void)testLoadTemplate {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"GridItem" ofType:@"out"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    VVTemplateBinaryLoader *loader = [VVTemplateBinaryLoader new];
    assertThatBool([loader loadTemplateData:data], isTrue());
    assertThat([loader.lastVersion stringValue], equalTo(@"1.0.1"));
    assertThat(loader.lastType, equalTo(@"GridItem"));
    assertThat(loader.lastCreater.nodeClassName, equalTo(@"VVVHLayout"));
    for (VVPropertySetter *setter in loader.lastCreater.propertySetters) {
        if ([setter.name isEqualToString:@"orientation"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(VVOrientationVertical));
        } else if ([setter.name isEqualToString:@"flag"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(VVFlagClickable | VVFlagLongClickable));
        } else if ([setter.name isEqualToString:@"layoutHeight"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(180));
        } else if ([setter.name isEqualToString:@"layoutWidth"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(VV_MATCH_PARENT));
        } else if ([setter.name isEqualToString:@"gravity"]) {
            assertThatInt([(VVPropertyIntSetter *)setter value], equalToInt(VVGravityHCenter | VVGravityVCenter));
        }
    }
    assertThat([(VVNodeCreater *)loader.lastCreater.subCreaters[0] nodeClassName], equalTo(@"NVImageView"));
    assertThat([(VVNodeCreater *)loader.lastCreater.subCreaters[1] nodeClassName], equalTo(@"NVTextView"));
}

@end

//
//  ColorUtilsTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/UIColor+VirtualView.h>

@interface ColorUtilsTest : XCTestCase

@end

@implementation ColorUtilsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRGBColor {
    assertThat([UIColor vv_colorWithRGB:0xFF0000], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithRGB:0xFF00], equalTo([UIColor greenColor]));
    assertThat([UIColor vv_colorWithRGB:0xFF], equalTo([UIColor blueColor]));
    assertThat([UIColor vv_colorWithRGB:0xFFFF0000], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithRGB:0x00FF0000], equalTo([UIColor redColor]));
}

- (void)testARGBColor {
    assertThat([UIColor vv_colorWithARGB:0xFFFF0000], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithARGB:0xFF00FF00], equalTo([UIColor greenColor]));
    assertThat([UIColor vv_colorWithARGB:0xFF0000FF], equalTo([UIColor blueColor]));
    assertThat([UIColor vv_colorWithARGB:0xFF0000], equalTo([UIColor clearColor]));
    assertThat([UIColor vv_colorWithARGB:0xFF00], equalTo([UIColor clearColor]));
}

- (void)testStringColor {
    assertThat([UIColor vv_colorWithString:@"0xFF0000"], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithString:@"0x00FF00"], equalTo([UIColor greenColor]));
    assertThat([UIColor vv_colorWithString:@"0xFF0000FF"], equalTo([UIColor blueColor]));
    assertThat([UIColor vv_colorWithString:@"0x00FF0000"], equalTo([UIColor clearColor]));
    assertThat([UIColor vv_colorWithString:@"#FF0000"], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithString:@"#00FF00"], equalTo([UIColor greenColor]));
    assertThat([UIColor vv_colorWithString:@"#FF0000FF"], equalTo([UIColor blueColor]));
    assertThat([UIColor vv_colorWithString:@"#0000FF00"], equalTo([UIColor clearColor]));
    assertThat([UIColor vv_colorWithString:@"FF0000"], equalTo([UIColor redColor]));
    assertThat([UIColor vv_colorWithString:@"00FF00"], equalTo([UIColor greenColor]));
    assertThat([UIColor vv_colorWithString:@"FF0000FF"], equalTo([UIColor blueColor]));
    assertThat([UIColor vv_colorWithString:@"000000FF"], equalTo([UIColor clearColor]));
    assertThat([UIColor vv_colorWithString:@"0xF00"], nilValue());
    assertThat([UIColor vv_colorWithString:@"#0F0"], nilValue());
    assertThat([UIColor vv_colorWithString:@"00F"], nilValue());
}

@end

//
//  StringMapperTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/VVBinaryStringMapper.h>
#import <VirtualView/VVDefines.h>

@interface StringMapperTest : XCTestCase

@end

@implementation StringMapperTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHash {
    assertThatInt([VVBinaryStringMapper hashOfString:@"layoutWidth"], equalToInt(STR_ID_layoutWidth));
    assertThatInt([VVBinaryStringMapper hashOfString:@"paddingLeft"], equalToInt(STR_ID_paddingLeft));
    assertThatInt([VVBinaryStringMapper hashOfString:@"orientation"], equalToInt(STR_ID_orientation));
    assertThatInt([VVBinaryStringMapper hashOfString:@"gravity"], equalToInt(STR_ID_gravity));
    assertThatInt([VVBinaryStringMapper hashOfString:@"layoutGravity"], equalToInt(STR_ID_layoutGravity));
    assertThatInt([VVBinaryStringMapper hashOfString:@"action"], equalToInt(STR_ID_action));
    assertThatInt([VVBinaryStringMapper hashOfString:@"textColor"], equalToInt(STR_ID_textColor));
    assertThatInt([VVBinaryStringMapper hashOfString:@"layoutRatio"], equalToInt(STR_ID_layoutRatio));
    assertThatInt([VVBinaryStringMapper hashOfString:@"paintWidth"], equalToInt(STR_ID_paintWidth));
    assertThatInt([VVBinaryStringMapper hashOfString:@"autoDimDirection"], equalToInt(STR_ID_autoDimDirection));
    assertThatInt([VVBinaryStringMapper hashOfString:@"borderWidth"], equalToInt(STR_ID_borderWidth));
    assertThatInt([VVBinaryStringMapper hashOfString:@"borderBottomRightRadius"], equalToInt(STR_ID_borderBottomRightRadius));
    assertThatInt([VVBinaryStringMapper hashOfString:@"ratio"], equalToInt(STR_ID_ratio));
}

@end

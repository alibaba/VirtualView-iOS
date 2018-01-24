//
//  BinaryReaderTest.m
//  VirtualViewTest
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <OCHamcrest/OCHamcrest.h>

@interface BinaryReaderTest : XCTestCase

@end

@implementation BinaryReaderTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testReadFloat1 {
    unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
    uint32_t uintValue = *((uint32_t *)bytes);
    uintValue = CFSwapInt32(uintValue);
    float floatValue = *((float *)(&uintValue));
    assertThatFloat(floatValue, equalToFloat(0.001f));
}

- (void)testReadFloat2 {
    unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
    unsigned char byte = bytes[3]; bytes[3] = bytes[0]; bytes[0] = byte; // swap bytes[0] and bytes[3]
    byte = bytes[2]; bytes[2] = bytes[1]; bytes[1] = byte; // swap bytes[1] and bytes[2]
    float floatValue = *((float *)bytes);
    assertThatFloat(floatValue, equalToFloat(0.001f));
}

- (void)testReadFloat3 {
    unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
    uint32_t uintValue = bytes[3] + (bytes[2] << 8) + (bytes[1] << 16) + (bytes[0] << 24);
    float floatValue = *((float *)(&uintValue));
    assertThatFloat(floatValue, equalToFloat(0.001f));
}

- (void)testReadShort {
    unsigned char bytes[] = {0x01, 0x02};
    uint16_t uintValue = bytes[1] + (bytes[0] << 8);
    short shortValue = *((short *)(&uintValue));
    assertThatShort(shortValue, equalToShort(0x102));
}

- (void)testReadFloatPerformance1 {
    [self measureBlock:^{
        unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
        NSData *data = [NSData dataWithBytes:bytes length:4];
        float floatValue;
        for (NSInteger i = 0; i < 999999; i++) {
            uint32_t uintValue;
            [data getBytes:&uintValue range:NSMakeRange(0, 4)];
            uintValue = CFSwapInt32(uintValue);
            floatValue = *((float *)(&uintValue));
        }
    }];
}

- (void)testReadFloatPerformance2 {
    [self measureBlock:^{
        unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
        NSData *data = [NSData dataWithBytes:bytes length:4];
        float floatValue;
        for (NSInteger i = 0; i < 999999; i++) {
            unsigned char buff[4];
            [data getBytes:buff range:NSMakeRange(0, 4)];
            unsigned char byte = buff[3]; buff[3] = buff[0]; buff[0] = byte; // swap buff[0] and buff[3]
            byte = buff[2]; buff[2] = buff[1]; buff[1] = byte; // swap buff[1] and buff[2]
            floatValue = *((float *)buff);
        }
    }];
}

- (void)testReadFloatPerformance3 {
    [self measureBlock:^{
        unsigned char bytes[] = {0x3A, 0x83, 0x12, 0x6F};
        NSData *data = [NSData dataWithBytes:bytes length:4];
        float floatValue;
        for (NSInteger i = 0; i < 999999; i++) {
            unsigned char buff[4];
            [data getBytes:buff range:NSMakeRange(0, 4)];
            uint32_t uintValue = buff[3] + (buff[2] << 8) + (buff[1] << 16) + (buff[0] << 24);
            floatValue = *((float *)(&uintValue));
        }
    }];
}

@end

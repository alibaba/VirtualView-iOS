//
//  VVTemplateBinaryLoader.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVTemplateBinaryLoader.h"
#import "VVErrors.h"
#import "VVPropertyIntSetter.h"
#import "VVPropertyFloatSetter.h"
#import "VVPropertyStringSetter.h"
#import "VVBinaryStringMapper.h"
#import "VVConfig.h"
#import "VVNodeClassMapper.h"

#define VV_TEMPLATE_HEADER @"ALIVV"
#define VV_START_TAG 0
#define VV_END_TAG 1

@interface VVTemplateBinaryLoader ()

@property (nonatomic, strong, readwrite) NSError *lastError;
@property (nonatomic, strong, readwrite) VVVersionModel *lastVersion;
@property (nonatomic, strong, readwrite) NSString *lastType;
@property (nonatomic, strong, readwrite) VVNodeCreater *lastCreater;

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSUInteger location;
@property (nonatomic, strong) NSMutableDictionary *stringDict;

- (unsigned char)readByte;
- (short)readShortLE;
- (int)readIntLE;
- (nonnull NSString *)readString:(NSUInteger)length;
- (BOOL)seek:(NSUInteger)location;
- (BOOL)skip:(NSUInteger)length;

@end

@implementation VVTemplateBinaryLoader

@synthesize lastError, lastVersion, lastType, lastCreater;

- (NSMutableDictionary *)stringDict
{
    if (!_stringDict) {
        _stringDict = [NSMutableDictionary dictionary];
    }
    return _stringDict;
}

- (BOOL)loadTemplateData:(NSData *)data
{
    // reset
    self.data = data;
    self.location = 0;
    [self.stringDict removeAllObjects];
    self.lastError = nil;
    self.lastVersion = nil;
    self.lastType = nil;
    self.lastCreater = nil;
    
    // check data length
    if (!data || data.length == 0) {
        self.lastError = VVMakeError(VVInvalidDataError, @"Empty data.");
        return NO;
    }
    
    // check header
    NSString *header = [self readString:5];
    if (header.length > 0 && [header isEqualToString:VV_TEMPLATE_HEADER]) {
        short major = [self readShortLE];
        short minor = [self readShortLE];
        short patch = [self readShortLE];
        
        int mainLocation = [self readIntLE];
        int mainSize = [self readIntLE];
        int stringLocation = [self readIntLE];
        int stringSize = [self readIntLE];
        int exprLocation = [self readIntLE];
        int exprSize = [self readIntLE];
        int extraLocation = [self readIntLE];
        int extraSize = [self readIntLE];
        
        // check main data size
        if (mainLocation > 0 && mainSize > 0) {
            if (stringLocation > 0 && stringSize > 0) {
                [self loadStringData:stringLocation];
            }
            
            if (exprLocation > 0 && exprSize > 0) {
                // deprecated
            }
            
            if (extraLocation > 0 && extraSize > 0) {
                // deprecated
            }
            
            // Will load type and make creater in this method.
            if ([self loadMainData:mainLocation]) {
                self.lastVersion = [[VVVersionModel alloc] initWithMajor:major minor:minor patch:patch];
                return YES;
            }
        } else {
            self.lastError = VVMakeError(VVInvalidDataError, @"Empty main data.");
        }
    } else {
        self.lastError = VVMakeError(VVWrongHeaderError, @"Wrong header.");
    }
    return NO;
}

- (void)loadStringData:(NSUInteger)startLocation
{
    [self seek:startLocation];
    int count = [self readIntLE];
    for (int i = 0; i < count; i++) {
        int key = [self readIntLE];
        short length = [self readShortLE];
        NSString *value = [self readString:length];
        [self.stringDict setObject:value forKey:@(key)];
    }
}

- (BOOL)loadMainData:(NSUInteger)startLocation
{
    [self seek:startLocation];
    
    // Only support 1 template in 1 file now.
    int count = [self readIntLE];
    if (count != 1) {
        self.lastError = VVMakeError(VVInvalidDataError, @"More than 1 template in file.");
        return NO;
    }
    
    // Load template type.
    short length = [self readShortLE];
    NSString *type = [self readString:length];
    
    // Get the length of template node tree data.
    length = [self readShortLE];
    NSUInteger endLocation = self.location + length;
    
    // Must start with VV_START_TAG.
    unsigned char tag = [self readByte];
    if (tag != VV_START_TAG) {
        self.lastError = VVMakeError(VVInvalidDataError, @"Node data does not start with 0x00.");
        return NO;
    }
    
    // Load node tree data.
    VVNodeCreater *rootCreater = [self loadNodeData];
    NSMutableArray<VVNodeCreater *> *nodeStack = [NSMutableArray array];
    [nodeStack addObject:rootCreater];
    while (self.location < endLocation) {
        tag = [self readByte];
        if (tag == VV_START_TAG) {
            VVNodeCreater *creater = [self loadNodeData];
            [[(VVNodeCreater *)[nodeStack lastObject] subCreaters] addObject:creater];
            [nodeStack addObject:creater];
        } else if (tag == VV_END_TAG) {
            [nodeStack removeLastObject];
            if (nodeStack.count == 0) {
                break;
            }
        } else {
            NSString *errorDescription = [NSString stringWithFormat:@"Invalid tag - 0x%2X.", tag];
            self.lastError = VVMakeError(VVInvalidDataError, errorDescription);
            return NO;
        }
    }
    
#ifdef VV_DEBUG
    // verify the stack
    NSAssert(nodeStack.count == 0, @"Stack is not empty.");
    
    // verify the location
    NSAssert(self.location == endLocation, @"Does not match the end.");
#endif
    
    self.lastType = type;
    self.lastCreater = rootCreater;
    return YES;
}

- (VVNodeCreater *)loadNodeData
{
    VVNodeCreater *creater = [VVNodeCreater new];
    short nodeID = [self readShortLE];
    creater.nodeClassName = [VVNodeClassMapper classNameForID:nodeID];
    
    short count = [self readByte];
    for (short i = 0; i < count; i++) {
        // int properties
        int key = [self readIntLE];
        int value = [self readIntLE];
        VVPropertySetter *setter = [VVPropertyIntSetter setterWithPropertyKey:key intValue:value];
        [creater.propertySetters addObject:setter];
    }
    
    count = [self readByte];
    for (short i = 0; i < count; i++) {
        // rp int properties
        int key = [self readIntLE];
        int value = [self readIntLE] * VVConfig.pointRatio;
        VVPropertySetter *setter = [VVPropertyIntSetter setterWithPropertyKey:key intValue:value];
        [creater.propertySetters addObject:setter];
    }
    
    count = [self readByte];
    for (short i = 0; i < count; i++) {
        // float properties
        int key = [self readIntLE];
        float value = [self readFloatLE];
        VVPropertySetter *setter = [VVPropertyFloatSetter setterWithPropertyKey:key floatValue:value];
        [creater.propertySetters addObject:setter];
    }
    
    count = [self readByte];
    for (short i = 0; i < count; i++) {
        // rp float properties
        int key = [self readIntLE];
        float value = [self readFloatLE] * VVConfig.pointRatio;
        VVPropertySetter *setter = [VVPropertyFloatSetter setterWithPropertyKey:key floatValue:value];
        [creater.propertySetters addObject:setter];
    }
    
    count = [self readByte];
    for (short i = 0; i < count; i++) {
        // string properties
        int propertyKey = [self readIntLE];
        int stringKey = [self readIntLE];
        NSString *stringValue = [VVBinaryStringMapper stringForKey:stringKey];
        if (!stringValue) {
            stringValue = [self.stringDict objectForKey:@(stringKey)] ?: @"";
        }
        VVPropertySetter *setter = [VVPropertyStringSetter setterWithPropertyKey:propertyKey stringValue:stringValue];
        [creater.propertySetters addObject:setter];
    }
    
    count = [self readByte];
    // expression properties - deprecated
    [self skip:count * 8];
    
    count = [self readByte];
    // extra properties - deprecated
    [self skip:count * 9];
    
    return creater;
}

#pragma mark BinaryReader

- (BOOL)seek:(NSUInteger)location
{
    if (location < self.data.length) {
        self.location = location;
        return YES;
    }
    return NO;
}

- (BOOL)skip:(NSUInteger)length
{
    NSUInteger location = self.location + length;
    if (location < self.data.length) {
        self.location = location;
        return YES;
    }
    return NO;
}

- (unsigned char)readByte
{
    unsigned char result = 0;
    if (self.location < self.data.length - 1) {
        [self.data getBytes:&result range:NSMakeRange(self.location, 1)];
        self.location += 1;
    }
    return result;
}

- (short)readShortLE
{
    short result = 0;
    if (self.location < self.data.length - 2) {
        // Read a short (16-bits) little-endian value.
        // For more details of algorithm, see BinaryReaderTest.m in test project.
        unsigned char bytes[2];
        [self.data getBytes:bytes range:NSMakeRange(self.location, 2)];
        uint16_t uintValue = bytes[1] + (bytes[0] << 8);
        result = *((short *)(&uintValue));
        self.location += 2;
    }
    return result;
}

- (int)readIntLE
{
    int result = 0;
    if (self.location < self.data.length - 4) {
        // Read a int (32-bits) little-endian value.
        // For more details of algorithm, see BinaryReaderTest.m in test project.
        unsigned char bytes[4];
        [self.data getBytes:bytes range:NSMakeRange(self.location, 4)];
        uint32_t uintValue = bytes[3] + (bytes[2] << 8) + (bytes[1] << 16) + (bytes[0] << 24);
        result = *((int *)(&uintValue));
        self.location += 4;
    }
    return result;
}

- (float)readFloatLE
{
    float result = 0;
    if (self.location < self.data.length - 4) {
        // Read a float little-endian value.
        // For more details of algorithm, see BinaryReaderTest.m in test project.
        unsigned char bytes[4];
        [self.data getBytes:bytes range:NSMakeRange(self.location, 4)];
        uint32_t uintValue = bytes[3] + (bytes[2] << 8) + (bytes[1] << 16) + (bytes[0] << 24);
        result = *((float *)(&uintValue));
        self.location += 4;
    }
    return result;
}

- (NSString *)readString:(NSUInteger)length
{
    NSString *result;
    if (length > 0 && self.location < self.data.length - length) {
        NSData *subData = [self.data subdataWithRange:NSMakeRange(self.location, length)];
        result = [[NSString alloc] initWithData:subData encoding:NSUTF8StringEncoding];
        self.location += length;
    } else {
        result = @"";
    }
    return result;
}

@end

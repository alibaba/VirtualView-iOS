//
//  VVVersionModel.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//  :)

#import "VVVersionModel.h"

@interface VVVersionModel () {
    NSString *_stringValue;
}

@end

@implementation VVVersionModel

- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch
{
    if (self = [super init]) {
        _major = major;
        _minor = minor;
        _patch = patch;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; version = %@>", self.class, self, self.stringValue];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[VVVersionModel class]]) {
        return [self compare:object] == NSOrderedSame;
    }
    return NO;
}

- (NSComparisonResult)compare:(VVVersionModel *)aVersion
{
    NSAssert(aVersion != nil, @"VVVersionModel - compare: aVersion should not be nil");
    if (aVersion.major > self.major) {
        return NSOrderedAscending;
    } else if (aVersion.major < self.major) {
        return NSOrderedDescending;
    } else {
        if (aVersion.minor > self.minor) {
            return NSOrderedAscending;
        } else if (aVersion.minor < self.minor) {
            return NSOrderedDescending;
        } else {
            if (aVersion.patch > self.patch) {
                return NSOrderedAscending;
            } else if (aVersion.patch < self.patch) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }
}

- (NSString *)stringValue
{
    if (!_stringValue) {
        _stringValue = [NSString stringWithFormat:@"%zd.%zd.%zd", self.major, self.minor, self.patch];
    }
    return _stringValue;
}

@end

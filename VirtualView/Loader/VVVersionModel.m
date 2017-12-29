//
//  VVVersionModel.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//  :)

#import "VVVersionModel.h"

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
    return [NSString stringWithFormat:@"<%@: %p; version = %zd.%zd.%zd>", self.class, self, self.major, self.minor, self.patch];
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

@end

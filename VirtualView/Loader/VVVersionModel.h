//
//  VVVersionModel.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//  :)

#import <Foundation/Foundation.h>

@interface VVVersionModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger major;
@property (nonatomic, assign, readonly) NSUInteger minor;
@property (nonatomic, assign, readonly) NSUInteger patch;

- (nonnull instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch;

- (BOOL)isEqual:(nullable id)object;
- (NSComparisonResult)compare:(nonnull VVVersionModel *)aVersion;

- (nonnull NSString *)stringValue;

@end

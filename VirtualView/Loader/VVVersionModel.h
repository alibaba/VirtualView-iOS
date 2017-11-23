//
//  VVVersionModel.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVVersionModel : NSObject

@property (nonatomic, assign) NSUInteger major;
@property (nonatomic, assign) NSUInteger minor;
@property (nonatomic, assign) NSUInteger patch;

- (BOOL)isEqual:(nullable id)object;
- (NSComparisonResult)compare:(nonnull VVVersionModel *)aVersion;

@end

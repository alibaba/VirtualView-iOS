//
//  VVBinaryLoader.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVVersionModel;

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVBinaryLoader : NSObject

+ (nonnull id)shareInstance __deprecated;

- (nullable NSData *)getUICodeWithName:(nonnull NSString *)keyStr __deprecated;

- (nullable NSString *)getStrCodeWithType:(int)type __deprecated;

/**
 Load VirtualView template from binary buffer and return the version of it.
 
 @param     buff    Binary buffer.
 @return            Version of template, will be nil if the loading is failed.
 */
- (nullable VVVersionModel *)loadFromBuffer:(nonnull NSData *)buff __deprecated;

@end

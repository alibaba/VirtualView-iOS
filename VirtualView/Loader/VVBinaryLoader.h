//
//  VVBinaryLoader.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVVersionModel.h"

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVBinaryLoader : NSObject

+ (nonnull id)shareInstance __deprecated;

/**
 Load VirtualView template from binary buffer and return the version of it.
 
 @param  buff  Binary buffer.
 @return       Version of template, will be nil if the loading is failed.
 */
- (nullable VVVersionModel *)loadFromBuffer:(nonnull NSData *)buff __deprecated_msg("use [VVTemplateManager loadTemplateData:forType:]");

@end

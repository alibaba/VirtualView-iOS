//
//  VVBinaryLoader.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVVersionModel;

@interface VVBinaryLoader : NSObject

@property(strong, nonatomic)NSMutableDictionary* dataCacheDic;

+ (id)shareInstance;

- (NSString*)getMajorWithPageID:(short)pageid;

- (NSString*)getMinorWithPageID:(short)pageid;

- (NSString*)getPatchWithPageID:(short)pageid;

- (NSData*)getUICodeWithName:(NSString*)keyStr;

- (NSData*)getUICodeWithType:(NSUInteger)type;

- (NSString*)getStrCodeWithType:(int)type;

- (NSData*)getExtraCodeWithType:(NSUInteger)type;

/**
 Load VirtualView data from binary buffer and return the version info of it.

 @param buff Binary buffer.
 @return Version info of data, will be nil if the loading is failed.
 */
- (VVVersionModel *)loadFromBuffer:(NSData*)buff;

/**
 Clear all loaded data.
 */
- (void)clear;

@end

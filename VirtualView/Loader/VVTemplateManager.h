//
//  VVTemplateManager.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVVersionModel;
@class VVTemplateLoader;

@interface VVTemplateManager : NSObject

@property (nonatomic, strong, nonnull) VVTemplateLoader *defaultLoader;

- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nonnull NSString *)type;

- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nonnull NSString *)type
                                   withLoader:(nullable VVTemplateLoader *)loader;

- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nonnull NSString *)type;

- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nonnull NSString *)type
                                   withLoader:(nullable VVTemplateLoader *)loader;

- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
                   withLoader:(nullable VVTemplateLoader *)loader
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
                   withLoader:(nullable VVTemplateLoader *)loader
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

@end

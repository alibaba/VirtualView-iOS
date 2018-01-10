//
//  VVTemplateManager.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVVersionModel.h"

@class VVTemplateLoader;


@interface VVTemplateManager : NSObject

/**
 Default template loader.
 Default value is a VVTemplateBinaryLoader.
 */
@property (nonatomic, strong, nonnull) VVTemplateLoader *defaultLoader;

+ (nonnull VVTemplateManager *)sharedManager;

#pragma mark Synchronously

/**
 Load template from file synchronously with default loader.

 @param  file  Template file path.
 @param  type  Template type name.
 @return       Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nullable NSString *)type;

/**
 Load template from file synchronously with specified loader.
 
 @param  file    Template file path.
 @param  type    Template type name.
 @param  loader  Specified template loader. If it's nil, manager will use the default loader.
 @return         Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nullable NSString *)type
                                   withLoader:(nullable VVTemplateLoader *)loader;

/**
 Load template from binary data synchronously with default loader.
 
 @param  data  Template binary data.
 @param  type  Template type name.
 @return       Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nullable NSString *)type;

/**
 Load template from binary data synchronously with specified loader.
 
 @param  data    Template binary data.
 @param  type    Template type name.
 @param  loader  Specified template loader. If it's nil, manager will use the default loader.
 @return         Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nullable NSString *)type
                                   withLoader:(nullable VVTemplateLoader *)loader;

#pragma mark Asynchronously

/**
 Load template from file asynchronously with default loader.

 @param file        Template file path.
 @param type        Template type name.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;


/**
 Load template from file asynchronously with specified loader.

 @param file        Template file path.
 @param type        Template type name.
 @param loader      Specified template loader. If it's nil, manager will use the default loader.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
                   withLoader:(nullable VVTemplateLoader *)loader
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

/**
 Load template from binary data asynchronously with default loader.
 
 @param data        Template binary data.
 @param type        Template type name.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

/**
 Load template from binary data asynchronously with specified loader.
 
 @param data        Template binary data.
 @param type        Template type name.
 @param loader      Specified template loader. If it's nil, manager will use the default loader.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
                   withLoader:(nullable VVTemplateLoader *)loader
                   completion:(nullable void(^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

@end

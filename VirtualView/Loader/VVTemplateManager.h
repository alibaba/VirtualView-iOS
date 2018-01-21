//
//  VVTemplateManager.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVVersionModel.h"
#import "VVBaseNode.h"

@class VVTemplateLoader;

@interface VVTemplateManager : NSObject

+ (nonnull VVTemplateManager *)sharedManager;

/**
 Default template loader class.
 Default value is a VVTemplateBinaryLoader.
 */
@property (nonatomic, assign, nonnull) Class defaultLoaderClass;

/**
 The manager will remove old template before reload it if this value is YES.
 Default value is YES.
 */
@property (nonatomic, assign) BOOL removeTemplateBeforeReload;

@property (nonatomic, strong, readonly, nonnull) NSArray<NSString *> *loadedTypes;

/**
 Version of loaded type.

 @param type  Template type.
 @return      Template version. Will be nil if loading is failed or not finished.
 */
- (nullable VVVersionModel *)versionOfType:(nonnull NSString *)type;

/**
 Create node tree for type. Will load template in main thread if loading if not finished.

 @param type  Template type.
 @return      Node tree.
 */
- (nullable VVBaseNode *)createNodeTreeForType:(nonnull NSString *)type;

#pragma mark Synchronously

/**
 Load template from file synchronously with default loader.
 Both of input type and the type in template file will be added into manager.

 @param  file  Template file path.
 @param  type  Template type name.
 @return       Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nullable NSString *)type;

/**
 Load template from file synchronously with specified loader.
 Both of input type and the type in template file will be added into manager.
 
 @param  file         Template file path.
 @param  type         Template type name.
 @param  loaderClass  Specified template loader. If it's nil, manager will use the default loader.
 @return              Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateFile:(nonnull NSString *)file
                                      forType:(nullable NSString *)type
                              withLoaderClass:(nullable Class)loaderClass;

/**
 Load template from binary data synchronously with default loader.
 Both of input type and the type in template data will be added into manager.
 
 @param  data  Template binary data.
 @param  type  Template type name.
 @return       Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nullable NSString *)type;

/**
 Load template from binary data synchronously with specified loader.
 Both of input type and the type in template data will be added into manager.
 
 @param  data         Template binary data.
 @param  type         Template type name.
 @param  loaderClass  Specified template loader. If it's nil, manager will use the default loader.
 @return              Version of template. Will be nil if loading is failed.
 */
- (nullable VVVersionModel *)loadTemplateData:(nonnull NSData *)data
                                      forType:(nullable NSString *)type
                              withLoaderClass:(nullable Class)loaderClass;

#pragma mark Asynchronously

/**
 Load template from file asynchronously with default loader.
 Both of input type and the type in template file will be added into manager.

 @param file        Template file path.
 @param type        Template type name.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
                   completion:(nullable void (^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;


/**
 Load template from file asynchronously with specified loader.
 Both of input type and the type in template file will be added into manager.
 
 @param file         Template file path.
 @param type         Template type name.
 @param loaderClass  Specified template loader. If it's nil, manager will use the default loader.
 @param completion   Will be called after loading is done.
        - type       Inputed template type name.
        - version    Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateFileAsync:(nonnull NSString *)file
                      forType:(nonnull NSString *)type
              withLoaderClass:(nullable Class)loaderClass
                   completion:(nullable void (^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

/**
 Load template from binary data asynchronously with default loader.
 Both of input type and the type in template data will be added into manager.
 
 @param data        Template binary data.
 @param type        Template type name.
 @param completion  Will be called after loading is done.
        - type      Inputed template type name.
        - version   Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
                   completion:(nullable void (^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

/**
 Load template from binary data asynchronously with specified loader.
 Both of input type and the type in template data will be added into manager.
 
 @param data         Template binary data.
 @param type         Template type name.
 @param loaderClass  Specified template loader. If it's nil, manager will use the default loader.
 @param completion   Will be called after loading is done.
        - type       Inputed template type name.
        - version    Version of template. Will be nil if loading is failed.
 */
- (void)loadTemplateDataAsync:(nonnull NSData *)data
                      forType:(nonnull NSString *)type
              withLoaderClass:(nullable Class)loaderClass
                   completion:(nullable void (^)(NSString * _Nonnull type, VVVersionModel * _Nullable version))completion;

@end

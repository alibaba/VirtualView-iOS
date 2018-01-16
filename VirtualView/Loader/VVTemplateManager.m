//
//  VVTemplateManager.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVTemplateManager.h"
#import "VVTemplateLoader.h"
#import "VVTemplateBinaryLoader.h"
#import "VVNodeCreater.h"

@interface VVTemplateManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableDictionary *versions;
@property (nonatomic, strong) NSMutableDictionary *creaters;

@end

@implementation VVTemplateManager

+ (VVTemplateManager *)sharedManager
{
    static VVTemplateManager *sharedManager_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager_ = [VVTemplateManager new];
    });
    return sharedManager_;
}

- (instancetype)init
{
    if (self = [super init]) {
        _defaultLoaderClass = [VVTemplateBinaryLoader class];
        _versions = [NSMutableDictionary dictionary];
        _creaters = [NSMutableDictionary dictionary];
        _removeTemplateBeforeReload = YES;
    }
    return self;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.qualityOfService = NSQualityOfServiceUtility;
        _operationQueue.maxConcurrentOperationCount = 1;
        _operationQueue.name = @"VVTemplateLoading";
    }
    return _operationQueue;
}

- (NSArray<NSString *> *)loadedTypes
{
    return self.versions.allKeys;
}

- (VVVersionModel *)versionOfType:(NSString *)type
{
    return [self.versions objectForKey:type];
}

- (VVViewObject *)createNodeTreeForType:(NSString *)type
{
    VVNodeCreater *creater = [self.creaters objectForKey:type];
    if (!creater && _operationQueue) {
        NSOperation *lastOperation = nil;
        for (NSOperation *operation in _operationQueue.operations) {
            if ([operation.name isEqualToString:type]) {
                lastOperation = operation;
                [operation cancel];
            }
        }
        if (lastOperation) {
            [lastOperation main];
            creater = [self.creaters objectForKey:type];
        }
    }
    return creater ? [creater createNodeTree] : nil;
}

#pragma mark LoadingEvents

- (void)willLoadType:(NSString *)type
{
    if (self.removeTemplateBeforeReload) {
        void (^action)(void) = ^{
            if (_operationQueue) {
                for (NSOperation *operation in _operationQueue.operations) {
                    if ([operation.name isEqualToString:type]) {
                        [operation cancel];
                        operation.completionBlock = nil;
                    }
                }
            }
            if ([self.loadedTypes containsObject:type]) {
                [self.versions removeObjectForKey:type];
                [self.creaters removeObjectForKey:type];
            }
        };
        if ([NSThread isMainThread]) {
            action();
        } else {
            dispatch_sync(dispatch_get_main_queue(), action);
        }
    }
}

- (void)didLoadType:(NSString *)type version:(VVVersionModel *)version creater:(VVNodeCreater *)creater
{
    void (^action)(void) = ^{
        [self.versions setObject:version forKey:type];
        [self.creaters setObject:creater forKey:type];
    };
    if ([NSThread isMainThread]) {
        action();
    } else {
        dispatch_sync(dispatch_get_main_queue(), action);
    }
}

#pragma mark Synchronously

- (VVVersionModel *)loadTemplateFile:(NSString *)file
                             forType:(NSString *)type
{
    return [self loadTemplateFile:file forType:type withLoaderClass:nil];
}

- (VVVersionModel *)loadTemplateFile:(NSString *)file
                             forType:(NSString *)type
                     withLoaderClass:(Class)loaderClass
{
    [self willLoadType:type];
    
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self _loadTemplateData:data forType:type withLoaderClass:loaderClass];
}

- (VVVersionModel *)loadTemplateData:(NSData *)data
                             forType:(NSString *)type
{
    return [self loadTemplateData:data forType:type withLoaderClass:nil];
}

- (VVVersionModel *)loadTemplateData:(NSData *)data
                             forType:(NSString *)type
                     withLoaderClass:(Class)loaderClass
{
    [self willLoadType:type];
    
    return [self _loadTemplateData:data forType:type withLoaderClass:loaderClass];
}

- (VVVersionModel *)_loadTemplateData:(NSData *)data
                              forType:(NSString *)type
                      withLoaderClass:(Class)loaderClass
{
    VVTemplateLoader *loader = loaderClass != NULL ? [loaderClass new] : [self.defaultLoaderClass new];
    if ([loader loadTemplateData:data]) {
        [self didLoadType:loader.lastType version:loader.lastVersion creater:loader.lastCreater];
        if (type && [type isEqualToString:loader.lastType] == NO) {
            [self didLoadType:type version:loader.lastVersion creater:loader.lastCreater];
        }
    }
    return loader.lastVersion;
}

#pragma mark Asynchronously

- (void)loadTemplateFileAsync:(NSString *)file
                      forType:(NSString *)type
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    [self loadTemplateFileAsync:file forType:type withLoaderClass:nil completion:completion];
}

- (void)loadTemplateFileAsync:(NSString *)file
                      forType:(NSString *)type
              withLoaderClass:(Class)loaderClass
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    [self willLoadType:type];
    
    __weak VVTemplateManager *weakSelf = self;
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        VVTemplateManager *strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [NSData dataWithContentsOfFile:file];
            version = [strongSelf _loadTemplateData:data forType:type withLoaderClass:loaderClass];
        }
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            if ([NSThread isMainThread]) {
                completion(type, version);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(type, version);
                });
            }
        };
    }
    [self.operationQueue addOperation:opearation];
}

- (void)loadTemplateDataAsync:(NSData *)data
                      forType:(NSString *)type
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    [self loadTemplateDataAsync:data forType:type withLoaderClass:nil completion:completion];
}

- (void)loadTemplateDataAsync:(NSData *)data
                      forType:(NSString *)type
              withLoaderClass:(Class)loaderClass
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    [self willLoadType:type];
    
    __weak VVTemplateManager *weakSelf = self;
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        VVTemplateManager *strongSelf = weakSelf;
        if (strongSelf) {
            version = [strongSelf _loadTemplateData:data forType:type withLoaderClass:loaderClass];
        }
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            if ([NSThread isMainThread]) {
                completion(type, version);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(type, version);
                });
            }
        };
    }
    [self.operationQueue addOperation:opearation];
}

@end

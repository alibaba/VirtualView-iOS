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
        for (NSOperation *operation in _operationQueue.operations) {
            if ([operation.name isEqualToString:type]) {
                [operation main];
                [operation cancel];
                break;
            }
        }
        creater = [self.creaters objectForKey:type];
    }
    return [creater createNodeTree];
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
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self loadTemplateData:data forType:type withLoaderClass:loaderClass];
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
    VVTemplateLoader *loader = loaderClass != NULL ? [loaderClass new] : [self.defaultLoaderClass new];
    if ([loader loadTemplateData:data]) {
        void (^action)(void) = ^{
            if (![self.loadedTypes containsObject:loader.lastType]) {
                [self.versions setObject:loader.lastVersion forKey:loader.lastType];
                [self.creaters setObject:loader.lastCreater forKey:loader.lastType];
            }
            if (type && [type isEqualToString:loader.lastType] == NO && [self.loadedTypes containsObject:type] == NO) {
                [self.versions setObject:loader.lastVersion forKey:type];
                [self.creaters setObject:loader.lastCreater forKey:type];
            }
        };
        if ([NSThread currentThread]) {
            action();
        } else {
            dispatch_async(dispatch_get_main_queue(), action);
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
    __weak VVTemplateManager *weakSelf = self;
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        VVTemplateManager *strongSelf = weakSelf;
        if (strongSelf) {
            version = [strongSelf loadTemplateFile:file forType:type withLoaderClass:loaderClass];
        }
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            if ([NSThread currentThread]) {
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
    __weak VVTemplateManager *weakSelf = self;
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        VVTemplateManager *strongSelf = weakSelf;
        if (strongSelf) {
            version = [strongSelf loadTemplateData:data forType:type withLoaderClass:loaderClass];
        }
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            if ([NSThread currentThread]) {
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

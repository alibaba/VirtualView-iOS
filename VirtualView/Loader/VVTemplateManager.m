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
#ifdef VV_ALIBABA
#import <UT/AppMonitor.h>
#endif

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
#ifdef VV_ALIBABA
        [VVTemplateManager registerAppMoniter];
#endif
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
    if (!type || type.length == 0) {
        return nil;
    }
    return [self.versions objectForKey:type];
}

- (VVBaseNode *)createNodeTreeForType:(NSString *)type
{
    if (!type || type.length == 0) {
        return nil;
    }
    
    if ([self.loadedTypes containsObject:type] == NO && _operationQueue) {
        // Try to find unloaded template in queue and load it immediately.
        BOOL isFirst = YES;
        for (NSOperation *operation in _operationQueue.operations.reverseObjectEnumerator) {
            if ([operation.name isEqualToString:type]) {
                if (isFirst) {
                    [operation main];
                    isFirst = NO;
                }
                [operation cancel];
            }
        }
    }
    VVNodeCreater *creater = [self.creaters objectForKey:type];
#ifdef VV_ALIBABA
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
#endif
    VVBaseNode *nodeTree = creater ? [creater createNodeTree] : nil;
    if (nodeTree) {
        nodeTree.templateType = type;
#ifdef VV_ALIBABA
        NSTimeInterval costTime = [NSDate date].timeIntervalSince1970 - startTime;
        [self.class commitAppMoniterForCreateNodeTree:type
                                              success:YES
                                             costTime:costTime];
    } else {
        [self.class commitAppMoniterForCreateNodeTree:type
                                              success:NO
                                             costTime:0];
#endif
    }
    return nodeTree;
}

#pragma mark LoadingEvents

- (void)willLoadType:(NSString *)type
{
    if (!type || type.length == 0) {
        return;
    }
    
    void (^action)(void) = ^{
        if (self->_operationQueue) {
            for (NSOperation *operation in self->_operationQueue.operations) {
                if ([operation.name isEqualToString:type]) {
                    [operation cancel];
                    operation.completionBlock = nil;
                }
            }
        }
        if (self.removeTemplateBeforeReload && [self.loadedTypes containsObject:type]) {
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

- (void)didLoadType:(NSString *)type version:(VVVersionModel *)version creater:(VVNodeCreater *)creater
{
    if (!type || type.length == 0) {
        return;
    }
    
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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:file] == NO) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self private_LoadTemplateData:data forType:type withLoaderClass:loaderClass];
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
    
    if (!data || data.length == 0) {
        return nil;
    }
    
    return [self private_LoadTemplateData:data forType:type withLoaderClass:loaderClass];
}

- (VVVersionModel *)private_LoadTemplateData:(NSData *)data
                                     forType:(NSString *)type
                             withLoaderClass:(Class)loaderClass
{
#ifdef VV_ALIBABA
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
#endif
    VVTemplateLoader *loader = loaderClass != NULL ? [loaderClass new] : [self.defaultLoaderClass new];
    if ([loader loadTemplateData:data]) {
        [self didLoadType:loader.lastType version:loader.lastVersion creater:loader.lastCreater];
        if (type && [type isEqualToString:loader.lastType] == NO) {
            [self didLoadType:type version:loader.lastVersion creater:loader.lastCreater];
        }
#ifdef VV_DEBUG
    } else {
        NSAssert(NO, @"Cannot load template.");
#endif
    }
#ifdef VV_ALIBABA
    if (loader.lastType) {
        [self.class commitAppMoniterForDidLoadTemplate:loader.lastType
                                               success:YES
                                                 error:nil];
    } else {
        [self.class commitAppMoniterForDidLoadTemplate:type
                                               success:NO
                                                 error:loader.lastError];
    }
    NSTimeInterval costTime = [NSDate date].timeIntervalSince1970 - startTime;
    [self.class commitAppMoniterForLoadTemplate:loader.lastType ?: type
                                       costTime:costTime
                                   isMainThread:[NSThread isMainThread]];
#endif
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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:file] == NO) {
        return;
    }
    
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfFile:file];
        version = [self private_LoadTemplateData:data forType:type withLoaderClass:loaderClass];
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            completion(type, version);
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
    
    if (!data || data.length == 0) {
        return;
    }
    
    __block VVVersionModel *version = nil;
    NSBlockOperation *opearation = [NSBlockOperation blockOperationWithBlock:^{
        version = [self private_LoadTemplateData:data forType:type withLoaderClass:loaderClass];
    }];
    opearation.name = type;
    if (completion) {
        opearation.completionBlock = ^{
            completion(type, version);
        };
    }
    [self.operationQueue addOperation:opearation];
}

#pragma mark AppMoniter

#ifdef VV_ALIBABA
+ (void)registerAppMoniter
{
    AppMonitorMeasureSet *measureSet = [AppMonitorMeasureSet new];
    [measureSet addMeasureWithName:@"costTime"];
    AppMonitorDimensionSet *dimensionSet = [AppMonitorDimensionSet new];
    [dimensionSet addDimensionWithName:@"isMainThread"];
    [dimensionSet addDimensionWithName:@"type"];
    [AppMonitorStat registerWithModule:@"VirtualView"
                          monitorPoint:@"loadTemplate"
                            measureSet:measureSet
                          dimensionSet:dimensionSet];
    
    measureSet = [AppMonitorMeasureSet new];
    [measureSet addMeasureWithName:@"costTime"];
    dimensionSet = [AppMonitorDimensionSet new];
    [dimensionSet addDimensionWithName:@"type"];
    [AppMonitorStat registerWithModule:@"VirtualView"
                          monitorPoint:@"createNodeTree"
                            measureSet:measureSet
                          dimensionSet:dimensionSet];
}

+ (void)commitAppMoniterForLoadTemplate:(NSString *)type costTime:(NSTimeInterval)costTime isMainThread:(BOOL)isMainThread
{
    AppMonitorDimensionValueSet *dValueSet = [AppMonitorDimensionValueSet new];
    [dValueSet setValue:(isMainThread ? @"yes" : @"no") forName:@"isMainThread"];
    [dValueSet setValue:(type ?: @"unknown") forName:@"type"];
    AppMonitorMeasureValueSet *mValueSet = [AppMonitorMeasureValueSet new];
    [mValueSet setDoubleValue:costTime forName:@"costTime"];
    [AppMonitorStat commitWithModule:@"VirtualView"
                        monitorPoint:@"loadTemplate"
                   dimensionValueSet:dValueSet
                     measureValueSet:mValueSet];
}

+ (void)commitAppMoniterForCreateNodeTree:(NSString *)type success:(BOOL)success costTime:(NSTimeInterval)costTime
{
    if (success) {
        AppMonitorDimensionValueSet *dValueSet = [AppMonitorDimensionValueSet new];
        [dValueSet setValue:(type ?: @"unknown") forName:@"type"];
        AppMonitorMeasureValueSet *mValueSet = [AppMonitorMeasureValueSet new];
        [mValueSet setDoubleValue:costTime forName:@"costTime"];
        [AppMonitorStat commitWithModule:@"VirtualView"
                            monitorPoint:@"createNodeTree"
                       dimensionValueSet:dValueSet
                         measureValueSet:mValueSet];
    } else {
        [AppMonitorAlarm commitFailWithPage:@"VirtualView"
                               monitorPoint:@"createNodeTreeFail"
                                  errorCode:@"0"
                                   errorMsg:@"unknown"
                                        arg:type ?: @"unknown"];
    }
}

+ (void)commitAppMoniterForDidLoadTemplate:(NSString *)type success:(BOOL)success error:(NSError *)error
{
    if (success) {
        [AppMonitorAlarm commitSuccessWithPage:@"VirtualView"
                                  monitorPoint:@"didLoadTemplate"
                                           arg:type ?: @"unknown"];
    } else {
        [AppMonitorAlarm commitFailWithPage:@"VirtualView"
                               monitorPoint:@"didLoadTemplate"
                                  errorCode:[NSString stringWithFormat:@"%zd", error.code]
                                   errorMsg:error.localizedDescription ?: @"unknown"
                                        arg:type ?: @"unknown"];
    }
}
#endif

@end

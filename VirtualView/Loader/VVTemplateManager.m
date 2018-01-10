//
//  VVTemplateManager.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVTemplateManager.h"
#import "VVTemplateLoader.h"
#import "VVTemplateBinaryLoader.h"


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
        _defaultLoader = [VVTemplateBinaryLoader new];
    }
    return self;
}

#pragma mark Synchronously

- (VVVersionModel *)loadTemplateFile:(NSString *)file
                             forType:(NSString *)type
{
    return [self loadTemplateFile:file forType:type withLoader:nil];
}

- (VVVersionModel *)loadTemplateFile:(NSString *)file
                             forType:(NSString *)type
                          withLoader:(VVTemplateLoader *)loader
{
    return nil;
}

- (VVVersionModel *)loadTemplateData:(NSData *)data
                             forType:(NSString *)type
{
    return [self loadTemplateData:data forType:type withLoader:nil];
}

- (VVVersionModel *)loadTemplateData:(NSData *)data
                             forType:(NSString *)type
                          withLoader:(VVTemplateLoader *)loader
{
    return nil;
}

#pragma mark Asynchronously

- (void)loadTemplateFileAsync:(NSString *)file
                      forType:(NSString *)type
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    
}

- (void)loadTemplateFileAsync:(NSString *)file
                      forType:(NSString *)type
                   withLoader:(VVTemplateLoader *)loader
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    
}

- (void)loadTemplateDataAsync:(NSData *)data
                      forType:(NSString *)type
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    
}

- (void)loadTemplateDataAsync:(NSData *)data
                      forType:(NSString *)type
                   withLoader:(VVTemplateLoader *)loader
                   completion:(void (^)(NSString * _Nonnull, VVVersionModel * _Nullable))completion
{
    
}

@end

//
//  VVBinaryLoader.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBinaryLoader.h"
#import "VVTemplateManager.h"

@implementation VVBinaryLoader

+ (id)shareInstance
{
    static VVBinaryLoader *shareInstance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [VVBinaryLoader new];
    });
    return shareInstance_;
}

- (NSData *)getUICodeWithName:(NSString *)keyStr
{
    return nil;
}

- (NSString *)getStrCodeWithType:(int)type
{
    return nil;
}

- (VVVersionModel *)loadFromBuffer:(NSData *)buff
{
    return [[VVTemplateManager sharedManager] loadTemplateData:buff forType:nil];
}

@end

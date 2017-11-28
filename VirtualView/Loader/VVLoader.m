//
//  VVLoader.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVLoader.h"

@interface VVLoader ()

@end

@implementation VVLoader

+ (VVLoader *)sharedLoader
{
    static VVLoader *sharedLoader_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoader_ = [VVLoader new];
    });
    return sharedLoader_;
}

@end

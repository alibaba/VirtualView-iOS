//
//  VVTemplateLoader.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVTemplateLoader.h"

@implementation VVTemplateLoader

- (BOOL)loadTemplateData:(NSData *)data
              completion:(void (^)(VVVersionModel * _Nullable, VVNodeCreater * _Nullable))completion
{
    // Override me.
    return NO;
}

@end

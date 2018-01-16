//
//  VVTemplateLoader.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVTemplateLoader.h"
#import "VVErrors.h"

@interface VVTemplateLoader ()

@property (nonatomic, strong, readwrite) NSError *lastError;
@property (nonatomic, strong, readwrite) VVVersionModel *lastVersion;
@property (nonatomic, strong, readwrite) NSString *lastType;
@property (nonatomic, strong, readwrite) VVNodeCreater *lastCreater;

@end

@implementation VVTemplateLoader

- (BOOL)loadTemplateData:(NSData *)data
{
    // override me
    self.lastError = VVMakeError(VVNeedToBeOverridedError, @"Need to be overrided.");
    self.lastVersion = nil;
    self.lastType = nil;
    self.lastCreater = nil;
    return NO;
}

@end

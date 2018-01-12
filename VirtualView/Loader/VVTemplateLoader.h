//
//  VVTemplateLoader.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVVersionModel.h"
#import "VVNodeCreater.h"

/**
 This is a base class for all TemplateLoader. DO NOT use it directly.
 Please use the sub class of it.
 TemplateLoader can load template and store it with a NodeCreater instance.
 Then you will be able to create a node tree via that NodeCreater.
 */
@interface VVTemplateLoader : NSObject

/**
 Error of last template loading. Will be nil if loading is successed.
 */
@property (nonatomic, strong, readonly, nullable) NSError *lastError;

/**
 Version of last template loading. Will be nil if loading is failed.
 */
@property (nonatomic, strong, readonly, nullable) VVVersionModel *lastVersion;

/**
 Type of last template loading. Will be nil if loading is failed.
 */
@property (nonatomic, strong, readonly, nullable) NSString *lastType;

/**
 VVNodeCreater of last template loading. Will be nil if loading is failed.
 */
@property (nonatomic, strong, readonly, nullable) VVNodeCreater *lastCreater;

/**
 Load template data synchronously.

 @param  data  Template data.
 @return       Is loading successed.
 */
- (BOOL)loadTemplateData:(nonnull NSData *)data;

@end

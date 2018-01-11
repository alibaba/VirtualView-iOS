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
 Load template data synchronously.
 It is NOT a asynchronous method. The completion is used for returning mutiple values.

 @param  data        Template data.
 @param  completion  Will be called after loading is done.
         - version   Version of template. Will be nil if loading is failed.
         - creater   VVNodeCreater. Will be nil if loading is failed.
 @return             Is loading successed.
 */
- (BOOL)loadTemplateData:(nonnull NSData *)data
              completion:(nullable void(^)(VVVersionModel * _Nullable version, VVNodeCreater * _Nullable creater))completion;

@end

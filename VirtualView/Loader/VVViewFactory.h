//
//  VVViewFactory.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVViewContainer.h"

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVViewFactory : NSObject

+ (VVViewFactory *)shareFactoryInstance __deprecated;

/**
 Create the node tree. Return a VVViewContainer that contains the node tree.

 @param key  Template type
 @return     VVViewContainer with created node tree.
 */
- (VVViewContainer *)obtainVirtualWithKey:(NSString *)key __deprecated_msg("use [VVViewContainer viewContainerWithTemplateType:]");

@end

//
//  VVPropertySetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVViewObject.h"

/**
 This is a base class for all PropertySetter. DO NOT use it directly.
 Please use the sub class of it.
 PropertySetter can save 'property => value' key-value-pair and take
 effect with one call.
 */
@interface VVPropertySetter : NSObject

@property (nonatomic, assign, readonly) int key;

- (nonnull instancetype)initWithPropertyKey:(int)key;
- (void)applyToNode:(nullable VVViewObject *)node;

@end

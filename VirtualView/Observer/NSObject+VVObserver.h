//
//  NSObject+VVObserver.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVObserver.h"

@interface NSObject (VVObserver)

- (void)vv_addObserverForKeyPath:(nonnull NSString *)keyPath block:(nonnull VVObserverBlock)block;
- (void)vv_addObserverForKeyPath:(nonnull NSString *)keyPath selector:(nonnull SEL)selector;
- (void)vv_addObserverForKeyPath:(nonnull NSString *)keyPath target:(nonnull id)target selector:(nonnull SEL)selector;
- (void)vv_removeObserverForKeyPath:(nonnull NSString *)keyPath;
- (void)vv_removeAllObservers;

@end

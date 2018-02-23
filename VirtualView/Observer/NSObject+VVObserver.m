//
//  NSObject+VVObserver.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NSObject+VVObserver.h"
#import <objc/runtime.h>

@implementation NSObject (VVObserver)

- (NSMutableArray *)vv_observers
{
    NSMutableArray *observers = objc_getAssociatedObject(self, @"vv_observers");
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, @"vv_observers", observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observers;
}

- (void)vv_addObserverForKeyPath:(NSString *)keyPath block:(nonnull VVObserverBlock)block
{
    VVObserver *observer = [[VVObserver alloc] initWithBlock:block];
    observer.name = keyPath;
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:VVObserverContext];
    [self.vv_observers addObject:observer];
}

- (void)vv_addObserverForKeyPath:(NSString *)keyPath selector:(SEL)selector
{
    [self vv_addObserverForKeyPath:keyPath target:self selector:selector];
}

- (void)vv_addObserverForKeyPath:(NSString *)keyPath target:(nonnull id)target selector:(nonnull SEL)selector
{
    VVObserver *observer = [[VVObserver alloc] initWithTarget:target selector:selector];
    observer.name = keyPath;
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:VVObserverContext];
    [self.vv_observers addObject:observer];
}

- (void)vv_removeObserverForKeyPath:(NSString *)keyPath
{
    NSMutableArray *observers = objc_getAssociatedObject(self, @"vv_observers");
    if (!observers) {
        return;
    }
    
    NSMutableSet *toBeRemoved = [NSMutableSet set];
    for (VVObserver *observer in observers) {
        if ([observer.name isEqualToString:keyPath]) {
            [toBeRemoved addObject:observer];
        }
    }
    for (VVObserver *observer in toBeRemoved) {
        [self removeObserver:observer forKeyPath:keyPath context:VVObserverContext];
        [observers removeObject:observer];
    }
}

- (void)vv_removeAllObservers
{
    NSMutableArray *observers = objc_getAssociatedObject(self, @"vv_observers");
    if (!observers) {
        return;
    }
    
    for (VVObserver *observer in observers) {
        [self removeObserver:observer forKeyPath:observer.name context:VVObserverContext];
    }
    [observers removeAllObjects];
}

@end

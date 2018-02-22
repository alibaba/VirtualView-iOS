//
//  VVObserver.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVObserver.h"

void * const VVObserverContext = "VVObserverContext";

@implementation VVObserver

- (instancetype)initWithBlock:(VVObserverBlock)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)selector
{
    if (self = [super init]) {
        _targer = target;
        _selector = selector;
    }
    return self;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if (context == VVObserverContext) {
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if ([newValue isEqual:oldValue] == NO) {
            if (self.block) {
                self.block(newValue);
            } else if (self.targer && self.selector && [self.targer respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.targer performSelector:self.selector withObject:newValue];
#pragma clang diagnostic pop
            }
        }
    }
}

@end

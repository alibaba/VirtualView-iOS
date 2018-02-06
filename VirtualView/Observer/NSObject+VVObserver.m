//
//  NSObject+VVObserver.m
//  VirtualView
//
//  Created by HarrisonXi on 2018/2/6.
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

- (VVObserver *)vv_addObserverForKey:(NSString *)key block:(void (^)(void))block
{
    return nil;
}

- (void)vv_removeObserverForKey:(NSString *)key
{
    
}

- (void)vv_removeAllObservers
{
    
}

@end

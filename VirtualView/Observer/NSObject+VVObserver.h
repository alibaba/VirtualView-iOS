//
//  NSObject+VVObserver.h
//  VirtualView
//
//  Created by HarrisonXi on 2018/2/6.
//

#import <Foundation/Foundation.h>
#import "VVObserver.h"

@interface NSObject (VVObserver)

- (void)vv_addObserverForKeyPath:(nonnull NSString *)keyPath block:(nonnull VVObserverBlock)block;
- (void)vv_addObserverForKeyPath:(nonnull NSString *)keyPath selector:(nonnull SEL)selector;
- (void)vv_removeObserverForKeyPath:(nonnull NSString *)keyPath;
- (void)vv_removeAllObservers;

@end

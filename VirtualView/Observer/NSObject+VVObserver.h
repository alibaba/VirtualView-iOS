//
//  NSObject+VVObserver.h
//  VirtualView
//
//  Created by HarrisonXi on 2018/2/6.
//

#import <Foundation/Foundation.h>
#import "VVObserver.h"

@interface NSObject (VVObserver)

- (VVObserver *)vv_addObserverForKey:(NSString *)key block:(void (^)(void))block;
- (void)vv_removeObserverForKey:(NSString *)key;
- (void)vv_removeAllObservers;

@end

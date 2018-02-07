//
//  VVObserver.h
//  VirtualView
//
//  Created by HarrisonXi on 2018/2/6.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT void * _Nonnull const VVObserverContext;

typedef void(^VVObserverBlock)(id _Nonnull value);

@interface VVObserver : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, readonly, nullable) VVObserverBlock block;
@property (nonatomic, weak, readonly, nullable) id targer;
@property (nonatomic, assign, readonly, nullable) SEL selector;

- (nonnull instancetype)initWithBlock:(nonnull VVObserverBlock)block;
- (nonnull instancetype)initWithTarget:(nonnull id)target selector:(nonnull SEL)selector;

@end

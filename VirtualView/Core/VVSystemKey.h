//
//  VVSystemKey.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVSystemKey : NSObject
@property(nonatomic, readonly)NSArray* keyArray;
@property(nonatomic, readonly)NSDictionary* keyDictionary;
@property(nonatomic, assign) CGFloat rate;
+ (VVSystemKey*)shareInstance;
- (NSString*)classNameForIndex:(NSUInteger)index;
- (NSString*)classNameForTag:(NSString*)tag;
- (void)registerWidget:(NSString*)className withIndex:(NSUInteger)index;
@end

//
//  VVLoader.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVLoader : NSObject
@property(strong, nonatomic)NSMutableDictionary* cacheDic;
+ (VVLoader*)shareInstance;
@end

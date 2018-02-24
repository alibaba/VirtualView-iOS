//
//  Dot9ImageView.h
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <VirtualView/VVBaseNode.h>

@interface Dot9ImageView : VVBaseNode

@property (nonatomic, strong) NSString *src;
@property (nonatomic, assign) float dot9Left;
@property (nonatomic, assign) float dot9Top;
@property (nonatomic, assign) float dot9Right;
@property (nonatomic, assign) float dot9Bottom;
@property (nonatomic, assign) int dot9Scale;

@end

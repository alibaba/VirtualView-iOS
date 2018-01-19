//
//  VVConfig.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVConfig : NSObject

/**
 RP is a length unit of UI design.
 If the size of UI design is 750 x 1334:
 
     pointRatio = [UIScreen mainScreen].bounds.size.width / 750
 
 Then you can use RP as a length in your xml template.
 For example, in iPhone SE:
 
     pointRatio = 320 / 750 = 0.4266667
     100 RP = (100 x pointRatio) PT = 42.66667 PT
 */
@property (nonatomic, assign, class) CGFloat pointRatio;

@end

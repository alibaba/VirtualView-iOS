//
//  VVGridLayout.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayout.h"

@interface VVGridLayout : VVLayout

@property (nonatomic, assign) int colCount;
@property (nonatomic, assign, readonly) int rowCount;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemVerticalMargin;
@property (nonatomic, assign) CGFloat itemHorizontalMargin;

@end

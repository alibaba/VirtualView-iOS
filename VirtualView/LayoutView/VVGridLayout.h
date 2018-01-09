//
//  VVGridLayout.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayout.h"

@interface VVGridLayout : VVLayout
@property(nonatomic, assign)NSUInteger colCount;
@property(nonatomic, assign)NSUInteger rowCount;
@property(nonatomic, assign)CGFloat    itemHeight;
@property(nonatomic, assign)CGSize     itemMaxSize;
@property(nonatomic, assign)CGFloat    itemVerticalMargin;
@property(nonatomic, assign)CGFloat    itemHorizontalMargin;
@end

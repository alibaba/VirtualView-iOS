//
//  NVCarouselPageView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVPageView.h"

@interface NVCarouselPageView : UIView

@property   (nonatomic, strong) NSArray            *data;

@property   (nonatomic, strong) NSNumber           *scrollInterval;

@property   (nonatomic, assign) CGFloat            animDelay;

@property   (nonatomic, assign) BOOL                         isCountDown;

@property   (nonatomic, assign) NSUInteger                   currentItemIndex;

@property   (nonatomic, weak) VVPageView           *pageView;

- (void)beginCountdown;

- (void)endCountdown;

- (void)calculateLayout;


@end

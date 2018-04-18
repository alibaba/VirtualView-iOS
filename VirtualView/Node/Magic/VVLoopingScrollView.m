//
//  VVLoopingScrollView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLoopingScrollView.h"

@interface VVLoopingScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL inAnimation;

@end

@implementation VVLoopingScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (void)reset
{
    if (self.contentSize.width > self.frame.size.width) {
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
    } else {
        self.contentOffset = CGPointMake(0, self.frame.size.height);
    }
    
    [self stopAutoSwitch];
    if (self.autoSwitch) {
        [self startAutoSwitch];
    }
}

- (void)startAutoSwitch
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_stayTime target:self selector:@selector(autoSwitchHandler:) userInfo:nil repeats:YES];
}

- (void)stopAutoSwitch
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)autoSwitchHandler:(id)sender
{
    if (!self.inAnimation) {
        self.inAnimation = YES;
        if (self.contentSize.width > self.frame.size.width) {
            [UIView animateWithDuration:_autoSwitchTime animations:^{
                self.contentOffset = CGPointMake(self.contentOffset.x + self.frame.size.width, 0);
            } completion:^(BOOL finished) {
                [self scrollViewDidEndDecelerating:self];
                self.inAnimation = NO;
            }];
        } else {
            [UIView animateWithDuration:_autoSwitchTime animations:^{
                self.contentOffset = CGPointMake(0, self.contentOffset.y + self.frame.size.height);
            } completion:^(BOOL finished) {
                [self scrollViewDidEndDecelerating:self];
                self.inAnimation = NO;
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.contentSize.width > self.frame.size.width) {
        if (self.contentOffset.x <= 0) {
            self.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width * 2, 0);
        } else if (self.contentOffset.x >= self.contentSize.width - self.frame.size.width) {
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
    } else {
        if (self.contentOffset.y <= 0) {
            self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height * 2);
        } else if (self.contentOffset.y >= self.contentSize.height - self.frame.size.height) {
            self.contentOffset = CGPointMake(0, self.frame.size.height);
        }
    }
}

@end

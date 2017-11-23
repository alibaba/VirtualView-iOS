//
//  NVCarouselPageView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "NVCarouselPageView.h"
#import "UIView+VirtualView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NVCarouselPageSubView: UIView

@property (nonatomic, strong) UIImageView *mainImageView;

//@property (nonatomic, strong) UIImageView *secondImageView;

@end

@implementation NVCarouselPageSubView

- (UIImageView *)mainImageView
{
    if (nil == _mainImageView) {
        _mainImageView = [[UIImageView alloc]init];
        _mainImageView.userInteractionEnabled = NO;
        [self addSubview:_mainImageView];
        
    }
    return _mainImageView;
}

//- (UIImageView *)secondImageView
//{
//    if (nil == _secondImageView) {
//        _secondImageView = [[UIImageView alloc]init];
//        _secondImageView.disableplaceHolder = YES;
//    }
//    return _secondImageView;
//}

-(void)loadData:(NSDictionary *)dict
{
    //加1很奇怪，临时先解决下向左偏移的问题
    self.mainImageView.frame = CGRectMake(11, 10, self.width-20, self.width-20);
    NSString *urlString = [dict objectForKey:@"imgUrl"];
    if (urlString && [urlString isKindOfClass:[NSString class]] == NO) {
        urlString = @"";
    }
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
}

@end

@interface NVCarouselPageView()

@property   (nonatomic, strong) UIView                       *contentView;
@property   (nonatomic, strong) NVCarouselPageSubView        *subViewA;
@property   (nonatomic, strong) NVCarouselPageSubView        *subViewB;
@property   (nonatomic, strong) NSDictionary                 *extraArgs;
@property   (nonatomic, strong) NSTimer                      *timer;

@end

@implementation NVCarouselPageView


- (UIView *)contentView
{
    if (nil == _contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(NVCarouselPageSubView *)subViewA
{
    if (nil == _subViewA && !CGSizeEqualToSize(self.contentView.frame.size, CGSizeZero))
    {
        _subViewA = [[NVCarouselPageSubView alloc] init];
        _subViewA.userInteractionEnabled = NO;
    }
    return _subViewA;
}

-(NVCarouselPageSubView *)subViewB
{
    if (nil == _subViewB && !CGSizeEqualToSize(self.contentView.frame.size, CGSizeZero))
    {
        _subViewB = [[NVCarouselPageSubView alloc] init];
        _subViewB.userInteractionEnabled = NO;
    }
    return _subViewB;
}
- (NSDictionary *)extraArgs
{
    if(nil == _extraArgs)
    {
        _extraArgs = [[NSDictionary alloc]init];
    }
    return _extraArgs;
}
- (void)calculateLayout
{
    if (self.data && 0 < self.data.count)
    {
        //去掉所有动画
        [self.contentView.layer removeAllAnimations];
        [self.subViewA.layer removeAllAnimations];
        [self.subViewB.layer removeAllAnimations];
        self.contentView.hidden = NO;
        self.contentView.frame = CGRectMake(0 , 0, self.width ,self.height);
        self.currentItemIndex = 0;
        self.subViewA.frame = self.contentView.bounds;
        NSDictionary *dict = [self.data objectAtIndex:0];
        if (dict && [dict isKindOfClass:[NSDictionary class]] == NO) {
            dict = nil;
        }
        [self.subViewA loadData:dict];
        NSString *string = [dict objectForKey:@"action"];
        if (string && [string isKindOfClass:[NSString class]]) {
            string = nil;
        }
        self.pageView.actionValue = string;
        
        self.subViewB.frame = self.contentView.bounds;
        
        dict = [self.data objectAtIndex:1];
        if (dict && [dict isKindOfClass:[NSDictionary class]] == NO) {
            dict = nil;
        }
        [self.subViewB loadData:dict];
        self.subViewA.top = self.contentView.top;
        self.subViewB.top = -self.contentView.height;
        [self.contentView addSubview:self.subViewA];
        [self.contentView addSubview:self.subViewB];

        self.contentView.width = self.subViewA.width > self.subViewB.width ? self.subViewA.width : self.subViewB.width;
        self.contentView.left = self.width - self.contentView.width - 1.f;
    }
    else
    {
        //如果没有itmes就不显示
        self.contentView.hidden = YES;
    }
}

- (void)beginCountdown
{
    if (!_isCountDown)
    {
        _isCountDown = YES;
        __weak typeof(self) weakSelf = self;
        //秒
        NSUInteger timeInterVal = 4;
        if (self.scrollInterval && [self.scrollInterval unsignedIntegerValue] > 0) {
            timeInterVal = [self.scrollInterval unsignedIntegerValue]/1000.f;
        }
        if (timeInterVal < 1) {
            timeInterVal = 1;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterVal repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf)
            {
                
                [UIView animateWithDuration:0.5 delay:self.animDelay options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                    if (strongSelf.subViewA.top == 0)
                    {
                        strongSelf.subViewA.top = strongSelf.subViewA.height;
                        strongSelf.subViewB.top = 0;
                    }
                    else
                    {
                        strongSelf.subViewA.top = 0;
                        strongSelf.subViewB.top = strongSelf.subViewA.height;
                    }
                } completion:^(BOOL finished) {
                    if (strongSelf.subViewA.top == 0)
                    {
                        strongSelf.subViewB.top = -strongSelf.contentView.height;
                    }
                    else
                    {
                        strongSelf.subViewA.top = -strongSelf.contentView.height;
                    }
                    
                    strongSelf.currentItemIndex += 1;
                    if (strongSelf.currentItemIndex >= self.data.count)
                    {
                        strongSelf.currentItemIndex = 0;
                    }
                    NSDictionary *dict = [self.data objectAtIndex:strongSelf.currentItemIndex];
                    if (dict && [dict isKindOfClass:[NSDictionary class]] == NO) {
                        dict = nil;
                    }
                    NSString *string = [dict objectForKey:@"action"];
                    if (string && [string isKindOfClass:[NSString class]]) {
                        string = nil;
                    }
                    self.pageView.actionValue = string;
                    self.pageView.superview.superview.actionValue = self.pageView.actionValue;
                    
                    NSUInteger nextIndex = strongSelf.currentItemIndex + 1;
                    if (nextIndex >= self.data.count)
                    {
                        nextIndex = 0;
                    }
                    
                    if (strongSelf.subViewA.top == 0)
                    {
                        NSDictionary *item = [self.data objectAtIndex:nextIndex];
                        if (item && [item isKindOfClass:[NSDictionary class]] == NO) {
                            item = nil;
                        }
                        [strongSelf.subViewB loadData:item];
                    }
                    else
                    {
                        NSDictionary *item = [self.data objectAtIndex:nextIndex];
                        if (item && [item isKindOfClass:[NSDictionary class]] == NO) {
                            item = nil;
                        }
                        [strongSelf.subViewA loadData:item];
                    }
                }];
            }
        }];
    }
}


-(void)endCountdown
{
    if (_isCountDown)
    {
        _isCountDown = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

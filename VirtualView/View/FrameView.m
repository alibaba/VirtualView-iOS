//
//  FrameView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "FrameView.h"

@implementation FrameView

- (id)init{
    self = [super init];
    if(self){
        self.lineWidth = 0;
        self.borderColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.lineWidth>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, self.lineWidth);//线的宽度

        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);//线框颜色

        CGRect rt = CGRectMake(0, 0, (int)self.frame.size.width, (int)self.frame.size.height);
        CGContextStrokeRect(context,rt);
        CGContextRestoreGState(context);
    }
}
@end

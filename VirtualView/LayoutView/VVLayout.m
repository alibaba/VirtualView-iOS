//
//  VVLayout.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVLayout.h"
#import "UIColor+VirtualView.h"

@interface VVLayout () <CALayerDelegate>
@property(assign, nonatomic)CGFloat borderWidth;
@end

@implementation VVLayout
@synthesize frame = _frame;
//- (void)layoutSubviews{
//    [super layoutSubviews];
//
//}

- (id)init{
    self = [super init];
    if (self) {
        //
        self.borderWidth=0.0f;
       self.borderColor=[UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
    BOOL ret = true;
    switch (key) {
        case STR_ID_onClick:
            //mClickCode = value;
            //                Log.d(TAG, "click value:" + mClickCode + " id:" + mId);
            break;
        case STR_ID_borderColor:
            //mSetDataCode = value;
           self.borderColor = [UIColor colorWithString:value];
            break;

        default:
            ret = false;
    }

    return ret;
}

- (void)drawRect:(CGRect)rect{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextFillRect(ctx, self.frame);
    //CGContextRestoreGState(ctx);
    for (VVViewObject* item in self.subViews) {
        if(item.visible==GONE){
            continue;
        }
        [item drawRect:rect];
    }
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx{
    //
    //    self.drawLayer.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.origin.y);
    //    self.drawLayer.anchorPoint=CGPointMake(0,0);
    //    self.drawLayer.position=CGPointMake(0,0);
    CGContextTranslateCTM(ctx, 0.0, _frame.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRef currentContext = ctx;//UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, self.borderColor.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, self.borderWidth);
    CGContextClearRect(ctx,CGRectMake(0, 0, _frame.size.width, _frame.size.height));
    CGContextStrokeRect(ctx,CGRectMake(0, 0, _frame.size.width, _frame.size.height));
    
    
    CGContextDrawPath(currentContext, kCGPathStroke);
    
    
    //    NSLog(@"################x:%f,y:%d",self.frame.origin.x,self.frame.origin.y);
    //    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.origin.x, 0, 100, 100));
    //    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    //    CGContextFillPath(ctx);
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    if (self.drawLayer) {
        self.drawLayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.drawLayer.anchorPoint=CGPointMake(0,0);
        self.drawLayer.position=CGPointMake(frame.origin.x,frame.origin.y);
        self.drawLayer.backgroundColor = self.backgroundColor.CGColor;
        [self.drawLayer setNeedsDisplay];
    }
}
- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    [super setUpdateDelegate:delegate];
    if (self.drawLayer==nil && self.borderColor>0) {
        self.drawLayer = [CALayer layer];
        self.drawLayer.drawsAsynchronously = YES;
        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.drawLayer.delegate = self;
        //[((UIView*)self.updateDelegate).layer addSublayer:self.drawLayer];
        [((UIView*)self.updateDelegate).layer insertSublayer:self.drawLayer atIndex:0];
    }
}

- (void)dataUpdateFinished{
    [self.drawLayer setNeedsDisplay];
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_borderWidth:
                self.borderWidth = value;
                break;
            case STR_ID_borderColor:
                self.borderColor = [UIColor colorWithHexValue:value];
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret = [ super setFloatValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_borderWidth:
                self.borderWidth = value;
                break;

            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (void)borderColorChange{
    [self.drawLayer setNeedsDisplay];
}
@end

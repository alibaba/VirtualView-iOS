//
//  VVLineView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVLineView.h"
#import "VVBinaryLoader.h"
#import "UIColor+VirtualView.h"
#if defined(__LP64__) && __LP64__
# define RATE 2
#else
# define RATE 1
#endif
@interface VVLineView ()<CALayerDelegate>
{
    //CGRect _frame;
}
@property(assign, nonatomic)NSUInteger lengthsCount;
@property(strong, nonatomic)NSString*  dashEffectString;
@property(strong, nonatomic)CALayer*   drawLayer;
@end

@implementation VVLineView
@synthesize frame = _frame;
- (id)init{
    self = [super init];
    if (self) {
        self.style = SOLID;
        self.lineWidth = 1.0f;
        self.lineColor = [UIColor blackColor];
        CGFloat arr[] = {3,1};
        NSUInteger size = sizeof(float)*2*RATE;
        self.lengths = malloc(size);
        memset(self.lengths, 0, size);
        self.lengthsCount = 2;
        CGFloat *pFloat = self.lengths;
        for (int i=0; i<2; i++) {
            *pFloat = arr[i];
            pFloat++;
        }
        self.orientation = HORIZONTAL;
    }
    return self;
}

- (void)setDashMemery{
    if (self.lengths!=nil) {
        free(self.lengths);
        self.lengths = nil;
    }
    NSUInteger size = sizeof(float)*self.lengthsCount*RATE;
    self.lengths = malloc(size);
    memset(self.lengths, 0, size);
}

- (void)createDashLengths{
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    NSString* newStr    = [self.dashEffectString stringByTrimmingCharactersInSet:set];
    NSArray*  array     = [newStr componentsSeparatedByString:@","];
    self.lengthsCount   = array.count;
    [self setDashMemery];
    CGFloat *pFloat = self.lengths;
    for (NSString* item in array) {
        CGFloat fv = [item floatValue];
        *pFloat=fv/2.0;
        pFloat++;
    }
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{

    switch (key) {
        case STR_ID_color:
            self.lineColor = [UIColor colorWithString:value];
            break;
            
        case STR_ID_dashEffect:
            self.dashEffectString = value;
            break;
    }
    return YES;
}

- (BOOL)setStringValue:(int)value forKey:(int)key{
    BOOL ret = [super setStringValue:value forKey:key];
    
    NSString* str = [[VVBinaryLoader shareInstance] getStrCodeWithType:value];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_color:
                self.lineColor = [UIColor colorWithHexValue:str.intValue];
                break;
                
            case STR_ID_dashEffect:
                self.dashEffectString = str;
                break;
                
            default:
                ret = false;
                break;
        }
    }
    return  ret;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
                
            case STR_ID_color:
                self.lineColor = [UIColor colorWithHexValue:value];
                break;
                
            case STR_ID_orientation:
                self.orientation = value;
                break;
                
            case STR_ID_paintWidth:
                self.lineWidth = value<=0?1:value;
                break;
            case STR_ID_style:
                self.style = value;
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

            case STR_ID_color:
                self.lineColor = [UIColor colorWithHexValue:value];
                break;

            case STR_ID_orientation:
                self.orientation = value;
                break;

            case STR_ID_paintWidth:
                self.lineWidth = value<=0?1:value;
                break;

            case STR_ID_style:
                self.style = value;
                break;

            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx{
    //
//    self.drawLayer.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.origin.y);
//    self.drawLayer.anchorPoint=CGPointMake(0,0);
//    self.drawLayer.position=CGPointMake(0,0);
    CGContextTranslateCTM(ctx, 0.0, 1);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRef currentContext = ctx;//UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, self.lineColor.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, self.lineWidth);
    
    if(self.orientation==HORIZONTAL){
        //
        //设置虚线绘制起点
        CGContextMoveToPoint(currentContext, self.frame.origin.x, 1);
        //设置虚线绘制终点
        CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, 1);
    }else{
        //设置虚线绘制起点
        CGContextMoveToPoint(currentContext, self.frame.origin.x, self.frame.origin.y);
        //设置虚线绘制终点
        CGContextAddLineToPoint(currentContext, self.frame.origin.x, self.frame.origin.y+self.frame.size.height);
    }
    
    if (self.style==DASH) {
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
        //下面最后一个参数“2”代表排列的个数。
        [self createDashLengths];
        CGContextSetLineDash(currentContext, 0, self.lengths, self.lengthsCount);
    }

    CGContextDrawPath(currentContext, kCGPathStroke);


//    NSLog(@"################x:%f,y:%d",self.frame.origin.x,self.frame.origin.y);
//    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.origin.x, 0, 100, 100));
//    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
//    CGContextFillPath(ctx);
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    self.drawLayer.bounds=CGRectMake(0, 0, frame.size.width, 1);
    self.drawLayer.anchorPoint=CGPointMake(0,0);
    self.drawLayer.position=CGPointMake(0,frame.origin.y);
    //[self.drawLayer setNeedsDisplay];
}
- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    if (self.drawLayer==nil) {
        self.drawLayer = [CALayer layer];
        self.drawLayer.drawsAsynchronously = YES;
        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.drawLayer.delegate = self;
        [self.drawLayer setNeedsDisplay];
        [((UIView*)delegate).layer addSublayer:self.drawLayer];
    }
    [super setUpdateDelegate:delegate];
}

- (void)setData:(NSData*)data{
    //
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    //
    //[dic objectForKey:self.dataTag];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.drawLayer setNeedsDisplay];
    });
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            //
            if (self.orientation==HORIZONTAL) {
                self.width = maxSize.width;//self.paddingRight+self.paddingLeft+self.width;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            
            break;
        case MATCH_PARENT:
            if (self.orientation==HORIZONTAL) {
                self.width=maxSize.width;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            
            break;
        default:
            if (self.orientation==HORIZONTAL) {
                self.width = self.widthModle+self.paddingRight+self.paddingLeft;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            if (self.orientation==HORIZONTAL) {
                self.height = self.lineWidth+self.paddingTop+self.paddingBottom;
            }else{
                self.height = maxSize.height;
            }
            
            break;
        case MATCH_PARENT:
            if (self.orientation==HORIZONTAL) {
                self.height = self.lineWidth+self.paddingTop+self.paddingBottom;
            }else{
                self.height = maxSize.height;
            }
            
            break;
        default:
            if (self.orientation==HORIZONTAL) {
                self.height = self.lineWidth+self.paddingTop+self.paddingBottom;
            }else{
                self.height = self.heightModle+self.paddingTop+self.paddingBottom;;
            }
            break;
    }
    [self autoDim];
    return CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
    
}
@end

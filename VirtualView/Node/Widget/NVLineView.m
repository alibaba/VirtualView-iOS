//
//  NVLineView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NVLineView.h"
#import "UIColor+VirtualView.h"

#if defined(__LP64__) && __LP64__
# define RATE 2
#else
# define RATE 1
#endif
@interface NVLineView ()<CALayerDelegate>
{
    //CGRect _frame;
}
@property(assign, nonatomic)NSUInteger lengthsCount;
@property(strong, nonatomic)NSString*  dashEffectString;
@property(strong, nonatomic)CALayer*   drawLayer;
@end

@implementation NVLineView
- (id)init{
    self = [super init];
    if (self) {
        self.cocoaView = [[UIView alloc] init];
        self.cocoaView.backgroundColor = [UIColor clearColor];
        self.style = VVLineStyleSolid;
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
        self.orientation = VVOrientationHorizontal;
    }
    return self;
}

- (void)dealloc
{
    if (self.drawLayer) {
        self.drawLayer.delegate = nil;
    }
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
            self.lineColor = [UIColor vv_colorWithString:value];
            break;
            
        case STR_ID_dashEffect:
            self.dashEffectString = value;
            break;
    }
    return YES;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret = [super setStringValue:value forKey:key];

    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_color:
                self.lineColor = [UIColor vv_colorWithString:value];
                break;
                
            case STR_ID_dashEffect:
                self.dashEffectString = value;
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
                self.lineColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
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
                self.lineColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
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

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    CGContextRef currentContext = ctx;
    CGContextSetStrokeColorWithColor(currentContext, self.lineColor.CGColor);
    CGContextSetLineWidth(currentContext, self.lineWidth);
    
    if(self.orientation==VVOrientationHorizontal){
        CGFloat centerY = CGRectGetHeight(layer.bounds) / 2;
        CGContextMoveToPoint(currentContext, 0, centerY);
        CGContextAddLineToPoint(currentContext, 0 + self.frame.size.width, centerY);
    }else{
        CGFloat centerX = CGRectGetWidth(layer.bounds) / 2;
        CGContextMoveToPoint(currentContext, centerX, 0);
        CGContextAddLineToPoint(currentContext, centerX, 0+self.frame.size.height);
    }
    
    if (self.style==VVLineStyleDash) {
        [self createDashLengths];
        CGContextSetLineDash(currentContext, 0, self.lengths, self.lengthsCount);
    }
    
    CGContextDrawPath(currentContext, kCGPathStroke);
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;
    self.cocoaView.frame = frame;
    self.drawLayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.drawLayer.anchorPoint=CGPointMake(0,0);
    //self.drawLayer.position=CGPointMake(0,frame.origin.y);
    [self.drawLayer setNeedsDisplay];
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    if (self.drawLayer==nil) {
        self.drawLayer = [CALayer layer];
        self.drawLayer.drawsAsynchronously = YES;
        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.drawLayer.delegate = self;
        [self.drawLayer setNeedsDisplay];
        [((UIView*)self.cocoaView).layer addSublayer:self.drawLayer];
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

- (void)layoutSubviews{

}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    
    switch ((int)self.widthModle) {
        case VV_WRAP_CONTENT:
            //
            if (self.orientation==VVOrientationHorizontal) {
                self.width = maxSize.width;//self.paddingRight+self.paddingLeft+self.width;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            
            break;
        case VV_MATCH_PARENT:
            if (self.orientation==VVOrientationHorizontal) {
                self.width=maxSize.width;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            
            break;
        default:
            if (self.orientation==VVOrientationHorizontal) {
                self.width = self.widthModle+self.paddingRight+self.paddingLeft;
            }else{
                self.width = self.lineWidth+self.paddingRight+self.paddingLeft;
            }
            break;
    }
    
    switch ((int)self.heightModle) {
        case VV_WRAP_CONTENT:
            //
            if (self.orientation==VVOrientationHorizontal) {
                self.height = self.lineWidth+self.paddingTop+self.paddingBottom;
            }else{
                self.height = maxSize.height;
            }
            
            break;
        case VV_MATCH_PARENT:
            if (self.orientation==VVOrientationHorizontal) {
                self.height = self.lineWidth+self.paddingTop+self.paddingBottom;
            }else{
                self.height = maxSize.height;
            }
            
            break;
        default:
            if (self.orientation==VVOrientationHorizontal) {
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

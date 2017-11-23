//
//  VVTextView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVTextView.h"
#import "VVBinaryLoader.h"
#import "UIColor+VirtualView.h"

@interface VVTextView (){
    CGSize _maxSize;
    int    _baseLine;
}
@property(nonatomic, assign)CGSize  textSize;
@end

@implementation VVTextView

- (id)init{
    self = [super init];
    if (self) {
        self.lines = 0;
    }
    return self;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
    
    switch (key) {
        case STR_ID_text:
            self.text = value;
            break;
        case STR_ID_typeface:
            break;
        case STR_ID_textSize:
            self.size = [value intValue];
            break;
        case STR_ID_textColor:
            self.color = [UIColor colorWithString:value];//[UIColor colorWithHexValue:[str intValue]];
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor colorWithString:value];
            break;
    }
    return YES;
}

-(BOOL)setStringValue:(int)value forKey:(int)key{
    BOOL ret = [super setStringValue:value forKey:key];
    
    NSString* str = [[VVBinaryLoader shareInstance] getStrCodeWithType:value];

    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_text:
                self.text = str;
                break;
            case STR_ID_typeface:
                break;
            case STR_ID_textSize:
                self.size = [str intValue];
                break;
            case STR_ID_textColor:
                self.color = [UIColor colorWithString:str];
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
            case STR_ID_textSize:
                self.size = value;
                break;
            case STR_ID_textColor:
                self.color = [UIColor colorWithHexValue:value];
                break;
            case STR_ID_textStyle:
                self.bold = value;
                break;
            case STR_ID_maxLines:
                self.lines = value;
                break;
            case STR_ID_lines:
                self.lines = value;
                break;
            case STR_ID_ellipsize:
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
            case STR_ID_textSize:
                self.size = value;
                break;
            case STR_ID_textColor:
                self.color = [UIColor colorWithHexValue:value];
                break;
            case STR_ID_lines:
                self.lines = value;
                break;
            case STR_ID_ellipsize:
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}


- (void)drawRect:(CGRect)rect{
    //
    CGFloat components[3];
    [self getRGBComponents:components forColor:self.color];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  components[0], components[1], components[2], 1.0);//设置填充颜色
    //self.color.CIColor.blue;
    UIFont  *font = self.bold?[UIFont boldSystemFontOfSize:self.size<=0?14:self.size]:[UIFont systemFontOfSize:self.size<=0?14:self.size];//设置
    
    CGSize textMaxRT = CGSizeMake(_maxSize.width-self.paddingLeft-self.paddingRight, _maxSize.height-self.paddingTop-self.paddingBottom);
    
    _textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSBaselineOffsetAttributeName:@(_baseLine),NSFontAttributeName:[UIFont systemFontOfSize:self.size]} context:nil].size;
    
    CGFloat pY =0, pX=0;
    
    if ((self.gravity & Gravity_BOTTOM)==Gravity_BOTTOM) {
        pY = pY+self.frame.size.height-self.paddingBottom-self.textSize.height;
    }else if ((self.gravity & Gravity_V_CENTER)==Gravity_V_CENTER){
        pY += (self.frame.size.height-self.paddingTop-self.paddingBottom-self.textSize.height)/2.0;
    }else{
        pY += self.paddingTop;
    }
    
    if ((self.gravity & Gravity_RIGHT)==Gravity_RIGHT) {
        pX += self.frame.size.width-self.paddingRight-self.textSize.width;
    }else if ((self.gravity & Gravity_H_CENTER)==Gravity_H_CENTER){
        pX += (self.frame.size.width-self.paddingLeft-self.paddingRight-self.textSize.width)/2.0;
    }else{
        pX = self.paddingLeft;
    }

    CGRect drawRT = CGRectMake(self.frame.origin.x+pX, self.frame.origin.y+pY, self.textSize.width, self.textSize.height);
//    UIGraphicsBeginImageContextWithOptions(drawRT.size, NO, 0.0);
    //[self.text drawInRect:drawRT withFont:font];
    [self.text drawInRect:drawRT withAttributes:@{NSBaselineOffsetAttributeName:@(_baseLine),NSFontAttributeName:font,NSForegroundColorAttributeName:self.color,NSBackgroundColorAttributeName:self.backgroundColor}];
//    UIGraphicsEndImageContext();
    //[self.text drawInRect:self.frame withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"key", nil]];
}


- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    //self.size = 12.0f;
    _maxSize = maxSize;
    _baseLine = 0;
    int singleHeight = 0;
   
    CGSize textMaxRT = CGSizeMake(_maxSize.width-self.paddingLeft-self.paddingRight, _maxSize.height-self.paddingTop-self.paddingBottom);
    
    CGSize realSize = [self.text boundingRectWithSize:CGSizeMake(textMaxRT.width, _maxSize.height*2) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.size]} context:nil].size;
    
    if (self.lines>0) {
        CGSize size = [self.text boundingRectWithSize:CGSizeMake(2048, _maxSize.height) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.size]} context:nil].size;
        singleHeight = size.height;
        int realHeight = realSize.height;
        if (realHeight>singleHeight*self.lines) {
            //int speace = textMaxRT.height - singleHeight*self.lines;
            _baseLine = -5;
        }
    }
    
    CGSize textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                 NSStringDrawingUsesLineFragmentOrigin |
                 NSStringDrawingUsesFontLeading attributes:@{NSBaselineOffsetAttributeName:@(_baseLine),NSFontAttributeName:[UIFont systemFontOfSize:self.size]} context:nil].size;

    _textSize.width = textSize.width +1;
    _textSize.height = textSize.height +1;
    
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            self.width = textSize.width+1;
            //self.width = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"obj",@"key", nil]].width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
        case MATCH_PARENT:
            self.width=maxSize.width;
            
            break;
        default:
             _textSize.width = self.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            self.height= textSize.height+1;
            //self.height= [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"obj",@"key", nil]].height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
        case MATCH_PARENT:
            self.height=maxSize.height;
            
            break;
        default:
            _textSize.height = self.height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
    }
    [self autoDim];

    return CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
    
}

- (void)setData:(NSData*)data{
    
    self.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
        UIFont  *font = self.bold?[UIFont boldSystemFontOfSize:self.size<=0?14:self.size]:[UIFont systemFontOfSize:self.size<=0?14:self.size];//设置
        //[self.text drawInRect:self.frame withFont:font];
        [self.text drawInRect:self.frame withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
    });
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    /*
    self.text = [dic objectForKey:self.dataTag];
    CGSize textMaxRT = CGSizeMake(_maxSize.width-self.paddingLeft-self.paddingRight, _maxSize.height-self.paddingTop-self.paddingBottom);
    _textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                 NSStringDrawingUsesLineFragmentOrigin |
                 NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.size]} context:nil].size;
    [self calculateLayoutSize:_maxSize];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.updateDelegate updateDisplayRect:self.frame];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
        UIFont  *font = [UIFont boldSystemFontOfSize:self.size];//设置
        [self.text drawInRect:self.frame withFont:font];
    });
    */
    switch (key) {
        case STR_ID_action:
            self.action = (NSString*)obj;
            break;

        case STR_ID_text:
            self.text = (NSString*)obj;
            break;

        case STR_ID_typeface:
            break;

        case STR_ID_textSize:
            self.size = [(NSNumber*)obj floatValue];
            break;

        case STR_ID_textColor:
            self.color = [UIColor colorWithHexValue:[(NSNumber*)obj unsignedIntegerValue]];
            break;

        case STR_ID_textStyle:
            break;

        case STR_ID_lines:
            self.lines = [(NSNumber*)obj intValue];;
            break;

        case STR_ID_ellipsize:
            break;
        default:
            break;
     /*
     //NSObject* valueObj = [dic objectForKey:valueVar];
     NSString* singleChar = [peroperty substringToIndex:0];
     NSString* bstr = [peroperty substringFromIndex:1];
     NSString* method = [NSString stringWithFormat:@"set%@%@:",[singleChar uppercaseString],bstr];
     SEL smthd = NSSelectorFromString(method);
     if ([self respondsToSelector:smthd]) {
     IMP imp = [self methodForSelector:smthd];
     void (*func)(id, SEL, NSObject*) = (void *)imp;
     func(self,smthd,valueObj);
     }
     */
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.updateDelegate updateDisplayRect:self.frame];
    });
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}
@end

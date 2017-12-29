//
//  NVImageView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "NVImageView.h"
#import "UIColor+VirtualView.h"
#import "VVCommTools.h"
#import "VVViewContainer.h"
#import "VVLayout.h"
#import "VVBinaryLoader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NVImageView (){
    //
}
@property(nonatomic, assign)CGSize   imageSize;
@property(assign, nonatomic)BOOL disableCache;
@property(nonatomic, strong)UIImageView   *imageView;
@property(nonatomic, strong)UIView   *maskView;
@property(nonatomic, strong)NSString *imgUrl;
@property(assign, nonatomic)CGFloat   ratio;
@property(assign, nonatomic)int       fixBy;
@property(strong, nonatomic)NSString* ck;
@property(assign, nonatomic)BOOL      inMainThread;
@end

@implementation NVImageView
- (id)init{
    self = [super init];
    if (self) {
        self.cocoaView = [[UIView alloc] init];
        self.cocoaView.hidden = YES;
        self.ratio = 0;
        self.fixBy = 0;
        self.ck    = nil;
        self.mutablePropertyDic = [[NSMutableDictionary alloc] init];
        NSArray* varList = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"inMainThread",@"varName",[NSNumber numberWithInt:-1],@"varIndex", nil], nil];
        NSDictionary* propertyInfo = [NSDictionary dictionaryWithObjectsAndKeys:varList,@"varValues",[NSNumber numberWithInt:TYPE_BOOLEAN],@"valueType", nil];
        NSNumber* propertyNum = [NSNumber numberWithUnsignedInteger:STR_ID_inmainthread];
        [self.mutablePropertyDic setObject:propertyInfo forKey:propertyNum];

        NSArray* varList2 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"ck",@"varName",[NSNumber numberWithInt:-1],@"varIndex", nil], nil];
        NSDictionary* propertyInfoCK = [NSDictionary dictionaryWithObjectsAndKeys:varList2,@"varValues",[NSNumber numberWithInt:TYPE_STRING],@"valueType", nil];
        NSNumber* propertyNumCK = [NSNumber numberWithUnsignedInteger:STR_ID_ck];
        [self.mutablePropertyDic setObject:propertyInfoCK forKey:propertyNumCK];
    }
    return self;
}

- (UIView *)maskView
{
    if(!_maskView)
    {
        _maskView = [[UIView alloc]init];
        _maskView.userInteractionEnabled = NO;
    }
    return _maskView;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [self.cocoaView addSubview:_imageView];
        [self.cocoaView addSubview:self.maskView];
    }

    return _imageView;
}

- (void)showImage{

    if ([self.imgUrl rangeOfString:@"//"].location==NSNotFound) {
        UIImage* image = [UIImage imageNamed:self.imgUrl];
        if (image) {
            self.imageView.image = image;
            self.cocoaView.hidden = NO;
        }
    }else{
        [self.imageView sd_cancelCurrentAnimationImagesLoad];
        if ([self.imgUrl isKindOfClass:[NSString class]] && self.imgUrl.length > 0) {
            self.cocoaView.hidden = NO;
            __weak typeof(NVImageView*) weakSelf = self;

            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]
                                     completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                __strong typeof(NVImageView*) strongSelf = weakSelf;
                if(strongSelf.classString!=nil && self.classString.length>0){
                    NSString* classString = @"VVCommTools";
                    Class cls = NSClassFromString(classString);
                    IMP imp = [cls methodForSelector:@selector(pixelColorFromImage:)];
                    UIColor* (*func)(id, SEL, UIImage*) = (void *)imp;
                    UIColor* color = func(strongSelf,@selector(pixelColorFromImage:),image);
                    VVLayout* virtualView = (VVLayout*)((VVViewContainer*)strongSelf.updateDelegate).virtualView;
                    virtualView.borderColor = color;
                }
            }];
        }else{
            self.cocoaView.hidden = YES;
        }
    }
}

- (void)layoutSubviews{

    self.cocoaView.frame = self.frame;
    self.imageView.frame = CGRectMake(self.paddingLeft, self.paddingTop, self.imageSize.width, self.imageSize.height);
    self.maskView.frame = self.cocoaView.bounds;
    [self showImage];
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            // NOT SUPPORT!
            break;
        case MATCH_PARENT:
            if (self.superview.widthModle==WRAP_CONTENT && self.superview.autoDimDirection==AUTO_DIM_DIR_NONE) {
                //_imageSize.width = maxSize.width;
                self.width = maxSize.width;//self.paddingRight+self.paddingLeft+_imageSize.width;
                _imageSize.width = self.width - self.paddingLeft - self.paddingRight;
                /*if (self.width>maxSize.width) {
                    self.width = maxSize.width;
                    _imageSize.width = self.width - self.paddingLeft - self.paddingRight;
                }*/
            }else{
                self.width=maxSize.width;
                _imageSize.width = self.width-self.paddingRight-self.paddingLeft;
            }
            break;
        default:
            _imageSize.width = self.widthModle-self.paddingRight-self.paddingLeft;
            self.width = self.widthModle;
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            // NOT SUPPORT
            break;
        case MATCH_PARENT:
            if (self.superview.heightModle==WRAP_CONTENT && self.superview.autoDimDirection==AUTO_DIM_DIR_NONE) {
                // NOT SUPPORT
            } else
            {
                self.height=maxSize.height;
                _imageSize.height = self.height-self.paddingTop-self.paddingBottom;
            }
            break;
        default:
            _imageSize.height = self.heightModle-self.paddingTop-self.paddingBottom;
            self.height = self.heightModle;
            break;
    }
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            _imageSize.height = _imageSize.width*(self.autoDimY/self.autoDimX);
            break;
        case AUTO_DIM_DIR_Y:
            _imageSize.height = _imageSize.width*(self.autoDimX/self.autoDimY);
        default:
            break;
    }
    [self autoDim];
    
    if (self.ratio>0) {
        if (self.fixBy==0) {
            self.height = self.width*self.ratio;
            _imageSize.height = _imageSize.width*self.ratio;
        }else{
            self.width = self.height*self.ratio;
            _imageSize.width = _imageSize.height*self.ratio;
        }
    }
    
    CGSize size = CGSizeMake(self.width<maxSize.width?self.width:maxSize.width, self.height<maxSize.height?self.height:maxSize.height);
    return size;
}

- (void)dataUpdateFinished{
    [self showImage];
}

- (BOOL)setStringValue:(int)value forKey:(int)key{
    BOOL ret  = [super setStringValue:value forKey:key];

    if (!ret) {
        ret = YES;
        NSString* str = [[VVBinaryLoader shareInstance] getStrCodeWithType:value];
        switch (key) {
            case STR_ID_src:
                self.imgUrl = str;
                break;
            case STR_ID_ck:
                self.ck = str;
                break;
            default:
                break;
        }
    }
    return ret;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        switch (key) {
            case STR_ID_disableCache:
                self.disableCache = value;
                break;
            case STR_ID_maskColor:
                self.maskView.backgroundColor = UIColorARGBWithHexValue(value);
                break;
            case STR_ID_itemHeight:
                self.height = value;
                break;
            case STR_ID_fixBy:
                self.fixBy = value;
                break;
            case STR_ID_inmainthread:
                self.inMainThread = value>0?YES:NO;
                break;
            default:
                break;
        }
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret  = [super setFloatValue:value forKey:key];
    if (!ret) {
        switch (key) {
            case STR_ID_itemHeight:
                self.height = value;
                break;
            case STR_ID_ratio:
                self.ratio = value;
            default:
                break;
        }
    }
    return ret;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
    
    switch (key) {
        case STR_ID_src:
            self.imgUrl = value;
            break;

        case STR_ID_ck:
            self.ck = value;
            break;
    }
    return YES;
}

- (void)setData:(NSData*)data{
    //
    ((UIImageView*)self.cocoaView).image = [UIImage imageWithData:data];
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    //
    switch (key) {
        case STR_ID_src:
            self.imgUrl = (NSString*)obj;
            break;
        case STR_ID_inmainthread:
            self.inMainThread = [(NSNumber*)obj boolValue];
            break;
        default:
            break;
    }

    /*
    __weak typeof(NVImageView*) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        __strong typeof(NVImageView*) strongSelf = weakSelf;
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        _imageSize.width = img.size.width/3.0;
        _imageSize.height = img.size.height/3.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            ((UIImageView*)strongSelf.cocoaView).image = img;
            
        });
    });
     */
}

- (void)reset
{
    [super reset];
    //self.imgUrl = @"";
    self.cocoaView.hidden = YES;
}
@end

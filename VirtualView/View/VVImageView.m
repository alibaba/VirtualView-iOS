//
//  VVImageView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVImageView.h"
#import "VVBinaryLoader.h"

@implementation VVLayerDelegate

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx {
    
    UIGraphicsPushContext(ctx);
    CGContextTranslateCTM(ctx, 0.0, self.delegateSource.frame.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGRect rt = CGRectMake(self.delegateSource.frame.origin.x+self.delegateSource.paddingLeft, self.delegateSource.frame.origin.y+self.delegateSource.paddingTop, self.delegateSource.frame.size.width, self.delegateSource.frame.size.height);
    
    CGContextDrawImage(ctx,rt,self.delegateSource.defaultImg.CGImage);
    
    UIGraphicsPopContext();
}

@end


@interface VVImageView ()<NSURLSessionDelegate>
{
    VVLayerDelegate* _layerDelegate;
    CALayer *myLayer;
}
@property(strong, nonatomic)void (^setDataBlock)(void);
@property(strong, nonatomic)NSString* url;
@property(strong, nonatomic)NSURLSession* urlSession;
@property(strong, nonatomic)NSURLSessionDownloadTask *downloadTask;
@end

@implementation VVImageView
@synthesize frame = _frame;
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
//    NSString* url = downloadTask.originalRequest.URL.absoluteString;
    self.defaultImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadURL]];
//    @synchronized (self) {
//        [[VVLoader shareInstance].cacheDic setObject:self.defaultImg forKey:url];
//    }
    if (self.downloadTask==downloadTask) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myLayer setNeedsDisplay];
        });
    }
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    myLayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
    myLayer.anchorPoint=CGPointMake(0,0);
    myLayer.position=CGPointMake(0,frame.origin.y);
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    if (myLayer==nil) {
        myLayer = [CALayer layer];
        myLayer.drawsAsynchronously = YES;
        myLayer.contentsScale = [[UIScreen mainScreen] scale];
        _layerDelegate = [[VVLayerDelegate alloc] init];
        myLayer.delegate = _layerDelegate;
        _layerDelegate.delegateSource = self;
        [myLayer setNeedsDisplay];
        [((UIView*)delegate).layer addSublayer:myLayer];
    }
    [super setUpdateDelegate:delegate];
}

-(id)init{
    self = [super init];
    if (self) {
//        _defaultImg = [UIImage imageNamed:@"xxx"];
        self.width  = _defaultImg.size.width;
        self.height = _defaultImg.size.height;
        __weak typeof(VVImageView*) weakSelf = self;
        self.setDataBlock = ^{
            // 耗时的操作
            __strong typeof(VVImageView*) strongSelf = weakSelf;
            strongSelf.defaultImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strongSelf.url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [strongSelf.updateDelegate updateDisplayRect:strongSelf.frame];
            });
        };
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{

    switch (key) {
        case STR_ID_src:
            self.imgUrl = value;
            self.defaultImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]];
            break;
    }
    return YES;
}

-(BOOL)setStringValue:(int)value forKey:(int)key{
    BOOL ret = [super setStringValue:value forKey:key];
    if (!ret) {
        switch (key) {
            case STR_ID_src:
                self.imgUrl = [[VVBinaryLoader shareInstance] getStrCodeWithType:key];
                self.defaultImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]];
                break;
                
            default:
                break;
        }
    }
    return  ret;
}

- (void)drawRect:(CGRect)rect{
    if (self.defaultImg==nil) {
//        self.defaultImg = [UIImage imageNamed:@"xxx"];
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            //
            _imageSize.width = _defaultImg.size.width/3.0;
            self.width = self.paddingRight+self.paddingLeft+_imageSize.width;
            break;
        case MATCH_PARENT:
            self.width = maxSize.width;

            break;
        default:
            _imageSize.width = self.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            _imageSize.height = _defaultImg.size.height/3.0;
            self.height = self.paddingTop+self.paddingBottom+_imageSize.height;
            break;
        case MATCH_PARENT:
            self.height = maxSize.height;

            break;
        default:
            _imageSize.height = self.height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
    }
    [self autoDim];
    return CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
    
}

- (void)setData:(NSData*)data{
    //
    self.imgUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.defaultImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_defaultImg drawInRect:self.frame];
    });
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    self.url = nil;
    switch (key) {
        case STR_ID_src:
            self.url = (NSString*)obj;
            break;
        default:
            self.url = nil;
            break;
    }
        
    
    NSRange rang = [self.url rangeOfString:@":"];
    if (rang.location==NSNotFound) {
        self.url = [NSString stringWithFormat:@"https:%@",self.url];
    }
//    UIImage* imgData = [[VVLoader shareInstance].cacheDic objectForKey:self.url];
//    if (imgData==nil) {
        NSURL *downloadURL = [NSURL URLWithString:self.url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadURL];
        self.downloadTask = [self.urlSession downloadTaskWithRequest:request];
        [self.downloadTask resume];
//    }else{
//        self.defaultImg = imgData;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [myLayer setNeedsDisplay];
//        });
//    }
}
@end

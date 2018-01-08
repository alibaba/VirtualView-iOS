//
//  VVViewFactory.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewFactory.h"
#import "VVBinaryLoader.h"
#import "VVCommTools.h"
#import "VVViewObject.h"
#import "VVViewContainer.h"
#import "VVTextView.h"
#import "VVImageView.h"
#import "VVGridLayout.h"
#import "VVVHLayout.h"
#import "VVSystemKey.h"

#define CODE_START_TAG 0
#define CODE_END_TAG 1

//****************************************************************

@implementation StringInfo

@end

//****************************************************************

@interface VVViewFactory()

@property (nonatomic, strong) VVBinaryLoader *loader;
@property(strong, nonatomic)NSMutableDictionary* stringDrawRectInfo;

@end


@implementation VVViewFactory

+ (VVViewFactory *)shareFactoryInstance
{
    static VVViewFactory *shareFactory_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFactory_ = [VVViewFactory new];
    });
    return shareFactory_;
}

- (id)init
{
    if (self = [super init]) {
        _loader = [VVBinaryLoader shareInstance];
        _stringDrawRectInfo = [[NSMutableDictionary alloc] init];

    }
    return self;
}

- (UIView *)obtainVirtualWithKey:(NSString *)key
{
    return [self obtainVirtualWithKey:key maxSize:CGSizeZero];
}

- (UIView *)obtainVirtualWithKey:(NSString *)key maxSize:(CGSize)size
{
    NSMutableArray *dataTagObjs = [[NSMutableArray alloc] init];
    
    VVViewObject *vv = [self parseWidgetWithTypeID:key collection:dataTagObjs];
    
    VVViewContainer *vvc = [[VVViewContainer alloc] initWithVirtualView:vv];
    vvc.dataTagObjs = dataTagObjs;
    [vvc attachViews];
    return vvc;
}

- (StringInfo*)getDrawStringInfo:(NSString*)value andFrontSize:(CGFloat)size{
    NSDictionary* stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    StringInfo* info =[stringInfoDic objectForKey:[NSNumber numberWithFloat:size]];
    //StringInfo* info = [self.stringDrawRectInfo objectForKey:value];
    return info;
}

- (void)setDrawStringInfo:(StringInfo*)strInfo forString:(NSString*)value frontSize:(CGFloat)size{
    
    NSMutableDictionary* stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    if (stringInfoDic) {
        [stringInfoDic setObject:strInfo forKey:[NSNumber numberWithFloat:size]];
    }else{
        NSMutableDictionary* stringInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strInfo,[NSNumber numberWithFloat:size], nil];
        //NSDictionary* stringInfoDic = [NSMulDictionary dictionaryWithObjectsAndKeys:strInfo,[NSNumber numberWithFloat:size], nil];
        [self.stringDrawRectInfo setObject:stringInfoDic forKey:value];
    }
}

- (VVViewObject *)parseWidgetWithTypeID:(NSString *)key collection:(NSMutableArray *)dataTagObjs
{
    NSMutableArray *viewStacks;
    VVViewObject *widget, *tmpv;
    int   dataLength;
    short tag = 0;
    int   pos = 0;

    NSData *widgetData = [self.loader getUICodeWithName:key];
    dataLength = (int)widgetData.length;
    
    [widgetData getBytes:&tag range:NSMakeRange(pos, 1)];
    
    if (tag != CODE_START_TAG) {
        return nil;
    } else {
        viewStacks = [[NSMutableArray alloc] init];
    }
    while (pos < dataLength) {
        pos++;
        switch (tag) {
            case CODE_START_TAG:
                if (widget) {
                    [viewStacks addObject:widget];
                }
                widget = [self parseWithData:widgetData currentPos:&pos];
                
                break;
            case CODE_END_TAG:
                tmpv = [viewStacks lastObject];
                if (tmpv != nil && widget != nil && tmpv != widget) {
                    [tmpv addSubview:widget];
                    if (widget.mutablePropertyDic.count > 0) {
                        [dataTagObjs addObject:widget];
                    }
                    widget = tmpv;
                    [viewStacks removeObject:tmpv];
                }
                
                break;
            default:
                break;
        }
        if (pos < dataLength) {
            [widgetData getBytes:&tag range:NSMakeRange(pos, 1)];
        }
    }
    if (widget.mutablePropertyDic.count > 0) {
        [dataTagObjs addObject:widget];
    }
    return widget;
}

- (VVViewObject *)makeWidgetWithID:(short)widgetid
{
    VVViewObject *widget;
    NSString *className = [[VVSystemKey shareInstance] classNameForIndex:widgetid];
    Class cls = NSClassFromString(className);
    widget = [[cls alloc] init];
    return widget;
}

- (VVViewObject *)parseWithData:(NSData *)widgetData currentPos:(int *)pos
{
    short widgetid = 0;
    [widgetData getBytes:&widgetid range:NSMakeRange(*pos, 2)];
    [VVCommTools convertShortToLittleEndian:&widgetid];
    *pos += 2;
    VVViewObject *tempV = [self makeWidgetWithID:widgetid];
    if (tempV == nil) {
        tempV = [[VVViewObject alloc] init];
    }
    short countInt = 0;
    [widgetData getBytes:&countInt range:NSMakeRange(*pos, 1)];
    (*pos)++;

    for (int i = 0; i < countInt; i++) {
        int key = 0;
        int value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;

        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&value];
        *pos += 4;

        [tempV setIntValue:value forKey:key];
    }

    short countApInt = 0;
    [widgetData getBytes:&countApInt range:NSMakeRange(*pos, 1)];
    (*pos)++;

    for (int i = 0; i < countApInt; i++) {
        int key = 0;
        int value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;

        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&value];
        *pos += 4;

        value = value * [[VVSystemKey shareInstance] rate];
        [tempV setIntValue:value forKey:key];
    }

    short countFloat = 0;
    [widgetData getBytes:&countFloat range:NSMakeRange(*pos, 1)];
    (*pos)++;

    for (int i = 0; i < countFloat; i++) {
        int key = 0;
        float value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;

        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:(int *)&value];
        *pos += 4;

        [tempV setFloatValue:value forKey:key];
    }

    short countApFloat = 0;
    [widgetData getBytes:&countApFloat range:NSMakeRange(*pos, 1)];
    (*pos)++;
    
    for (int i = 0; i < countApFloat; i++) {
        int key = 0;
        float value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;

        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:(int *)&value];
        *pos += 4;

        value = value * [[VVSystemKey shareInstance] rate];
        [tempV setFloatValue:value forKey:key];
    }


    short countString = 0;
    [widgetData getBytes:&countString range:NSMakeRange(*pos, 1)];
    (*pos)++;
    
    for (int i = 0; i < countString; i++) {
        int key = 0;
        int value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;
        
        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&value];
        *pos += 4;
        
        NSString *stringValue = [[VVBinaryLoader shareInstance] getStrCodeWithType:value];
        [tempV setStringValue:stringValue forKey:key];
    }
    
    
    short countExpr = 0;
    [widgetData getBytes:&countExpr range:NSMakeRange(*pos, 1)];
    (*pos)++;
    
    for (int i = 0; i < countExpr; i++) {
        int key = 0;
        int value = 0;
        [widgetData getBytes:&key range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&key];
        *pos += 4;
        
        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&value];
        *pos += 4;

        [tempV setExprossValue:value forKey:key];
    }
    
    short countUser = 0;
    [widgetData getBytes:&countUser range:NSMakeRange(*pos, 1)];
    (*pos)++;
    
    for (int i = 0; i < countUser; i++) {
        short type = 0;
        int name = 0;
        int value = 0;
        [widgetData getBytes:&type range:NSMakeRange(*pos, 1)];
        [VVCommTools convertShortToLittleEndian:&type];
        *pos += 1;
        
        [widgetData getBytes:&name range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&name];
        *pos += 4;
        
        [widgetData getBytes:&value range:NSMakeRange(*pos, 4)];
        [VVCommTools convertIntToLittleEndian:&value];
        *pos += 4;
    }
    return tempV;
}

@end

//
//  VVViewFactory.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVViewFactory.h"
#import "VVViewContainer.h"
#import "VVViewObject.h"
#import "VVTemplateManager.h"

//****************************************************************

@implementation StringInfo

@end

//****************************************************************

@interface VVViewFactory ()

@property (nonatomic, strong)NSMutableDictionary *stringDrawRectInfo;

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
        _stringDrawRectInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (StringInfo *)getDrawStringInfo:(NSString *)value andFrontSize:(CGFloat)size
{
    NSDictionary *stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    StringInfo *info = [stringInfoDic objectForKey:@(size)];
    return info;
}

- (void)setDrawStringInfo:(StringInfo *)strInfo forString:(NSString *)value frontSize:(CGFloat)size
{
    NSMutableDictionary *stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    if (stringInfoDic) {
        [stringInfoDic setObject:strInfo forKey:@(size)];
    } else {
        NSMutableDictionary *stringInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strInfo, [NSNumber numberWithFloat:size], nil];
        [self.stringDrawRectInfo setObject:stringInfoDic forKey:value];
    }
}

- (VVViewContainer *)obtainVirtualWithKey:(NSString *)key
{
    NSMutableArray *dataTagObjs = [[NSMutableArray alloc] init];
    
    VVViewObject *vv = [self parseWidgetWithTypeID:key collection:dataTagObjs];
    
    VVViewContainer *vvc = [[VVViewContainer alloc] initWithVirtualView:vv];
    vvc.dataTagObjs = dataTagObjs;
    [vvc attachViews];
    return vvc;
}

- (VVViewObject *)parseWidgetWithTypeID:(NSString *)key collection:(NSMutableArray *)dataTagObjs
{
    VVViewObject *node = [[VVTemplateManager sharedManager] createNodeTreeForType:key];
    [self getDataTagObjsHelper:node collection:dataTagObjs];
    return node;
}

- (void)getDataTagObjsHelper:(VVViewObject *)node collection:(NSMutableArray *)dataTagObjs
{
    if (node.mutablePropertyDic.count > 0) {
        [dataTagObjs addObject:node];
    }
    for (VVViewObject *subNode in node.subViews) {
        [self getDataTagObjsHelper:subNode collection:dataTagObjs];
    }
}

@end

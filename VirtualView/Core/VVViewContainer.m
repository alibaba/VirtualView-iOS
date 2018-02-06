//
//  VVViewContainer.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVViewContainer.h"
#import "VVLayout.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"
#ifdef VV_ALIBABA
#import <UT/AppMonitor.h>
#endif

@interface VVViewContainer() {
    UILongPressGestureRecognizer* _pressRecognizer;
}
@property(nonatomic, strong)NSMutableArray *dataTagObjs;
@property(weak, nonatomic)NSObject*            updateDataObj;
@end

@implementation VVViewContainer

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type
{
    VVBaseNode *vv = [[VVTemplateManager sharedManager] createNodeTreeForType:type];
    VVViewContainer *vvc = [[VVViewContainer alloc] initWithVirtualView:vv];
    [vvc attachViews];
    return vvc;
}

- (void)updateDisplayRect:(CGRect)rect{

}

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint pt =[gestureRecognizer locationInView:self];
    VVBaseNode *vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [vvobj isLongClickable]) {
        [self.delegate subViewLongPressed:vvobj.action andValue:vvobj.actionValue gesture:gestureRecognizer];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch =  [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    VVBaseNode *vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [vvobj isClickable]) {
        if([self.delegate respondsToSelector:@selector(subView:clicked:andValue:)])
        {
            [self.delegate subView:vvobj clicked:vvobj.action andValue:vvobj.actionValue];
        }
        else if([self.delegate respondsToSelector:@selector(subViewClicked:andValue:)])
        {
            [self.delegate subViewClicked:vvobj.action andValue:vvobj.actionValue];
        }
    }else{
        [super touchesEnded:touches withEvent:event];
    }
}

- (id)initWithVirtualView:(VVBaseNode*)virtualView
{
#ifdef VV_ALIBABA
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [VVViewContainer registerAppMoniter];
    });
#endif
    self = [super init];
    if (self) {
        self.virtualView = virtualView;
        self.virtualView.rootCocoaView = self;
        self.virtualView.rootCanvasLayer = self.layer;
        self.backgroundColor = [UIColor clearColor];
        _dataTagObjs = [NSMutableArray array];
        [VVViewContainer getDataTagObjsHelper:virtualView collection:_dataTagObjs];
        if ([self.virtualView isLongClickable]) {
            _pressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
            [self addGestureRecognizer:_pressRecognizer];
        }
    }
    return self;
}

- (void) attachViews {
    [self attachViews:self.virtualView];
}

- (void) attachViews:(VVBaseNode*)virtualView {
    
    if ([virtualView isKindOfClass:VVLayout.class]) {
        for (VVLayout* item in virtualView.subViews) {
            [self attachViews:item];
        }
    } else if(virtualView.cocoaView && virtualView.visibility!=VVVisibilityGone) {
        [self addSubview:virtualView.cocoaView];
    }
}

- (void)update:(NSObject*)obj{
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    
#ifdef VV_ALIBABA
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
#endif
    
    NSDictionary* jsonData = (NSDictionary*)obj;
    for (VVBaseNode* item in self.dataTagObjs) {
        [item reset];

        for (VVPropertyExpressionSetter *setter in item.expressionSetters.allValues) {
            if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                [setter applyToNode:item withDict:jsonData];
            }
        }
        item.actionValue = [jsonData objectForKey:item.action];
        
        [item didFinishBinding];
    }
    self.virtualView.nodeFrame = self.bounds;
    [self.virtualView layoutSubnodes];
    [self setNeedsDisplay];
    
#ifdef VV_ALIBABA
    NSTimeInterval costTime = [NSDate date].timeIntervalSince1970 - startTime;
    [self.class commitAppMoniterForBindData:[jsonData objectForKey:@"type"] costTime:costTime];
#endif
}

- (VVBaseNode*)findObjectByID:(int)tagid{
    VVBaseNode* obj=[self.virtualView findViewByID:tagid];
    return obj;
}

+ (void)getDataTagObjsHelper:(VVBaseNode *)node collection:(NSMutableArray *)dataTagObjs
{
    if (node.expressionSetters.count > 0) {
        [dataTagObjs addObject:node];
    }
    for (VVBaseNode *subNode in node.subViews) {
        [self getDataTagObjsHelper:subNode collection:dataTagObjs];
    }
}

#pragma mark AppMoniter

#ifdef VV_ALIBABA
+ (void)registerAppMoniter
{
    AppMonitorMeasureSet *measureSet = [AppMonitorMeasureSet new];
    [measureSet addMeasureWithName:@"costTime"];
    AppMonitorDimensionSet *dimensionSet = [AppMonitorDimensionSet new];
    [dimensionSet addDimensionWithName:@"type"];
    [AppMonitorStat registerWithModule:@"VirtualView"
                          monitorPoint:@"bindData"
                            measureSet:measureSet
                          dimensionSet:dimensionSet];
}

+ (void)commitAppMoniterForBindData:(NSString *)type costTime:(NSTimeInterval)costTime
{
    AppMonitorDimensionValueSet *dValueSet = [AppMonitorDimensionValueSet new];
    [dValueSet setValue:(type ?: @"unknown") forName:@"type"];
    AppMonitorMeasureValueSet *mValueSet = [AppMonitorMeasureValueSet new];
    [mValueSet setDoubleValue:costTime forName:@"costTime"];
    [AppMonitorStat commitWithModule:@"VirtualView"
                        monitorPoint:@"bindData"
                   dimensionValueSet:dValueSet
                     measureValueSet:mValueSet];
}
#endif

@end

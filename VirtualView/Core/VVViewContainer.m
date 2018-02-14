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
#import "VVConfig.h"
#ifdef VV_ALIBABA
#import <UT/AppMonitor.h>
#endif

#define VV_LONG_PRESS_CANCEL_DISTANCE 20

@interface VVViewContainer() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *nodesWithExpression;
@property (nonatomic, weak) id lastData;
@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation VVViewContainer

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type
{
    return [self viewContainerWithTemplateType:type alwaysRefresh:VVConfig.alwaysRefresh];
}

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type alwaysRefresh:(BOOL)alwaysRefresh
{
    VVBaseNode *rootNode = [[VVTemplateManager sharedManager] createNodeTreeForType:type];
    return [[VVViewContainer alloc] initWithRootNode:rootNode alwaysRefresh:alwaysRefresh];
}

- (instancetype)initWithRootNode:(VVBaseNode *)rootNode
{
    return [self initWithRootNode:rootNode alwaysRefresh:VVConfig.alwaysRefresh];
}

- (instancetype)initWithRootNode:(VVBaseNode *)rootNode alwaysRefresh:(BOOL)alwaysRefresh
{
#ifdef VV_ALIBABA
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [VVViewContainer registerAppMoniter];
    });
#endif
    if (self = [super init]) {
        _alwaysRefresh = alwaysRefresh;
        _lastData = self;
        _rootNode = rootNode;
        _rootNode.rootCanvasLayer = self.layer;
        _rootNode.rootCocoaView = self;
        if (alwaysRefresh == NO) {
            [_rootNode setupLayoutAndResizeObserver];
        }
        _nodesWithExpression = [VVViewContainer nodesWithExpression:_rootNode];
        self.backgroundColor = [UIColor clearColor];
        if ([_rootNode isClickable]) {
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
            tapGes.delegate = self;
            [self addGestureRecognizer:tapGes];
        }
        if ([_rootNode isLongClickable]) {
            UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
            longPressGes.delegate = self;
            [self addGestureRecognizer:longPressGes];
        }
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)gestureHandler:(UIGestureRecognizer *)gesture
{
    if (self.delegate == nil) {
        return;
    }
    
    BOOL isClick = NO;
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && gesture.state == UIGestureRecognizerStateEnded) {
        isClick = YES;
    }

    BOOL isLongClick = NO;
    if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            CGPoint point = [gesture locationInView:self];
            if (ABS(point.x - self.startPoint.x) < VV_LONG_PRESS_CANCEL_DISTANCE
                && ABS(point.y - self.startPoint.y) < VV_LONG_PRESS_CANCEL_DISTANCE) {
                isLongClick = YES;
            }
        } else if (gesture.state == UIGestureRecognizerStateBegan) {
            self.startPoint = [gesture locationInView:self];
        }
    }

    if (isClick || isLongClick) {
        CGPoint point = [gesture locationInView:self];
        VVBaseNode *clickedNode = [self.rootNode hitTest:point];
        if (clickedNode) {
            if (isClick) {
                if ([self.delegate respondsToSelector:@selector(subView:clicked:andValue:)]) {
                    [self.delegate subView:clickedNode clicked:clickedNode.action andValue:clickedNode.actionValue];
                }
                if ([self.delegate respondsToSelector:@selector(subViewClicked:andValue:)]) {
                    [self.delegate subViewClicked:clickedNode.action andValue:clickedNode.actionValue];
                }
            }
            if (isLongClick && [self.delegate respondsToSelector:@selector(subViewLongPressed:andValue:gesture:)]) {
                [self.delegate subViewLongPressed:clickedNode.action andValue:clickedNode.actionValue gesture:gesture];
            }
        }
    }
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [self.rootNode setNeedsResize];
    return [self.rootNode calculateSize:maxSize];
}

- (void)update:(id)data
{
    if (data == self.lastData) {
        return;
    }
    self.lastData = data;
    
#ifdef VV_ALIBABA
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
#endif
    
    for (VVBaseNode *node in _nodesWithExpression) {
        [node reset];

        for (VVPropertyExpressionSetter *setter in node.expressionSetters.allValues) {
            if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                [setter applyToNode:node withObject:data];
            }
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)data;
            node.actionValue = [dict objectForKey:node.action];
        }
        
        [node didUpdated];
    }
    
    if (self.alwaysRefresh) {
        [self.rootNode setNeedsLayoutAndResizeRecursively];
    }
    self.rootNode.nodeX = self.rootNode.nodeY = 0;
    if (self.rootNode.nodeWidth != self.bounds.size.width || self.rootNode.nodeHeight != self.bounds.size.height) {
        [self.rootNode setNeedsResize];
        self.rootNode.nodeWidth = self.bounds.size.width;
        self.rootNode.nodeHeight = self.bounds.size.height;
    }
    [self.rootNode updateHidden];
    [self.rootNode updateFrame];
    [self.rootNode layoutSubNodes];
    [self setNeedsDisplay];
    
#ifdef VV_ALIBABA
    NSTimeInterval costTime = [NSDate date].timeIntervalSince1970 - startTime;
    [self.class commitAppMoniterForBindData:[jsonData objectForKey:@"type"] costTime:costTime];
#endif
}

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID
{
    return [self.rootNode nodeWithID:nodeID];
}

+ (NSArray *)nodesWithExpression:(VVBaseNode *)rootNode
{
    NSMutableArray *result = [NSMutableArray array];
    [self private_nodesWithExpression:rootNode result:result];
    return [result copy];
}

+ (void)private_nodesWithExpression:(VVBaseNode *)node result:(NSMutableArray *)result
{
    if (node.expressionSetters.count > 0) {
        [result addObject:node];
    }
    for (VVBaseNode *subNode in node.subNodes) {
        [self private_nodesWithExpression:subNode result:result];
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

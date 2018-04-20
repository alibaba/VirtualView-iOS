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

@interface VVViewContainer()

@property (nonatomic, strong) NSArray *variableNodes;
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
        _variableNodes = [VVViewContainer variableNodes:_rootNode];
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGes;
        if ([_rootNode containsClickable]) {
            tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
            [self addGestureRecognizer:tapGes];
        }
        UILongPressGestureRecognizer *longPressGes;
        if ([_rootNode containsLongClickable]) {
            longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
            [self addGestureRecognizer:longPressGes];
        }
        if (tapGes && longPressGes) {
            [tapGes requireGestureRecognizerToFail:longPressGes];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; frame = %@; type = %@; rootNode = %p>", self.class, self, NSStringFromCGRect(self.frame), self.rootNode.templateType, self.rootNode];
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
    if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]] && gesture.state == UIGestureRecognizerStateBegan) {
        isLongClick = YES;
    }

    if (isClick || isLongClick) {
        CGPoint point = [gesture locationInView:self];
        VVBaseNode *clickedNode = [self.rootNode hitTest:point];
        if (clickedNode) {
            if (isClick) {
                if ([self.delegate respondsToSelector:@selector(virtualView:clickedWithAction:andValue:)]) {
                    [self.delegate virtualView:clickedNode clickedWithAction:clickedNode.action andValue:clickedNode.actionValue];
                } else if ([self.delegate respondsToSelector:@selector(virtualViewClickedWithAction:andValue:)]) {
                    [self.delegate virtualViewClickedWithAction:clickedNode.action andValue:clickedNode.actionValue];
                }
            }
            if (isLongClick) {
                if ([self.delegate respondsToSelector:@selector(virtualView:longPressedWithAction:andValue:)]) {
                    [self.delegate virtualView:clickedNode longPressedWithAction:clickedNode.action andValue:clickedNode.actionValue];
                } else if ([self.delegate respondsToSelector:@selector(virtualViewLongPressedWithAction:andValue:)]) {
                    [self.delegate virtualViewLongPressedWithAction:clickedNode.action andValue:clickedNode.actionValue];
                }
            }
        }
    }
}

- (CGSize)estimatedSize:(CGSize)maxSize
{
    [self.rootNode setNeedsResize];
    return [self.rootNode calculateSize:maxSize];
}

- (CGSize)establishedSize:(CGSize)maxSize
{
    if (self.rootNode.layoutWidth != VV_WRAP_CONTENT && self.rootNode.layoutHeight != VV_WRAP_CONTENT) {
        [self.rootNode setNeedsResize];
        return [self.rootNode calculateSize:maxSize];
    }
    return CGSizeZero;
}

- (CGSize)establishedSize
{
    if (self.rootNode.layoutWidth != VV_WRAP_CONTENT && self.rootNode.layoutHeight != VV_WRAP_CONTENT) {
        [self.rootNode setNeedsResize];
        return [self.rootNode calculateSize:CGSizeZero];
    }
    return CGSizeZero;
}

- (void)update:(id)data
{
#ifdef VV_ALIBABA
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
#endif
    
    [self updateData:data];
    [self updateLayout];
    
#ifdef VV_ALIBABA
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSTimeInterval costTime = [NSDate date].timeIntervalSince1970 - startTime;
        NSDictionary *dict = (NSDictionary *)data;
        [self.class commitAppMoniterForBindData:[dict objectForKey:@"type"] costTime:costTime];
    }
#endif
}

- (void)updateData:(id)data
{
    if (data != self.lastData) {
        self.lastData = data;
        
        for (VVBaseNode *node in _variableNodes) {
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
    }
}

- (void)updateLayout
{
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
}

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID
{
    return [self.rootNode nodeWithID:nodeID];
}

+ (NSArray *)variableNodes:(VVBaseNode *)rootNode
{
    NSMutableArray *result = [NSMutableArray array];
    [self private_variableNodes:rootNode result:result];
    return [result copy];
}

+ (void)private_variableNodes:(VVBaseNode *)node result:(NSMutableArray *)result
{
    if (node.expressionSetters.count > 0 || (node.action && node.action.length > 0)) {
        [result addObject:node];
    }
    for (VVBaseNode *subNode in node.subNodes) {
        [self private_variableNodes:subNode result:result];
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

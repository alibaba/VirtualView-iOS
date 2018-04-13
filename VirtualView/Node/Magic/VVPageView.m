//
//  VVPageView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPageView.h"
#import "VVViewContainer.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"
#import "VVLoopingScrollView.h"

@interface VVPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) VVLoopingScrollView *scrollView;
@property (nonatomic, weak) id lastData;
@property (nonatomic, assign, readwrite) CGRect nodeFrame;

@end


@implementation VVPageView

@synthesize rootCocoaView = _rootCocoaView, rootCanvasLayer = _rootCanvasLayer;
@synthesize nodeFrame;

- (id)init
{
    if (self = [super init]) {
        _lastData = self;
        _scrollView = [[VVLoopingScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.stayTime = 2;
        _scrollView.autoSwitchTime = 0.5;
        _orientation = VVOrientationVertical;
        _canSlide = YES;
        _stayTime = 2;
        _autoSwitchTime = 0.5;
    }
    return self;
}

- (UIView *)cocoaView
{
    return _scrollView;
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    _rootCocoaView = rootCocoaView;
    if (self.cocoaView.superview !=  rootCocoaView) {
        if (self.cocoaView.superview) {
            [self.cocoaView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.cocoaView];
    }
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    _rootCanvasLayer = rootCanvasLayer;
    if (self.canvasLayer) {
        if (self.canvasLayer.superlayer) {
            [self.canvasLayer removeFromSuperlayer];
        }
        [rootCanvasLayer addSublayer:self.canvasLayer];
    }
}

- (void)setCanSlide:(BOOL)canSlide
{
    _canSlide = canSlide;
    _scrollView.scrollEnabled = canSlide;
}

- (void)setAutoSwitch:(BOOL)autoSwitch
{
    _autoSwitch = autoSwitch;
    _scrollView.autoSwitch = autoSwitch;
}

- (void)setStayTime:(NSTimeInterval)stayTime
{
    _stayTime = stayTime;
    _scrollView.stayTime = stayTime;
}

- (void)setAutoSwitchTime:(NSTimeInterval)autoSwitchTime
{
    _autoSwitchTime = autoSwitchTime;
    _scrollView.autoSwitchTime = autoSwitchTime;
}

- (VVBaseNode *)hitTest:(CGPoint)point
{
    if (self.visibility == VVVisibilityVisible
        && CGRectContainsPoint(self.nodeFrame, point)) {
        if (self.subNodes.count > 0) {
            point.x -= self.nodeFrame.origin.x - self.scrollView.contentOffset.x;
            point.y -= self.nodeFrame.origin.y - self.scrollView.contentOffset.y;
            for (VVBaseNode* subNode in [self.subNodes reverseObjectEnumerator]) {
                VVBaseNode *hitNode = [subNode hitTest:point];
                if (hitNode) {
                    return hitNode;
                }
            }
        }
        if ([self isClickable] || [self isLongClickable]) {
            return self;
        }
    }
    return nil;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_stayTime:
                self.stayTime = value / 1000.0;
                break;
            case STR_ID_autoSwitch:
                self.autoSwitch = value != 0;
                break;
            case STR_ID_autoSwitchTime:
                self.autoSwitchTime = value / 1000.0;
                break;
            case STR_ID_canSlide:
                self.canSlide = value != 0;
                break;
            case STR_ID_orientation:
                self.orientation = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key
{
    if (key == STR_ID_dataTag) {
        if (obj != _lastData && [obj isKindOfClass:[NSArray class]]) {
            _lastData = obj;
            
            // For reusing feature.
            NSMutableArray *unusedNodes = [self.subNodes mutableCopy];
            // Dup the fisrt and last object.
            NSMutableArray *dataArray = [(NSArray *)obj mutableCopy];
            [dataArray insertObject:[[dataArray lastObject] copy] atIndex:0];
            [dataArray addObject:[[dataArray objectAtIndex:1] copy]];
            // Create subnodes as usual.
            for (NSDictionary *itemData in dataArray) {
                if ([itemData isKindOfClass:[NSDictionary class]] == NO
                    || [itemData.allKeys containsObject:@"type"] == NO) {
                    continue;
                }
                NSString *nodeType = [itemData objectForKey:@"type"];
                VVBaseNode *node = [VVPageView popReuseableNodeWithType:nodeType fromUnusedNodes:unusedNodes];
                if (!node) {
                    node = [[VVTemplateManager sharedManager] createNodeTreeForType:nodeType];
                }
                NSArray *variableNodes = [VVViewContainer variableNodes:node];
                for (VVBaseNode *variableNode in variableNodes) {
                    [variableNode reset];
                    
                    for (VVPropertyExpressionSetter *setter in variableNode.expressionSetters.allValues) {
                        if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                            [setter applyToNode:variableNode withObject:itemData];
                        }
                    }
                    variableNode.actionValue = [itemData objectForKey:variableNode.action];
                    
                    [variableNode didUpdated];
                }
                if (node.superNode == nil) {
                    [self addSubNode:node];
                    node.rootCanvasLayer = self.scrollView.layer;
                    node.rootCocoaView = self.scrollView;
                }
            }
            for (VVBaseNode *unusedNode in unusedNodes) {
                [unusedNode removeFromSuperNode];
                unusedNode.rootCanvasLayer = nil;
                unusedNode.rootCocoaView = nil;
            }
        }
        return YES;
    }
    return NO;
}

- (void)layoutSubNodes
{
    CGPoint origin = self.nodeFrame.origin;
    self.nodeFrame = CGRectMake(0, 0, self.nodeFrame.size.width, self.nodeFrame.size.height);
    
    CGSize contentSize = self.contentSize;
    NSInteger index = 0;
    for (VVBaseNode *subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        if ([subNode needLayout]) {
            CGSize subNodeSize = [subNode calculateSize:contentSize];
            
            if (subNode.layoutGravity & VVGravityHCenter) {
                CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subNode.marginLeft - subNode.marginRight - self.paddingRight) / 2;
                subNode.nodeX = midX - subNodeSize.width / 2;
            } else if (subNode.layoutGravity & VVGravityRight) {
                subNode.nodeX = self.nodeFrame.size.width - self.paddingRight - subNode.marginRight - subNodeSize.width;
            } else {
                subNode.nodeX = self.paddingLeft + subNode.marginLeft;
            }
            
            if (subNode.layoutGravity & VVGravityVCenter) {
                CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subNode.marginTop - subNode.marginBottom - self.paddingBottom) / 2;
                subNode.nodeY = midY - subNodeSize.height / 2;
            } else if (subNode.layoutGravity & VVGravityBottom) {
                subNode.nodeY = self.nodeFrame.size.height - self.paddingBottom - subNode.marginBottom - subNodeSize.height;
            } else {
                subNode.nodeY = self.paddingTop + subNode.marginTop;
            }
            
            if (self.orientation == VVOrientationHorizontal) {
                subNode.nodeX += self.nodeWidth * index;
            } else {
                subNode.nodeY += self.nodeHeight * index;
            }
        }
        [subNode updateHidden];
        [subNode updateFrame];
        [subNode layoutSubNodes];
        index++;
    }
    if (self.orientation == VVOrientationHorizontal) {
        _scrollView.contentSize = CGSizeMake(self.nodeWidth * index, self.nodeHeight);
    } else {
        _scrollView.contentSize = CGSizeMake(self.nodeWidth, self.nodeHeight * index);
    }
    [_scrollView reset];
    
    self.nodeFrame = CGRectMake(origin.x, origin.y, self.nodeFrame.size.width, self.nodeFrame.size.height);
}

+ (VVBaseNode *)popReuseableNodeWithType:(NSString *)nodeType fromUnusedNodes:(NSMutableArray *)unusedNodes
{
    VVBaseNode *reuseableNode = nil;
    for (VVBaseNode *unusedNode in unusedNodes) {
        if ([unusedNode.templateType isEqualToString:nodeType]) {
            reuseableNode = unusedNode;
            break;
        }
    }
    if (reuseableNode) {
        [unusedNodes removeObject:reuseableNode];
    }
    return reuseableNode;
}

@end

//
//  VVGridView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVGridView.h"
#import "VVViewContainer.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"

@interface VVGridView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id lastData;
@property (nonatomic, assign, readwrite) CGRect nodeFrame;

@end

@implementation VVGridView

@synthesize rootCocoaView = _rootCocoaView, rootCanvasLayer = _rootCanvasLayer;
@synthesize nodeFrame;

- (instancetype)init
{
    if (self = [super init]) {
        _lastData = self;
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)cocoaView
{
    return _containerView;
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

- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key
{
    if (key == STR_ID_dataTag) {
        if (obj != _lastData && [obj isKindOfClass:[NSArray class]]) {
            _lastData = obj;
            
            for (VVBaseNode *subNode in self.subNodes) {
                [subNode removeFromSuperNode];
            }
            [self.containerView.subviews performSelector:@selector(removeFromSuperview)];
            [self.containerView.layer.sublayers performSelector:@selector(removeFromSuperlayer)];
            
            NSArray *dataArray = (NSArray *)obj;
            for (NSDictionary *itemData in dataArray) {
                if ([itemData isKindOfClass:[NSDictionary class]] == NO
                    || [itemData.allKeys containsObject:@"type"] == NO) {
                    continue;
                }
                NSString *nodeType = [itemData objectForKey:@"type"];
                VVBaseNode *node = [[VVTemplateManager sharedManager] createNodeTreeForType:nodeType];
                if (node.expressionSetters.count > 0) {
                    [node reset];
                    
                    for (VVPropertyExpressionSetter *setter in node.expressionSetters.allValues) {
                        if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                            [setter applyToNode:node withObject:itemData];
                        }
                    }
                    node.actionValue = [itemData objectForKey:node.action];
                    
                    [node didUpdated];
                }
                [self addSubNode:node];
            }
            for (VVBaseNode *subNode in self.subNodes) {
                subNode.rootCanvasLayer = self.containerView.layer;
            }
            for (VVBaseNode *subNode in self.subNodes) {
                subNode.rootCocoaView = self.containerView;
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
    [super layoutSubNodes];
    self.nodeFrame = CGRectMake(origin.x, origin.y, self.nodeFrame.size.width, self.nodeFrame.size.height);
}

@end

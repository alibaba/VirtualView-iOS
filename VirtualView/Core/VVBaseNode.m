//
//  VVBaseNode.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"

@interface VVBaseNode () {
    NSMutableArray *_subnodes;
    BOOL needsLayout;
}

@end

@implementation VVBaseNode

@synthesize subnodes = _subnodes;

- (id)init{
    self = [super init];
    if (self) {
        _subnodes = [[NSMutableArray alloc] init];
        _backgroundColor = [UIColor clearColor];
        _layoutGravity = VVGravityLeft | VVGravityTop;
        _gravity = VVGravityLeft | VVGravityTop;
        _visibility = VVVisibilityVisible;
        _layoutDirection = VVDirectionLeft;
        _autoDimDirection = VVAutoDimDirectionNone;
        [self setNeedsLayout];
    }
    return self;
}

#pragma mark Properties

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    _rootCocoaView = rootCocoaView;
    for (VVBaseNode *subNode in self.subnodes) {
        subNode.rootCocoaView = rootCocoaView;
    }
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    _rootCanvasLayer = rootCanvasLayer;
    for (VVBaseNode *subNode in self.subnodes) {
        subNode.rootCanvasLayer = rootCanvasLayer;
    }
}

- (NSMutableDictionary *)expressionSetters
{
    if (!_expressionSetters) {
        _expressionSetters = [NSMutableDictionary new];
    }
    return _expressionSetters;
}

#pragma mark ClickEvents

- (BOOL)isClickable
{
    return (self.flag & VVFlagClickable) > 0;
}

- (BOOL)isLongClickable
{
    return (self.flag & VVFlagLongClickable) > 0;
}

- (BOOL)supportExposure
{
    return (self.flag & VVFlagExposure) > 0;
}

- (VVBaseNode *)hitTest:(CGPoint)point
{
    if (self.visibility == VVVisibilityVisible
        && CGRectContainsPoint(self.nodeFrame, point)) {
        if (self.subnodes.count > 0) {
            for (VVBaseNode* subnode in [self.subnodes reverseObjectEnumerator]) {
                VVBaseNode *hitNode = [subnode hitTest:point];
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

#pragma mark NodeTree

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID
{
    if (self.nodeID == nodeID) {
        return self;
    }
    for (VVBaseNode *subnode in self.subnodes) {
        VVBaseNode *targetNode = [subnode nodeWithID:nodeID];
        if (targetNode) {
            return targetNode;
        }
    }
    return nil;
}

- (void)addSubnode:(VVBaseNode *)node
{
    if (nil != node) {
        [_subnodes addObject:node];
        node->_supernode = self;
    }
}

- (void)removeSubnode:(VVBaseNode*)node
{
    if (nil != node && [_subnodes containsObject:node]) {
        [_subnodes removeObject:node];
        node->_supernode = nil;
    }
}

- (void)removeFromSupernode
{
    if (nil != self.supernode) {
        [self.supernode removeSubnode:self];
    }
}

#pragma mark Layout

- (void)setNeedsLayout
{
    needsLayout = YES;
    self.nodeWidth = -1;
    self.nodeHeight = -1;
}

- (void)layoutIfNeeded
{
    if (needsLayout) {
        [self layoutSubnodes];
        needsLayout = NO;
    }
}

- (void)layoutSubviews
{
    [self layoutSubnodes];
}

- (void)layoutSubnodes
{
    // override me
}

- (void)applyAutoDim
{
    if (self.autoDimX > 0 && self.autoDimY > 0) {
        if (self.autoDimDirection == VVAutoDimDirectionX) {
            self.nodeHeight = self.nodeWidth / self.autoDimX * self.autoDimY;
        } else if (self.autoDimDirection == VVAutoDimDirectionY) {
            self.nodeWidth = self.nodeHeight / self.autoDimY * self.autoDimX;
        }
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize
{
    return [self calculateSize:maxSize];
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    if (self.nodeWidth < 0 || self.nodeHeight < 0) {
        self.nodeWidth = 0;
        if (self.layoutWidth == VV_MATCH_PARENT) {
            self.nodeWidth = maxSize.width;
        } else if (self.layoutWidth > 0) {
            self.nodeWidth = self.layoutWidth;
        }
        
        self.nodeHeight = 0;
        if (self.layoutHeight == VV_MATCH_PARENT) {
            self.nodeHeight = maxSize.height;
        } else if (self.layoutHeight > 0) {
            self.nodeHeight = self.layoutHeight;
        }
        
        [self applyAutoDim];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

#pragma mark Update

- (void)changeCocoaViewSuperView{
    if (self.cocoaView.superview && self.visibility==VVVisibilityGone) {
        [self.cocoaView removeFromSuperview];
    }else if(self.cocoaView.superview==nil && self.visibility!=VVVisibilityGone){
        [self.rootCocoaView addSubview:self.cocoaView];
    }
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_layoutWidth:
            _layoutWidth = value;
            break;
        case STR_ID_layoutHeight:
            _layoutHeight = value;
            break;
        case STR_ID_paddingLeft:
            _paddingLeft = value;
            break;
        case STR_ID_paddingTop:
            _paddingTop = value;
            break;
        case STR_ID_paddingRight:
            _paddingRight = value;
            break;
        case STR_ID_paddingBottom:
            _paddingBottom = value;
            break;
        case STR_ID_layoutMarginLeft:
            _marginLeft = value;
            break;
        case STR_ID_layoutMarginTop:
            _marginTop = value;
            break;
        case STR_ID_layoutMarginRight:
            _marginRight = value;
            break;
        case STR_ID_layoutMarginBottom:
            _marginBottom = value;
            break;
        case STR_ID_layoutGravity:
            _layoutGravity = value;
            break;
        case STR_ID_id:
            _nodeID = value;
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
            break;
            
        case STR_ID_gravity:
            self.gravity = value;
            break;
            
        case STR_ID_flag:
            _flag = value;
            break;
            
        case STR_ID_uuid:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_uuid:%d",value);
            #endif
            break;
            
        case STR_ID_autoDimDirection:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimDirection:%d",value);
            #endif
            _autoDimDirection = value;
            break;
            
        case STR_ID_autoDimX:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimX:%d",value);
            #endif
            _autoDimX = value;
            break;
            
        case STR_ID_autoDimY:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimY:%d",value);
            #endif
            _autoDimY = value;
            break;
        case STR_ID_layoutRatio:
            self.layoutRatio = value;
            break;
        case STR_ID_visibility:
            self.visibility = value;
            switch (self.visibility) {
                case VVVisibilityInvisible:
                    self.cocoaView.hidden = YES;
                    break;
                case VVVisibilityVisible:
                    self.cocoaView.hidden = NO;
                    break;
                case VVVisibilityGone:
                    self.cocoaView.hidden = YES;
                    break;
            }
            [self changeCocoaViewSuperView];
            break;
        case STR_ID_layoutDirection:
            self.layoutDirection = value;
        default:
            ret = false;
    }

    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {

        case STR_ID_layoutWidth:
            _layoutWidth = value;
            break;
        case STR_ID_layoutHeight:
            _layoutHeight = value;
            break;
        case STR_ID_paddingLeft:
            _paddingLeft = value;
            break;
        case STR_ID_paddingTop:
            _paddingTop = value;
            break;
        case STR_ID_paddingRight:
            _paddingRight = value;
            break;
        case STR_ID_paddingBottom:
            _paddingBottom = value;
            break;
        case STR_ID_layoutMarginLeft:
            _marginLeft = value;
            break;
        case STR_ID_layoutMarginTop:
            _marginTop = value;
            break;
        case STR_ID_layoutMarginRight:
            _marginRight = value;
            break;
        case STR_ID_layoutMarginBottom:
            _marginBottom = value;
            break;
        case STR_ID_layoutGravity:
            _layoutGravity = value;
            break;
        case STR_ID_id:
            _nodeID = value;
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithARGB:(int)value];
            break;
            
        case STR_ID_gravity:
            self.gravity = value;
            break;
            
        case STR_ID_flag:
            _flag = value;
            break;
            
        case STR_ID_uuid:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_uuid:%f",value);
            #endif
            break;
            
        case STR_ID_autoDimDirection:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimDirection:%f",value);
            #endif
            _autoDimDirection = value;
            break;
            
        case STR_ID_autoDimX:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimX:%f",value);
            #endif
            _autoDimX = value;
            break;
            
        case STR_ID_autoDimY:
            #ifdef VV_DEBUG
                NSLog(@"STR_ID_autoDimY:%f",value);
            #endif
            _autoDimY = value;
            break;
        case STR_ID_layoutRatio:
            self.layoutRatio = value;
            break;
        case STR_ID_visibility:
            self.visibility = value;
            switch (self.visibility) {
                case VVVisibilityInvisible:
                    self.cocoaView.hidden = YES;
                    break;
                case VVVisibilityVisible:
                    self.cocoaView.hidden = NO;
                    break;
                case VVVisibilityGone:
                    //
                    break;
            }
            [self changeCocoaViewSuperView];
            break;
        default:
            ret = false;
            break;
    }
    
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {

        case STR_ID_data:
            break;

        case STR_ID_dataTag:
            self.dataTag = value;
            break;

        case STR_ID_action:
            self.action = value;
            break;

        case STR_ID_class:
            self.className = value;
            break;

        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithString:value];
            break;
        default:
            ret = NO;
    }
    return ret;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key
{
    BOOL ret = true;
    switch (key) {
        case STR_ID_onClick:
            break;
            
        case STR_ID_onBeforeDataLoad:
            break;
            
        case STR_ID_onAfterDataLoad:
            break;
            
        case STR_ID_onSetData:
            break;
            
        default:
            ret = false;
    }
    
    return ret;
}

- (void)setDataObj:(NSObject *)obj forKey:(int)key
{
    // override me
}

- (void)reset
{
    // override me
}

- (void)didUpdated
{
    // override me
}

@end

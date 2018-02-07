//
//  VVBaseNode.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"

@interface VVBaseNode () {
    NSMutableArray *_subnodes;
    int _align, _minWidth, _minHeight;
    BOOL needsLayout;
}

@end

@implementation VVBaseNode
@synthesize subnodes = _subnodes;

- (id)init{
    self = [super init];
    if (self) {
        _subnodes = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.gravity = VVGravityLeft|VVGravityTop;
        self.visibility = VVVisibilityVisible;
        self.layoutDirection = VVDirectionLeft;
        self.autoDimDirection = VVAutoDimDirectionNone;
        [self setNeedsLayout];
    }
    return self;
}

- (NSMutableDictionary *)expressionSetters
{
    if (!_expressionSetters) {
        _expressionSetters = [NSMutableDictionary new];
    }
    return _expressionSetters;
}

- (BOOL)isClickable{
    if (_flag&VVFlagClickable) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isLongClickable{
    if (_flag&VVFlagLongClickable) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)supportExposure{
    if (_flag&VVFlagExposure) {
        return YES;
    }else{
        return NO;
    }

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

- (VVBaseNode*)findViewByID:(int)tagid{

    if (self.nodeID==tagid) {
        return self;
    }

    VVBaseNode* obj = nil;

    for (VVBaseNode* item in self.subnodes) {
        if (item.nodeID==tagid) {
            obj = item;
            break;
        }else{
            obj = [item findViewByID:tagid];
            if(obj.nodeID==tagid)
            {
                break;
            }
        }
    }
    return obj;
}

- (void)addSubview:(VVBaseNode*)view{
    if (nil != view) {
        [_subnodes addObject:view];
        view->_supernode = self;
    }
}

- (void)removeSubView:(VVBaseNode*)view{
    if (nil != view && [_subnodes containsObject:view]) {
        [_subnodes removeObject:view];
    }
}

- (void)removeFromSuperview{
    if (nil != self.supernode) {
        [self.supernode removeSubView:self];
        self->_supernode = nil;
    }
}

- (BOOL)isMatchParent
{
    return self.layoutWidth == VV_MATCH_PARENT || self.layoutHeight == VV_MATCH_PARENT;
}

- (BOOL)isWarpContent
{
    return self.layoutWidth == VV_WRAP_CONTENT || self.layoutHeight == VV_WRAP_CONTENT;
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

- (void)layoutSubnodes
{
    // override me
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



- (void)changeCocoaViewSuperView{
    if (self.cocoaView.superview && self.visibility==VVVisibilityGone) {
        [self.cocoaView removeFromSuperview];
    }else if(self.cocoaView.superview==nil && self.visibility!=VVVisibilityGone){
        [self.rootCocoaView addSubview:self.cocoaView];
    }
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
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
            _layoutMarginLeft = value;
            break;
        case STR_ID_layoutMarginTop:
            _layoutMarginTop = value;
            break;
        case STR_ID_layoutMarginRight:
            _layoutMarginRight = value;
            break;
        case STR_ID_layoutMarginBottom:
            _layoutMarginBottom = value;
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
            
        case STR_ID_minWidth:
            _minWidth = value;
            break;
        case STR_ID_minHeight:
            _minHeight = value;
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

- (BOOL)setFloatValue:(float)value forKey:(int)key{
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
            _layoutMarginLeft = value;
            break;
        case STR_ID_layoutMarginTop:
            _layoutMarginTop = value;
            break;
        case STR_ID_layoutMarginRight:
            _layoutMarginRight = value;
            break;
        case STR_ID_layoutMarginBottom:
            _layoutMarginBottom = value;
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
            
        case STR_ID_minWidth:
            _minWidth = value;
            break;
        case STR_ID_minHeight:
            _minHeight = value;
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

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
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

- (void)reset{

}

- (void)didFinishBinding
{
    
}

- (void)setData:(NSData*)data{

}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{

}

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

@end

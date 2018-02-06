//
//  VVBaseNode.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"
#import "UIColor+VirtualView.h"

@interface VVBaseNode ()
{
    NSMutableArray*   _subViews;
    NSUInteger        _nodeID;
    int _align, _flag, _minWidth, _minHeight;
}

@end

@implementation VVBaseNode
@synthesize subViews = _subViews;
@synthesize nodeID   = _nodeID;

- (id)init{
    self = [super init];
    if (self) {
        self.alpha = 1.0f;
        self.hidden = NO;
        _subViews = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.gravity = VVGravityLeft|VVGravityTop;
        self.visibility = VVVisibilityVisible;
        self.layoutDirection = VVDirectionLeft;
        self.autoDimDirection = VVAutoDimDirectionNone;
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
-(BOOL)pointInside:(CGPoint)point withView:(VVBaseNode*)vvobj{
    CGFloat x =vvobj.nodeFrame.origin.x;
    CGFloat y =vvobj.nodeFrame.origin.y;
    CGFloat w =vvobj.nodeFrame.size.width;
    CGFloat h =vvobj.nodeFrame.size.height;
    if (point.x>x && point.y>y && point.x<w+x && point.y<h+y) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)pointInside:(CGPoint)point{
    CGFloat x =self.nodeFrame.origin.x;
    CGFloat y =self.nodeFrame.origin.y;
    CGFloat w =self.nodeFrame.size.width;
    CGFloat h =self.nodeFrame.size.height;
    if (point.x>x && point.y>y && point.x<w+x && point.y<h+y) {
        return YES;
    }else{
        return NO;
    }
}

- (VVBaseNode *)hitTest:(CGPoint)point
{
    if (self.visibility == VVVisibilityVisible && self.hidden == NO && self.alpha > 0.1f && [self pointInside:point]) {
        if (self.subViews.count > 0) {
            for (VVBaseNode* item in [self.subViews reverseObjectEnumerator]) {
                VVBaseNode *obj = [item hitTest:point];
                if (obj) {
                    return obj;
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

    for (VVBaseNode* item in self.subViews) {
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
        [_subViews addObject:view];
        view.superview = self;
    }
}

- (void)removeSubView:(VVBaseNode*)view{
    if (nil != view && [_subViews containsObject:view]) {
        [_subViews removeObject:view];
    }
}

- (void)removeFromSuperview{
    if (nil != self.superview) {
        [self.superview removeSubView:self];
        self.superview = nil;
    }
}

- (void)setNeedsLayout{

}

- (void)layoutSubnodes
{
    CGFloat x = self.nodeFrame.origin.x;
    CGFloat y = self.nodeFrame.origin.y;
    _nodeWidth = _nodeWidth<0?self.superview.nodeFrame.size.width:_nodeWidth;
    _nodeHeight = _nodeHeight<0?self.superview.nodeFrame.size.height:_nodeHeight;
    CGFloat a1,a2,w,h;
    a1 = (int)x*1;
    a2 = (int)y*1;
    w = (int)_nodeWidth*1;
    h = (int)_nodeHeight*1;
    self.nodeFrame = CGRectMake(a1, a2, w, h);
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    return CGSizeZero;
}

- (void)autoDim{
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            self.nodeHeight = self.nodeWidth*(self.autoDimY/self.autoDimX);
            break;
        case VVAutoDimDirectionY:
            self.nodeWidth = self.nodeHeight*(self.autoDimX/self.autoDimY);
        default:
            break;
    }
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
            _nodeWidth = value>0?value:0;
            self.nodeFrame = CGRectMake(0, 0, _nodeWidth, _nodeHeight);
            break;
        case STR_ID_layoutHeight:
            _layoutHeight = value;
            _nodeHeight = value>0?value:0;
            self.nodeFrame = CGRectMake(0, 0, _nodeWidth, _nodeHeight);
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
                    self.hidden = YES;
                    self.cocoaView.hidden = YES;
                    break;
                case VVVisibilityVisible:
                    self.hidden = NO;
                    self.cocoaView.hidden = NO;
                    break;
                case VVVisibilityGone:
                    self.hidden = YES;
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
            _nodeWidth = value>0?value:0;
            self.nodeFrame = CGRectMake(0, 0, _nodeWidth, _nodeHeight);
            break;
        case STR_ID_layoutHeight:
            _layoutHeight = value;
            _nodeHeight = value>0?value:0;
            self.nodeFrame = CGRectMake(0, 0, _nodeWidth, _nodeHeight);
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
                    self.hidden = YES;
                    self.cocoaView.hidden = YES;
                    break;
                case VVVisibilityVisible:
                    self.hidden = NO;
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

        case STR_ID_actionParam:
            self.actionParam = value;
            break;

        case STR_ID_class:
            self.classString = value;
            break;

        case STR_ID_name:
            self.name = value;
            break;

        case STR_ID_dataUrl:
            self.dataUrl = value;
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
    for (VVBaseNode *subNode in self.subViews) {
        subNode.rootCocoaView = rootCocoaView;
    }
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    _rootCanvasLayer = rootCanvasLayer;
    for (VVBaseNode *subNode in self.subViews) {
        subNode.rootCanvasLayer = rootCanvasLayer;
    }
}

@end

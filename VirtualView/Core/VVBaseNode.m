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
    NSUInteger        _objectID;
    int _align, _flag, _minWidth, _minHeight;
}

@end

@implementation VVBaseNode
@synthesize subViews = _subViews;
@synthesize objectID   = _objectID;

- (id)init{
    self = [super init];
    if (self) {
        self.alpha = 1.0f;
        self.hidden = NO;
        _subViews = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.gravity = VVGravityLeft|VVGravityTop;
        self.visible = VVVisibilityVisible;
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
    CGFloat x =vvobj.frame.origin.x;
    CGFloat y =vvobj.frame.origin.y;
    CGFloat w =vvobj.frame.size.width;
    CGFloat h =vvobj.frame.size.height;
    if (point.x>x && point.y>y && point.x<w+x && point.y<h+y) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)pointInside:(CGPoint)point{
    CGFloat x =self.frame.origin.x;
    CGFloat y =self.frame.origin.y;
    CGFloat w =self.frame.size.width;
    CGFloat h =self.frame.size.height;
    if (point.x>x && point.y>y && point.x<w+x && point.y<h+y) {
        return YES;
    }else{
        return NO;
    }
}

- (id<VVWidgetObject>)hitTest:(CGPoint)point
{
    if (self.visible == VVVisibilityVisible && self.hidden == NO && self.alpha > 0.1f && [self pointInside:point]) {
        if (self.subViews.count > 0) {
            for (VVBaseNode* item in [self.subViews reverseObjectEnumerator]) {
                id<VVWidgetObject> obj = [item hitTest:point];
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

    if (self.objectID==tagid) {
        return self;
    }

    VVBaseNode* obj = nil;

    for (VVBaseNode* item in self.subViews) {
        if (item.objectID==tagid) {
            obj = item;
            break;
        }else{
            obj = [item findViewByID:tagid];
            break;
        }
    }
    return obj;
}

- (void)addSubview:(VVBaseNode*)view{
    [_subViews addObject:view];
    view.superview = self;
}

- (void)removeSubView:(VVBaseNode*)view{
    [_subViews removeObject:view];
}

- (void)removeFromSuperview{
    [self.superview removeSubView:self];
    self.superview = nil;
}

- (void)setNeedsLayout{

}

- (CGSize)nativeContentSize{
    return CGSizeZero;
}

- (void)layoutSubviews
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    _width = _width<0?self.superview.frame.size.width:_width;
    _height = _height<0?self.superview.frame.size.height:_height;
    CGFloat a1,a2,w,h;
    a1 = (int)x*1;
    a2 = (int)y*1;
    w = (int)_width*1;
    h = (int)_height*1;
    self.frame = CGRectMake(a1, a2, w, h);
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    CGSize size={0,0};
    return size;
}

- (void)autoDim{
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            self.height = self.width*(self.autoDimY/self.autoDimX);
            break;
        case VVAutoDimDirectionY:
            self.width = self.height*(self.autoDimX/self.autoDimY);
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect{

}

- (void)changeCocoaViewSuperView{
    if (self.cocoaView.superview && self.visible==VVVisibilityGone) {
        [self.cocoaView removeFromSuperview];
    }else if(self.cocoaView.superview==nil && self.visible!=VVVisibilityGone){
        [(UIView*)self.updateDelegate addSubview:self.cocoaView];
    }
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = YES;
    switch (key) {

        case STR_ID_layoutWidth:
            _widthModle = value;
            _width = value>0?value:0;
            self.frame = CGRectMake(0, 0, _width, _height);
            break;
        case STR_ID_layoutHeight:
            _heightModle = value;
            _height = value>0?value:0;
            self.frame = CGRectMake(0, 0, _width, _height);
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
            _objectID = value;
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
            self.visible = value;
            switch (self.visible) {
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
            _widthModle = value;
            _width = value>0?value:0;
            self.frame = CGRectMake(0, 0, _width, _height);
            break;
        case STR_ID_layoutHeight:
            _heightModle = value;
            _height = value>0?value:0;
            self.frame = CGRectMake(0, 0, _width, _height);
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
            _objectID = value;
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
            self.visible = value;
            switch (self.visible) {
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

- (void)dataUpdateFinished{
    [self layoutSubviews];
}

- (void)setData:(NSData*)data{

}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{

}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    _updateDelegate = delegate;
    for (VVBaseNode* subObj in self.subViews) {
        subObj.updateDelegate = delegate;
    }
}

@end

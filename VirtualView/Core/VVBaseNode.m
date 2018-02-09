//
//  VVBaseNode.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"
#import "VVVH2Layout.h"

@interface VVBaseNode () {
    NSMutableArray *_subNodes;
}

@property (nonatomic, assign) BOOL updatingNeedsResize; // to avoid infinite loop

@end

@implementation VVBaseNode

@synthesize subNodes = _subNodes;

- (id)init{
    self = [super init];
    if (self) {
        _subNodes = [[NSMutableArray alloc] init];
        _backgroundColor = [UIColor clearColor];
        _borderColor = [UIColor clearColor];
        _layoutGravity = VVGravityDefault;
        _gravity = VVGravityDefault;
        _visibility = VVVisibilityVisible;
        _layoutDirection = VVDirectionDefault;
        _autoDimDirection = VVAutoDimDirectionNone;
        [self setNeedsResizeNonRecursively];
        [self setNeedsLayout];
        [self setupLayoutAndResizeObserver];
    }
    return self;
}

#pragma mark Properties

- (CGSize)nodeSize
{
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

- (CGSize)contentSize
{
    return CGSizeMake(self.nodeWidth - _paddingLeft - _paddingRight,
                      self.nodeHeight - _paddingTop - _paddingBottom);
}

- (CGSize)containerSize
{
    return CGSizeMake(self.nodeWidth + _marginLeft + _marginRight,
                      self.nodeHeight + _marginTop + _marginBottom);
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    _rootCocoaView = rootCocoaView;
    for (VVBaseNode *subNode in self.subNodes) {
        subNode.rootCocoaView = rootCocoaView;
    }
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    _rootCanvasLayer = rootCanvasLayer;
    for (VVBaseNode *subNode in self.subNodes) {
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
    return self.flag & VVFlagClickable;
}

- (BOOL)isLongClickable
{
    return self.flag & VVFlagLongClickable;
}

- (BOOL)supportExposure
{
    return self.flag & VVFlagExposure;
}

- (VVBaseNode *)hitTest:(CGPoint)point
{
    if (self.visibility == VVVisibilityVisible
        && CGRectContainsPoint(self.nodeFrame, point)) {
        if (self.subNodes.count > 0) {
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

#pragma mark NodeTree

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID
{
    if (self.nodeID == nodeID) {
        return self;
    }
    for (VVBaseNode *subNode in self.subNodes) {
        VVBaseNode *targetNode = [subNode nodeWithID:nodeID];
        if (targetNode) {
            return targetNode;
        }
    }
    return nil;
}

- (void)addSubNode:(VVBaseNode *)node
{
    if (nil != node) {
        [_subNodes addObject:node];
        node->_superNode = self;
    }
}

- (void)removeSubNode:(VVBaseNode*)node
{
    if (nil != node && [_subNodes containsObject:node]) {
        [_subNodes removeObject:node];
        node->_superNode = nil;
    }
}

- (void)removeFromSuperNode
{
    if (nil != self.superNode) {
        [self.superNode removeSubNode:self];
    }
}

#pragma mark Update
- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [self setFloatValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_id:
                _nodeID = value;
                break;
            case STR_ID_visibility:
                self.visibility = value;
                break;
            case STR_ID_autoDimDirection:
                _autoDimDirection = value;
                break;
            case STR_ID_gravity:
                self.gravity = value;
                break;
            case STR_ID_layoutGravity:
                _layoutGravity = value;
                break;
            case STR_ID_layoutDirection:
                self.layoutDirection = value;
                break;
            case STR_ID_background:
                self.backgroundColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            case STR_ID_borderColor:
                self.borderColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            case STR_ID_flag:
                _flag = value;
                break;
            default:
                ret = NO;
                break;
        }
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
        case STR_ID_autoDimX:
            _autoDimX = value;
            break;
        case STR_ID_autoDimY:
            _autoDimY = value;
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
        case STR_ID_layoutRatio:
            self.layoutRatio = value;
            break;
        case STR_ID_borderWidth:
            self.borderWidth = value;
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_dataTag:
            self.dataTag = value;
            break;
        case STR_ID_action:
            self.action = value;
            break;
        case STR_ID_class:
            self.className = value;
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_borderColor:
            self.borderColor = [UIColor vv_colorWithString:value];
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithString:value];
            break;
        default:
            ret = NO;
            break;
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

#pragma mark Layout

- (void)setupLayoutAndResizeObserver
{
    VVSetNeedsResizeObserve(layoutWidth);
    VVSetNeedsResizeObserve(layoutHeight);
    VVSetNeedsResizeObserve(autoDimX);
    VVSetNeedsResizeObserve(autoDimY);
    VVSetNeedsResizeObserve(autoDimDirection);
    __weak VVBaseNode *weakSelf = self;
    VVObserverBlock paddingChangedBlock = ^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        for (VVBaseNode *subNode in strongSelf.subNodes) {
            [subNode setNeedsLayout];
            if ([subNode needResizeIfSuperNodeResize]) {
                [subNode setNeedsResize];
            }
        }
    };
    VVBlockObserve(paddingTop, paddingChangedBlock);
    VVBlockObserve(paddingLeft, paddingChangedBlock);
    VVBlockObserve(paddingRight, paddingChangedBlock);
    VVBlockObserve(paddingBottom, paddingChangedBlock);
    VVObserverBlock marginChangedBlock = ^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        [strongSelf setNeedsLayout];
        [strongSelf setNeedsResize];
    };
    VVBlockObserve(marginTop, marginChangedBlock);
    VVBlockObserve(marginLeft, marginChangedBlock);
    VVBlockObserve(marginRight, marginChangedBlock);
    VVBlockObserve(marginBottom, marginChangedBlock);
    VVBlockObserve(visibility, marginChangedBlock);
    VVBlockObserve(layoutRatio, marginChangedBlock);
    [self vv_addObserverForKeyPath:VVKeyPath(gravity) block:^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        for (VVBaseNode *subNode in strongSelf.subNodes) {
            [subNode setNeedsLayout];
        }
    }];
    VVSelectorObserve(layoutGravity, setNeedsLayout);
}

- (BOOL)needLayout
{
    return _nodeX == CGFLOAT_MIN || _nodeY == CGFLOAT_MIN;
}

- (BOOL)needResize
{
    return _nodeWidth == CGFLOAT_MIN || _nodeHeight == CGFLOAT_MIN;
}

- (void)setNeedsLayout
{
    _nodeX = _nodeY = CGFLOAT_MIN;
}

- (BOOL)needLayoutIfSuperNodeResize
{
    return _layoutGravity & VVGravityNotDefault;
}

- (BOOL)needResizeIfSuperNodeResize
{
    return _layoutWidth == VV_MATCH_PARENT || _layoutHeight == VV_MATCH_PARENT;
}

- (BOOL)needResizeIfSubNodeResize
{
    return _layoutWidth == VV_WRAP_CONTENT || _layoutHeight == VV_WRAP_CONTENT;
}

- (void)setNeedsResize
{
    if (_updatingNeedsResize) {
        return;
    }
    _updatingNeedsResize = YES;
    [self setNeedsResizeNonRecursively];
    if (_superNode && [_superNode needResizeIfSubNodeResize]) {
        [_superNode setNeedsResize];
    }
    for (VVBaseNode *subNode in _subNodes) {
        if ([subNode needResizeIfSuperNodeResize]) {
            [subNode setNeedsResize];
        }
        if ([subNode needLayoutIfSuperNodeResize]) {
            [subNode setNeedsLayout];
        }
    }
    _updatingNeedsResize = NO;
}

- (void)setNeedsResizeNonRecursively
{
    _nodeWidth = _nodeHeight = CGFLOAT_MIN;
}

- (void)setNeedsLayoutAndResizeRecursively
{
    [self setNeedsLayout];
    [self setNeedsResizeNonRecursively];
    for (VVBaseNode *subNode in _subNodes) {
        [subNode setNeedsLayoutAndResizeRecursively];
    }
}

- (void)updateFrame
{
    CGFloat x = 0, y = 0;
    if (_superNode) {
        x = _superNode.nodeFrame.origin.x;
        y = _superNode.nodeFrame.origin.y;
    }
    _nodeFrame = CGRectMake(x + _nodeX, y + _nodeY, _nodeWidth, _nodeHeight);
}

- (void)layoutSubviews
{
    [self layoutSubNodes];
}

- (void)layoutSubNodes
{
    // override me
}

- (void)applyAutoDim
{
    if (_autoDimX > 0 && _autoDimY > 0) {
        if (_autoDimDirection == VVAutoDimDirectionX) {
            _nodeHeight = _nodeWidth / _autoDimX * _autoDimY;
        } else if (_autoDimDirection == VVAutoDimDirectionY) {
            _nodeWidth = _nodeHeight / _autoDimY * _autoDimX;
        }
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize
{
    return [self calculateSize:maxSize];
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    if ([self needResize]) {
        _nodeWidth = 0;
        if (_layoutWidth == VV_MATCH_PARENT) {
            _nodeWidth = maxSize.width - _marginLeft - _marginRight;
        } else if (_layoutWidth > 0) {
            _nodeWidth = _layoutWidth;
        }
        
        _nodeHeight = 0;
        if (_layoutHeight == VV_MATCH_PARENT) {
            _nodeHeight = maxSize.height - _marginTop - _marginBottom;
        } else if (_layoutHeight > 0) {
            _nodeHeight = _layoutHeight;
        }
        
        [self applyAutoDim];
    }
    return CGSizeMake(_nodeWidth, _nodeHeight);
}

@end

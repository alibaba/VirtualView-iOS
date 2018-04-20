//
//  VVBaseNode.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"
#import "VVVH2Layout.h"
#import "VVRatioLayout.h"

@interface VVBaseNode () {
    NSMutableArray *_subNodes;
}

@property (nonatomic, assign) BOOL updatingNeedsResize; // to avoid infinite loop
@property (nonatomic, assign, readwrite) CGRect nodeFrame;

@end

@implementation VVBaseNode

@synthesize subNodes = _subNodes;
@dynamic nodeSize, contentSize, containerSize;

- (id)init
{
    self = [super init];
    if (self) {
        _subNodes = [[NSMutableArray alloc] init];
        _backgroundColor = [UIColor clearColor];
        _borderColor = [UIColor clearColor];
        _layoutGravity = VVGravityNone;
        _visibility = VVVisibilityVisible;
        _layoutDirection = VVDirectionDefault;
        _autoDimDirection = VVAutoDimDirectionNone;
        [self setNeedsResizeNonRecursively];
        [self setNeedsLayout];
    }
    return self;
}

- (void)dealloc
{
    [self vv_removeAllObservers];
}

- (NSString *)layoutWidthString
{
    if (self.layoutWidth == VV_MATCH_PARENT) {
        return @"match_parent";
    } else if (self.layoutWidth == VV_WRAP_CONTENT) {
        return @"wrap_conetent";
    } else {
        return [NSString stringWithFormat:@"%f", self.layoutWidth];
    }
}

- (NSString *)layoutHeightString
{
    if (self.layoutHeight == VV_MATCH_PARENT) {
        return @"match_parent";
    } else if (self.layoutHeight == VV_WRAP_CONTENT) {
        return @"wrap_conetent";
    } else {
        return [NSString stringWithFormat:@"%f", self.layoutHeight];
    }
}

- (NSString *)visibilityString
{
    if (self.visibility == VVVisibilityGone) {
        return @"; visibility = Gone";
    } else if (self.visibility == VVVisibilityInvisible) {
        return @"; visibility = Invisible";
    } else {
        return @"";
    }
}

- (NSString *)descriptionWithoutSubNodes
{
    return [NSString stringWithFormat:@"<%@: %p; frame = %@; layoutWidth = %@; layoutHeight = %@%@>", self.class, self, NSStringFromCGRect(CGRectMake(self.nodeX, self.nodeY, self.nodeWidth, self.nodeHeight)), [self layoutWidthString], [self layoutHeightString], [self visibilityString]];
}

- (NSString *)description
{
    if (_subNodes.count > 0) {
        NSArray *subNodeStrings = [_subNodes valueForKeyPath:@"descriptionWithoutSubNodes"];
        return [NSString stringWithFormat:@"<%@: %p; frame = %@; layoutWidth = %@; layoutHeight = %@%@; subNodes = %@>", self.class, self, NSStringFromCGRect(CGRectMake(self.nodeX, self.nodeY, self.nodeWidth, self.nodeHeight)), [self layoutWidthString], [self layoutHeightString], [self visibilityString], subNodeStrings];
    } else {
        return [self descriptionWithoutSubNodes];
    }
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

- (BOOL)containsClickable
{
    if ([self isClickable]) {
        return YES;
    }
    if (self.subNodes && self.subNodes.count > 0) {
        for (VVBaseNode *subNode in self.subNodes) {
            if ([subNode containsClickable]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)containsLongClickable
{
    if ([self isLongClickable]) {
        return YES;
    }
    if (self.subNodes && self.subNodes.count > 0) {
        for (VVBaseNode *subNode in self.subNodes) {
            if ([subNode containsLongClickable]) {
                return YES;
            }
        }
    }
    return NO;
}

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
                self.autoDimDirection = value;
                break;
            case STR_ID_layoutGravity:
                self.layoutGravity = value;
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
            self.layoutWidth = value;
            break;
        case STR_ID_layoutHeight:
            self.layoutHeight = value;
            break;
        case STR_ID_autoDimX:
            self.autoDimX = value;
            break;
        case STR_ID_autoDimY:
            self.autoDimY = value;
            break;
        case STR_ID_paddingLeft:
            self.paddingLeft = value;
            break;
        case STR_ID_paddingTop:
            self.paddingTop = value;
            break;
        case STR_ID_paddingRight:
            self.paddingRight = value;
            break;
        case STR_ID_paddingBottom:
            self.paddingBottom = value;
            break;
        case STR_ID_layoutMarginLeft:
            self.marginLeft = value;
            break;
        case STR_ID_layoutMarginTop:
            self.marginTop = value;
            break;
        case STR_ID_layoutMarginRight:
            self.marginRight = value;
            break;
        case STR_ID_layoutMarginBottom:
            self.marginBottom = value;
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
        case STR_ID_action:
            _action = value;
            break;
        case STR_ID_class:
            _className = value;
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (BOOL)setStringData:(NSString*)data forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_borderColor:
            self.borderColor = [UIColor vv_colorWithString:data] ?: [UIColor clearColor];
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithString:data] ?: [UIColor clearColor];
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key
{
    // override me
    return NO;
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
    // 这些宽高相关值被修改时：
    // 1. 元素本身的尺寸一定会发生更改
    // 2. 如果元素不是左上对齐，那么位置也会变化，这个会在setNeedsResize里被自动判断并标记为需修改
    // 3. 父元素子元素的布局相关修改会在setNeedsResize里被自动传递
    // 4. 有关VHLayout等子元素需要全部重新计算位置的，在对应Layout类里处理
    VVSetNeedsResizeObserve(layoutWidth);
    VVSetNeedsResizeObserve(layoutHeight);
    VVSetNeedsResizeObserve(autoDimX);
    VVSetNeedsResizeObserve(autoDimY);
    VVSetNeedsResizeObserve(autoDimDirection);
    // padding被修改时：
    // 1. 如果自己会被子元素撑开，那么自己的尺寸要修改
    // 2. 子元素的位置一定会变，子元素尺寸如果受自己影响，子元素尺寸也要变
    __weak VVBaseNode *weakSelf = self;
    VVObserverBlock contentChangedBlock = ^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        if ([strongSelf needResizeIfSubNodeResize]) {
            // 进行1的操作
            [strongSelf setNeedsResize];
            // 如果进行过1的操作，这里子元素尺寸的改变实际上已经被传递过了
            // 所以只需要对位置改变进行一次标记就可以
            for (VVBaseNode *subNode in strongSelf.subNodes) {
                [subNode setNeedsLayout];
            }
        } else {
            // 进行上述2的操作
            for (VVBaseNode *subNode in strongSelf.subNodes) {
                [subNode setNeedsLayout];
                if ([subNode needResizeIfSuperNodeResize]) {
                    [subNode setNeedsResize];
                }
            }
        }
    };
    VVBlockObserve(paddingTop, contentChangedBlock);
    VVBlockObserve(paddingLeft, contentChangedBlock);
    VVBlockObserve(paddingRight, contentChangedBlock);
    VVBlockObserve(paddingBottom, contentChangedBlock);
    // margin被修改时：
    // 1. 如果父元素被自己撑开，那么父元素尺寸要修改
    // 2. 自己的位置一定会变，如果自己的尺寸受父元素影响，那么自己的尺寸也要变
    // 3. 根元素的margin会被无视的，所以一定要有superNode才会继续以上逻辑
    VVObserverBlock selfChangedBlock = ^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        if (strongSelf.superNode) {
            if ([strongSelf.superNode needResizeIfSubNodeResize]) {
                // 进行1的操作
                [strongSelf.superNode setNeedsResize];
                // 如果进行过1的操作，自己的元素尺寸如果需要修改肯定已经被传递过了
                // 所以只需要对位置改变进行一次标记就可以
                [strongSelf setNeedsLayout];
            } else {
                // 进行2的操作
                [strongSelf setNeedsLayout];
                [strongSelf setNeedsResize];
            }
        }
    };
    VVBlockObserve(marginTop, selfChangedBlock);
    VVBlockObserve(marginLeft, selfChangedBlock);
    VVBlockObserve(marginRight, selfChangedBlock);
    VVBlockObserve(marginBottom, selfChangedBlock);
    // visibility被修改时逻辑大体可以使用和margin被修改时一样
    VVBlockObserve(visibility, selfChangedBlock);
    // layoutRatio类似match_parent的一种变种，不会对父元素产生尺寸变更才对，逻辑可以简化
    // 而且因为是RatioLayout下才生效的值，所以加一个保护判断
    [self vv_addObserverForKeyPath:VVKeyPath(layoutRatio) block:^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        if (strongSelf.superNode && [strongSelf.superNode isKindOfClass:[VVRatioLayout class]]) {
            [strongSelf setNeedsLayout];
            [strongSelf setNeedsResize];
        }
    }];
    // layoutGravity被修改时尺寸不会变化，只会影响自己的位置
    VVSelectorObserve(layoutGravity, setNeedsLayout);
    // layoutDirection被修改时逻辑比较特殊，影响所有弟弟元素的位置
    // 注意是弟弟元素不是兄弟元素，不过这里为了简化代码直接写成兄弟元素
    // 而且因为是VH2Layout下才生效的值，所以加一个保护判断
    [self vv_addObserverForKeyPath:VVKeyPath(layoutDirection) block:^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        if (strongSelf.superNode && [strongSelf.superNode isKindOfClass:[VVVH2Layout class]]) {
            for (VVBaseNode *brotherNode in strongSelf.superNode.subNodes) {
                [brotherNode setNeedsLayout];
            }
        }
    }];
    // 递归调用
    for (VVBaseNode *subNode in _subNodes) {
        [subNode setupLayoutAndResizeObserver];
    }
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

- (BOOL)needLayoutIfResize
{
    return _layoutGravity & VVGravityNotDefault;
}

- (BOOL)needResizeIfSuperNodeResize
{
    return _layoutWidth == VV_MATCH_PARENT || _layoutHeight == VV_MATCH_PARENT || _layoutRatio > 0;
}

- (BOOL)needResizeIfSubNodeResize
{
    return _layoutWidth == VV_WRAP_CONTENT || _layoutHeight == VV_WRAP_CONTENT;
}

- (void)setNeedsResize
{
    if (self.updatingNeedsResize || [self needResize]) {
        return;
    }
    self.updatingNeedsResize = YES;
    [self setNeedsResizeNonRecursively];
    if ([self needLayoutIfResize]) {
        [self setNeedsLayout];
    }
    if (_superNode && [_superNode needResizeIfSubNodeResize]) {
        [_superNode setNeedsResize];
    }
    for (VVBaseNode *subNode in _subNodes) {
        if ([subNode needResizeIfSuperNodeResize]) {
            [subNode setNeedsResize];
        }
        if ([subNode needLayoutIfResize]) {
            // 子元素非左上对齐，父元素的尺寸变了，也是要重新计算位置的
            [subNode setNeedsLayout];
        }
    }
    self.updatingNeedsResize = NO;
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

- (void)updateHidden
{
    _hidden = _visibility != VVVisibilityVisible;
    if (_superNode) {
        _hidden |= _superNode.hidden;
    }
    if (self.cocoaView) {
        self.cocoaView.hidden = _hidden;
    }
}

- (void)updateHiddenRecursively
{
    [self updateHidden];
    for (VVBaseNode *subNode in _subNodes) {
        [subNode updateHiddenRecursively];
    }
}

- (void)updateFrame
{
    CGFloat x = 0, y = 0;
    if (_superNode) {
        x = _superNode.nodeFrame.origin.x;
        y = _superNode.nodeFrame.origin.y;
    }
    self.nodeFrame = CGRectMake(x + _nodeX, y + _nodeY, _nodeWidth, _nodeHeight);
    if (self.cocoaView) {
        self.cocoaView.frame = self.nodeFrame;
    }
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

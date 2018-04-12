//
//  VVGridLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVGridLayout.h"

@interface VVGridLayout ()

@property (nonatomic, assign) BOOL updatingNeedsResize;

@end

@implementation VVGridLayout

@dynamic rowCount;

- (instancetype)init
{
    if (self = [super init]) {
        _colCount = 2;
    }
    return self;
}

- (void)setColCount:(int)colCount
{
    if (colCount > 0) _colCount = colCount;
}

- (int)rowCount
{
    return ((int)self.subNodes.count + 1) / _colCount;
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    if (itemHeight >= 0) _itemHeight = itemHeight;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_colCount:
                self.colCount = value;
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
    BOOL ret = [ super setFloatValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_itemHeight:
                self.itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                self.itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                self.itemVerticalMargin = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (void)setupLayoutAndResizeObserver
{
    [super setupLayoutAndResizeObserver];
    // 和padding被修改时做一样的操作，调用内容尺寸变化Block
    __weak VVBaseNode *weakSelf = self;
    VVObserverBlock contentChangedBlock = ^(id _Nonnull value) {
        __strong VVBaseNode *strongSelf = weakSelf;
        if ([strongSelf needResizeIfSubNodeResize]) {
            [strongSelf setNeedsResize];
            for (VVBaseNode *subNode in strongSelf.subNodes) {
                [subNode setNeedsLayout];
            }
        } else {
            for (VVBaseNode *subNode in strongSelf.subNodes) {
                [subNode setNeedsLayout];
                if ([subNode needResizeIfSuperNodeResize]) {
                    [subNode setNeedsResize];
                }
            }
        }
    };
    VVBlockObserve(colCount, contentChangedBlock);
    VVBlockObserve(itemHeight, contentChangedBlock);
    VVBlockObserve(itemVerticalMargin, contentChangedBlock);
    VVBlockObserve(itemHorizontalMargin, contentChangedBlock);
}

- (BOOL)needResizeIfSubNodeResize
{
    return self.layoutWidth == VV_WRAP_CONTENT || (self.layoutHeight == VV_WRAP_CONTENT && _itemHeight == 0);
}

- (void)setNeedsResize
{
    [super setNeedsResize];
    for (VVBaseNode *subNode in self.subNodes) {
        // 所有子元素强制重新计算位置
        [subNode setNeedsLayout];
    }
}

- (void)layoutSubNodes
{
    [super layoutSubNodes];
    CGSize contentSize = self.contentSize;
    CGSize gridSizeWithMargin = CGSizeMake((contentSize.width + _itemHorizontalMargin) / _colCount,
                                           (contentSize.height + _itemVerticalMargin) / self.rowCount);
    CGSize gridSize = CGSizeMake(gridSizeWithMargin.width - _itemHorizontalMargin,
                                 gridSizeWithMargin.height - _itemVerticalMargin);
    int index = 0, col, row;
    for (VVBaseNode *subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:gridSize];
        if ([subNode needLayout]) {
            col = index % _colCount;
            row = index / _colCount;
            
            if (subNode.layoutGravity & VVGravityHCenter) {
                CGFloat midX = self.paddingLeft + gridSizeWithMargin.width * (col + 0.5);
                subNode.nodeX = midX - subNodeSize.width / 2;
            } else if (subNode.layoutGravity & VVGravityRight) {
                subNode.nodeX = self.paddingLeft + gridSizeWithMargin.width * (col + 1) - _itemHorizontalMargin - subNode.marginRight - subNodeSize.width;
            } else {
                subNode.nodeX = self.paddingLeft + gridSizeWithMargin.width * col + subNode.marginLeft;
            }
            
            if (subNode.layoutGravity & VVGravityVCenter) {
                CGFloat midY = self.paddingTop + gridSizeWithMargin.height * (row + 0.5);
                subNode.nodeY = midY - subNodeSize.height / 2;
            } else if (subNode.layoutGravity & VVGravityBottom) {
                subNode.nodeY = self.paddingTop + gridSizeWithMargin.height * (row + 1) - _itemVerticalMargin - subNode.marginBottom - subNodeSize.height;
            } else {
                subNode.nodeY = self.paddingTop + gridSizeWithMargin.height * row + subNode.marginTop;
            }
        }
        [subNode updateHidden];
        [subNode updateFrame];
        [subNode layoutSubNodes];
        index++;
    }
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [super calculateSize:maxSize];
    if (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT && _itemHeight > 0) {
        self.nodeHeight = self.rowCount * (_itemHeight + _itemVerticalMargin) - _itemVerticalMargin + self.paddingTop + self.paddingBottom;
        [self applyAutoDim];
    }
    if ((self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT)
        || (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT)) {
        if (self.nodeWidth <= 0) {
            self.nodeWidth = maxSize.width - self.marginLeft - self.marginRight;
        }
        if (self.nodeHeight <= 0) {
            self.nodeHeight = maxSize.height - self.marginTop - self.marginBottom;
        }
        CGSize contentSize = self.contentSize;
        CGSize gridSize = CGSizeMake((contentSize.width + _itemHorizontalMargin) / _colCount - _itemHorizontalMargin,
                                     (contentSize.height + _itemVerticalMargin) / self.rowCount - _itemVerticalMargin);
        
        // Calculate size of subNodes.
        CGFloat maxSubNodeWidth = 0, maxSubNodeHeight = 0; // maximum container size of subNodes
        for (VVBaseNode *subNode in self.subNodes) {
            if (subNode.visibility == VVVisibilityGone) {
                continue;
            }
            [subNode calculateSize:gridSize];
            CGSize subNodeContainerSize = subNode.containerSize;
            if (subNode.layoutWidth != VV_MATCH_PARENT) {
                maxSubNodeWidth = MAX(maxSubNodeWidth, subNodeContainerSize.width);
            }
            if (subNode.layoutHeight != VV_MATCH_PARENT) {
                maxSubNodeHeight = MAX(maxSubNodeHeight, subNodeContainerSize.height);
            }
        }
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = (maxSubNodeWidth + _itemHorizontalMargin) * _colCount - _itemHorizontalMargin;
            self.nodeWidth += self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = (maxSubNodeHeight + _itemVerticalMargin) * self.rowCount - _itemVerticalMargin;
            self.nodeHeight += self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
        
        // Need to resize subNodes.
        self.updatingNeedsResize = YES;
        for (VVBaseNode *subNodes in self.subNodes) {
            if ([subNodes needResizeIfSuperNodeResize]) {
                [subNodes setNeedsResize];
            }
        }
        self.updatingNeedsResize = NO;
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}
@end

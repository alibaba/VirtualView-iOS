//
//  VVVHLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVVHLayout.h"

@interface VVVHLayout ()

@property (nonatomic, assign) BOOL updatingNeedsResize;

@end

@implementation VVVHLayout

- (instancetype)init
{
    if (self = [super init]) {
        _orientation = VVOrientationHorizontal;
        _gravity = VVGravityDefault;
    }
    return self;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_orientation:
                self.orientation = value;
                break;
            case STR_ID_gravity:
                self.gravity = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)needResizeIfSubNodeResize
{
    for (VVBaseNode *subNode in self.subNodes) {
        // 任意子元素尺寸要变化时都会触发这个调用
        // 在这里强制标记所有子元素需要重新布局
        [subNode setNeedsLayout];
    }
    return [super needResizeIfSubNodeResize];
}

- (void)layoutSubNodes
{
    if (_orientation == VVOrientationVertical) {
        [self vertical];
    } else {
        [self horizontal];
    }
}

- (void)vertical
{
    CGSize contentSize = self.contentSize;
    CGFloat currentY = self.paddingTop;
    if (self.gravity & (VVGravityBottom | VVGravityVCenter)) {
        CGFloat spacingHeight = contentSize.height;
        for (VVBaseNode* subNode in self.subNodes) {
            if (subNode.visibility == VVVisibilityGone) {
                continue;
            }
            [subNode calculateSize:contentSize];
            spacingHeight -= subNode.containerSize.height;
        }
        if (self.gravity & VVGravityBottom) {
            currentY += spacingHeight;
        } else if (self.gravity & VVGravityVCenter) {
            currentY += spacingHeight / 2;
        }
    }
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:contentSize];
        if ([subNode needLayout]) {
            VVGravity gravity = subNode.layoutGravity != VVGravityNone ? subNode.layoutGravity : self.gravity;

            if (gravity & VVGravityHCenter) {
                CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subNode.marginLeft - subNode.marginRight - self.paddingRight) / 2;
                subNode.nodeX = midX - subNodeSize.width / 2;
            } else if (gravity & VVGravityRight) {
                subNode.nodeX = self.nodeFrame.size.width - self.paddingRight - subNode.marginRight - subNodeSize.width;
            } else {
                subNode.nodeX = self.paddingLeft + subNode.marginLeft;
            }
            
            subNode.nodeY = currentY + subNode.marginTop;
            currentY += subNode.containerSize.height;
        }
        [subNode updateHidden];
        [subNode updateFrame];
        [subNode layoutSubNodes];
    }
}

- (void)horizontal
{
    CGSize contentSize = self.contentSize;
    CGFloat currentX = self.paddingLeft;
    if (self.gravity & (VVGravityRight | VVGravityHCenter)) {
        CGFloat spacingWidth = contentSize.width;
        for (VVBaseNode* subNode in self.subNodes) {
            if (subNode.visibility == VVVisibilityGone) {
                continue;
            }
            [subNode calculateSize:contentSize];
            spacingWidth -= subNode.containerSize.width;
        }
        if (self.gravity & VVGravityRight) {
            currentX += spacingWidth;
        } else if (self.gravity & VVGravityHCenter) {
            currentX += spacingWidth / 2;
        }
    }
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:contentSize];
        if ([subNode needLayout]) {
            subNode.nodeX = currentX + subNode.marginLeft;
            currentX += subNode.containerSize.width;
            
            VVGravity gravity = subNode.layoutGravity != VVGravityNone ? subNode.layoutGravity : self.gravity;

            if (gravity & VVGravityVCenter) {
                CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subNode.marginTop - subNode.marginBottom - self.paddingBottom) / 2;
                subNode.nodeY = midY - subNodeSize.height / 2;
            } else if (gravity & VVGravityBottom) {
                subNode.nodeY = self.nodeFrame.size.height - self.paddingBottom - subNode.marginBottom - subNodeSize.height;
            } else {
                subNode.nodeY = self.paddingTop + subNode.marginTop;
            }
        }
        [subNode updateHidden];
        [subNode updateFrame];
        [subNode layoutSubNodes];
    }
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [super calculateSize:maxSize];
    if ((self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT)
        || (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT)) {
        if (self.nodeWidth <= 0) {
            self.nodeWidth = maxSize.width - self.marginLeft - self.marginRight;
        }
        if (self.nodeHeight <= 0) {
            self.nodeHeight = maxSize.height - self.marginTop - self.marginBottom;
        }
        CGSize contentSize = self.contentSize;
    
        // Calculate size of subNodes.
        CGFloat maxSubNodeWidth = 0, maxSubNodeHeight = 0; // maximum container size of subNodes
        CGFloat totalWidth = 0, totolHeight = 0; // sum of subNodes's container size
        for (VVBaseNode *subNode in self.subNodes) {
            if (subNode.visibility == VVVisibilityGone) {
                continue;
            }
            [subNode calculateSize:contentSize];
            CGSize subNodeContainerSize = subNode.containerSize;
            if (subNode.layoutWidth != VV_MATCH_PARENT) {
                maxSubNodeWidth = MAX(maxSubNodeWidth, subNodeContainerSize.width);
            }
            if (subNode.layoutHeight != VV_MATCH_PARENT) {
                maxSubNodeHeight = MAX(maxSubNodeHeight, subNodeContainerSize.height);
            }
            totalWidth += subNodeContainerSize.width;
            totolHeight += subNodeContainerSize.height;
        }
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            if (_orientation == VVOrientationVertical) {
                self.nodeWidth = maxSubNodeWidth + self.paddingLeft + self.paddingRight;
            } else {
                self.nodeWidth = totalWidth + self.paddingLeft + self.paddingRight;
            }
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            if (_orientation == VVOrientationVertical) {
                self.nodeHeight = totolHeight + self.paddingTop + self.paddingBottom;
            } else {
                self.nodeHeight = maxSubNodeHeight + self.paddingTop + self.paddingBottom;
            }
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

//
//  VVVH2Layout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVVH2Layout.h"

@interface VVVH2Layout ()

@property (nonatomic, assign) BOOL updatingNeedsResize;

@end

@implementation VVVH2Layout

-(instancetype)init
{
    if (self = [super init]) {
        _orientation = VVOrientationHorizontal;
    }
    return self;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [ super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_orientation:
                _orientation = value;
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
    CGFloat currentTopY = self.paddingTop;
    CGFloat currentBottomY = self.nodeHeight - self.paddingBottom;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:contentSize];
        if ([subNode needLayout]) {
            if (subNode.layoutGravity & VVGravityHCenter) {
                CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subNode.marginLeft - subNode.marginRight - self.paddingRight) / 2;
                subNode.nodeX = midX - subNodeSize.width / 2;
            } else if (subNode.layoutGravity & VVGravityRight) {
                subNode.nodeX = self.nodeFrame.size.width - self.paddingRight - subNode.marginRight - subNodeSize.width;
            } else {
                subNode.nodeX = self.paddingLeft + subNode.marginLeft;
            }
            
            if (subNode.layoutDirection & VVDirectionBottom) {
                subNode.nodeY = currentBottomY - subNode.marginBottom - subNodeSize.height;
                currentBottomY -= subNode.containerSize.height;
            } else {
                subNode.nodeY = currentTopY + subNode.marginTop;
                currentTopY += subNode.containerSize.height;
            }
        }
        [subNode updateHidden];
        [subNode updateFrame];
        [subNode layoutSubNodes];
    }
}

- (void)horizontal
{
    CGSize contentSize = self.contentSize;
    CGFloat currentLeftX = self.paddingLeft;
    CGFloat currentRightX = self.nodeWidth - self.paddingRight;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:contentSize];
        if ([subNode needLayout]) {
            if (subNode.layoutDirection & VVDirectionRight) {
                subNode.nodeX = currentRightX - subNode.marginRight - subNodeSize.width;
                currentRightX -= subNode.containerSize.width;
            } else {
                subNode.nodeX = currentLeftX + subNode.marginLeft;
                currentLeftX += subNode.containerSize.width;
            }
            
            if (subNode.layoutGravity & VVGravityVCenter) {
                CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subNode.marginTop - subNode.marginBottom - self.paddingBottom) / 2;
                subNode.nodeY = midY - subNodeSize.height / 2;
            } else if (subNode.layoutGravity & VVGravityBottom) {
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

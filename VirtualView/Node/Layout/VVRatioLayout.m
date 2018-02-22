//
//  VVRatioLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVRatioLayout.h"

@interface VVRatioLayout ()

@property (nonatomic, assign) BOOL updatingNeedsResize;

@end

@implementation VVRatioLayout

- (instancetype)init
{
    if (self = [super init]) {
        _orientation = VVOrientationHorizontal;
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
    CGFloat totalHeight = contentSize.height, totalRatio = 0;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            continue;
        }
        if (subNode.layoutRatio <= 0) {
            [subNode calculateSize:contentSize];
            totalHeight -= subNode.containerSize.height;
        } else {
            totalRatio += subNode.layoutRatio;
            totalHeight -= subNode.marginTop + subNode.marginBottom;
        }
    }
    CGFloat currentY = self.paddingTop;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        [subNode calculateSize:contentSize];
        if (subNode.layoutRatio > 0) {
            subNode.nodeHeight = totalHeight / totalRatio * subNode.layoutRatio;
            [subNode applyAutoDim];
        }
        if ([subNode needLayout]) {
            CGSize subNodeSize = subNode.contentSize;
            
            if (subNode.layoutGravity & VVGravityHCenter) {
                CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subNode.marginLeft - subNode.marginRight - self.paddingRight) / 2;
                subNode.nodeX = midX - subNodeSize.width / 2;
            } else if (subNode.layoutGravity & VVGravityRight) {
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
    CGFloat totalWidth = contentSize.width, totalRatio = 0;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            continue;
        }
        if (subNode.layoutRatio <= 0) {
            [subNode calculateSize:contentSize];
            totalWidth -= subNode.containerSize.width;
        } else {
            totalRatio += subNode.layoutRatio;
            totalWidth -= subNode.marginLeft + subNode.marginRight;
        }
    }
    CGFloat currentX = self.paddingLeft;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            [subNode updateHiddenRecursively];
            continue;
        }
        [subNode calculateSize:contentSize];
        if (subNode.layoutRatio > 0) {
            subNode.nodeWidth = totalWidth / totalRatio * subNode.layoutRatio;
            [subNode applyAutoDim];
        }
        if ([subNode needLayout]) {
            CGSize subNodeSize = subNode.contentSize;
            
            subNode.nodeX = currentX + subNode.marginLeft;
            currentX += subNode.containerSize.width;
            
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
        [self applyAutoDim];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

@end

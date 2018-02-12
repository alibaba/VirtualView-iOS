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
    CGFloat currentY = self.paddingTop;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            continue;
        }
        if ([subNode needLayout]) {
            CGSize subNodeSize = [subNode calculateSize:contentSize];
            
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
    CGFloat currentX = self.paddingLeft;
    for (VVBaseNode* subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            continue;
        }
        if ([subNode needLayout]) {
            CGSize subNodeSize = [subNode calculateSize:contentSize];
            
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
            self.nodeWidth = maxSize.width;
        }
        if (self.nodeHeight <= 0) {
            self.nodeHeight = maxSize.height;
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
            maxSubNodeWidth = MAX(maxSubNodeWidth, subNodeContainerSize.width);
            maxSubNodeHeight = MAX(maxSubNodeHeight, subNodeContainerSize.height);
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

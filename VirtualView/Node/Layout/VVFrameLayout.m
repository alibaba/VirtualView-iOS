//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout

//- (void)setNodeFrame:(CGRect)nodeFrame
//{
//    if (CGSizeEqualToSize(nodeFrame.size, self.nodeFrame.size) == NO) {
//        if (self.supernode && [self.supernode isWarpContent]) {
//            [self.supernode setNeedsLayout];
//        }
//        for (VVBaseNode *subnode in self.subnodes) {
//            if ([subnode isMatchParent]) {
//                [subnode setNeedsLayout];
//            }
//        }
//    }
//    [super setNodeFrame:nodeFrame];
//}

- (void)layoutSubnodes
{
    CGSize contentSize = self.nodeFrame.size;
    contentSize.width -= self.paddingLeft + self.paddingRight;
    contentSize.height -= self.paddingTop + self.paddingBottom;
    for (VVBaseNode *subnode in self.subnodes) {
        if (subnode.visibility == VVVisibilityGone) {
            continue;
        }
        CGSize nodeSize = CGSizeMake(contentSize.width - subnode.marginLeft - subnode.marginRight,
                                     contentSize.height - subnode.marginTop - subnode.marginBottom);
        nodeSize = [subnode calculateSize:nodeSize];

        CGFloat itemX;
        if ((subnode.layoutGravity & VVGravityHCenter) > 0) {
            CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subnode.marginLeft - subnode.marginRight - self.paddingRight) / 2;
            itemX = midX - nodeSize.width / 2;
        } else if((subnode.layoutGravity & VVGravityRight) > 0) {
            itemX = self.nodeFrame.size.width - self.paddingRight - subnode.marginRight - nodeSize.width;
        } else {
            itemX = self.paddingLeft + subnode.marginLeft;
        }
        
        CGFloat itemY;
        if ((subnode.layoutGravity & VVGravityVCenter) > 0) {
            CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subnode.marginTop - subnode.marginBottom - self.paddingBottom) / 2;
            itemY = midY - nodeSize.height / 2;
        } else if ((subnode.layoutGravity & VVGravityBottom) > 0) {
            itemY = self.nodeFrame.size.height - self.paddingBottom - subnode.marginBottom - nodeSize.height;
        } else {
            itemY = self.paddingTop + subnode.marginTop;
        }
        
        subnode.nodeFrame = CGRectMake(itemX, itemY, nodeSize.width, nodeSize.height);
        [subnode layoutSubnodes];
    }
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [super calculateSize:maxSize];
    if ((self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT)
        || (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT)) {
        CGSize contentSize;
        contentSize.width = self.nodeWidth > 0 ? self.nodeWidth : maxSize.width;
        contentSize.height = self.nodeHeight > 0 ? self.nodeHeight : maxSize.height;
        contentSize.width -= self.paddingLeft + self.paddingRight;
        contentSize.height -= self.paddingTop + self.paddingBottom;
        CGFloat maxContentWidth = 0, maxContentHeight = 0;
        for (VVBaseNode *subnode in self.subnodes) {
            if (subnode.visibility == VVVisibilityGone) {
                continue;
            }
            if (self.layoutWidth == VV_WRAP_CONTENT && (subnode.layoutGravity & VVGravityLeft) == 0) {
#ifdef VV_DEBUG
                NSAssert(NO, @"VV_WRAP_CONTENT must work with VVGravityLeft.");
#endif
                subnode.layoutGravity = (subnode.layoutGravity & VVGravityY) | VVGravityLeft;
            }
            if (self.layoutHeight == VV_WRAP_CONTENT && (subnode.layoutGravity & VVGravityTop) == 0) {
#ifdef VV_DEBUG
                NSAssert(NO, @"VV_WRAP_CONTENT must work with VVGravityTop.");
#endif
                subnode.layoutGravity = (subnode.layoutGravity & VVGravityX) | VVGravityTop;
            }
            CGSize nodeSize = CGSizeMake(contentSize.width - subnode.marginLeft - subnode.marginRight,
                                         contentSize.height - subnode.marginTop - subnode.marginBottom);
            nodeSize = [subnode calculateSize:nodeSize];
            nodeSize.width += subnode.marginLeft + subnode.marginRight;
            nodeSize.height += subnode.marginTop + subnode.marginBottom;
            if (nodeSize.width > maxContentWidth) {
                maxContentWidth = nodeSize.width;
            }
            if (nodeSize.height > maxContentHeight) {
                maxContentHeight = nodeSize.height;
            }
        }
        if (self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = maxContentWidth + self.paddingLeft + self.paddingRight;
        }
        if (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = maxContentHeight + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

@end

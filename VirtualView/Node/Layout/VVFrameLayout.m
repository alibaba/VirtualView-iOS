//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout

- (void)layoutSubNodes
{
    CGSize contentSize = self.contentSize;
    for (VVBaseNode *subNode in self.subNodes) {
        if (subNode.visibility == VVVisibilityGone) {
            continue;
        }
        CGSize subNodeSize = [subNode calculateSize:contentSize];

        CGFloat itemX;
        if ((subNode.layoutGravity & VVGravityHCenter) > 0) {
            CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subNode.marginLeft - subNode.marginRight - self.paddingRight) / 2;
            itemX = midX - subNodeSize.width / 2;
        } else if((subNode.layoutGravity & VVGravityRight) > 0) {
            itemX = self.nodeFrame.size.width - self.paddingRight - subNode.marginRight - subNodeSize.width;
        } else {
            itemX = self.paddingLeft + subNode.marginLeft;
        }
        
        CGFloat itemY;
        if ((subNode.layoutGravity & VVGravityVCenter) > 0) {
            CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subNode.marginTop - subNode.marginBottom - self.paddingBottom) / 2;
            itemY = midY - subNodeSize.height / 2;
        } else if ((subNode.layoutGravity & VVGravityBottom) > 0) {
            itemY = self.nodeFrame.size.height - self.paddingBottom - subNode.marginBottom - subNodeSize.height;
        } else {
            itemY = self.paddingTop + subNode.marginTop;
        }
        
        subNode.nodeFrame = CGRectMake(itemX + self.nodeFrame.origin.x,
                                       itemY + self.nodeFrame.origin.y,
                                       subNodeSize.width,
                                       subNodeSize.height);
        [subNode layoutIfNeeded];
    }
    [super layoutSubNodes];
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
        CGFloat maxSubNodeWidth = 0, maxSubNodeHeight = 0; // maximum container size of subNodes
        for (VVBaseNode *subNode in self.subNodes) {
            if (subNode.visibility == VVVisibilityGone) {
                continue;
            }
            [subNode calculateSize:contentSize];
            CGSize subNodeContainerSize = subNode.containerSize;
            maxSubNodeWidth = MAX(maxSubNodeWidth, subNodeContainerSize.width);
            maxSubNodeHeight = MAX(maxSubNodeHeight, subNodeContainerSize.height);
        }
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = maxSubNodeWidth + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = maxSubNodeHeight + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
        
        // Need to relayout subNodes.
        [self setSubNodeNeedsLayout];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

@end

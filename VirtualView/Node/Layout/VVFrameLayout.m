//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout

- (void)layoutSubnodes
{
    CGSize contentSize = self.contentSize;
    for (VVBaseNode *subnode in self.subnodes) {
        if (subnode.visibility == VVVisibilityGone) {
            continue;
        }
        CGSize subnodeSize = [subnode calculateSize:contentSize];

        CGFloat itemX;
        if ((subnode.layoutGravity & VVGravityHCenter) > 0) {
            CGFloat midX = (self.nodeFrame.size.width + self.paddingLeft + subnode.marginLeft - subnode.marginRight - self.paddingRight) / 2;
            itemX = midX - subnodeSize.width / 2;
        } else if((subnode.layoutGravity & VVGravityRight) > 0) {
            itemX = self.nodeFrame.size.width - self.paddingRight - subnode.marginRight - subnodeSize.width;
        } else {
            itemX = self.paddingLeft + subnode.marginLeft;
        }
        
        CGFloat itemY;
        if ((subnode.layoutGravity & VVGravityVCenter) > 0) {
            CGFloat midY = (self.nodeFrame.size.height + self.paddingTop + subnode.marginTop - subnode.marginBottom - self.paddingBottom) / 2;
            itemY = midY - subnodeSize.height / 2;
        } else if ((subnode.layoutGravity & VVGravityBottom) > 0) {
            itemY = self.nodeFrame.size.height - self.paddingBottom - subnode.marginBottom - subnodeSize.height;
        } else {
            itemY = self.paddingTop + subnode.marginTop;
        }
        
        subnode.nodeFrame = CGRectMake(itemX + self.nodeFrame.origin.x,
                                       itemY + self.nodeFrame.origin.y,
                                       subnodeSize.width,
                                       subnodeSize.height);
        [subnode layoutIfNeeded];
    }
    [super layoutSubnodes];
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
        CGFloat maxSubnodeWidth = 0, maxSubnodeHeight = 0; // maximum container size of subnodes
        for (VVBaseNode *subnode in self.subnodes) {
            if (subnode.visibility == VVVisibilityGone) {
                continue;
            }
            [subnode calculateSize:contentSize];
            CGSize subnodeContainerSize = subnode.containerSize;
            maxSubnodeWidth = MAX(maxSubnodeWidth, subnodeContainerSize.width);
            maxSubnodeHeight = MAX(maxSubnodeHeight, subnodeContainerSize.height);
        }
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = maxSubnodeWidth + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = maxSubnodeHeight + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
        
        // Need to relayout subnodes.
        [self setSubnodeNeedsLayout];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

@end

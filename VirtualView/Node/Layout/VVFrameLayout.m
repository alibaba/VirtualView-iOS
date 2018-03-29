//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@interface VVFrameLayout ()

@property (nonatomic, assign) BOOL updatingNeedsResize;

@end

@implementation VVFrameLayout

- (instancetype)init
{
    if (self = [super init]) {
        _gravity = VVGravityDefault;
    }
    return self;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        if (key == STR_ID_gravity) {
            self.gravity = value;
            ret = YES;
        }
    }
    return ret;
}

- (void)layoutSubNodes
{
    CGSize contentSize = self.contentSize;
    for (VVBaseNode *subNode in self.subNodes) {
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
        }
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = maxSubNodeWidth + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = maxSubNodeHeight + self.paddingTop + self.paddingBottom;
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

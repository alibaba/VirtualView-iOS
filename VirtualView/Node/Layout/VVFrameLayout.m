//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout
- (void)layoutSubnodes{
    [super layoutSubnodes];
    for (VVBaseNode* vvObj in self.subViews) {
        if(vvObj.visibility==VVVisibilityGone){
            continue;
        }
        CGFloat pX=self.nodeFrame.origin.x+self.paddingLeft,pY=self.nodeFrame.origin.y+self.paddingTop;
        CGFloat blanceW = (self.nodeWidth-self.paddingLeft-self.paddingRight-vvObj.nodeWidth-vvObj.layoutMarginLeft-vvObj.layoutMarginRight)/2.0;
        CGFloat blanceH = (self.nodeHeight-self.paddingTop-self.paddingBottom-vvObj.nodeHeight-vvObj.layoutMarginTop-vvObj.layoutMarginBottom)/2.0;
        if((vvObj.layoutGravity&VVGravityHCenter)==VVGravityHCenter){
            //
            pX += blanceW<0?0:blanceW;
        }else if((vvObj.layoutGravity&VVGravityRight)!=0){
            pX = pX+blanceW*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pX += 0;
        }
        
        if((vvObj.layoutGravity&VVGravityVCenter)==VVGravityVCenter){
            //
            pY += blanceH<0?0:blanceH;
        }else if((vvObj.layoutGravity&VVGravityBottom)!=0){
            pY = pY+blanceH*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pY += 0;
        }
        vvObj.nodeFrame = CGRectMake(pX+vvObj.layoutMarginLeft, pY+vvObj.layoutMarginTop, vvObj.nodeWidth, vvObj.nodeHeight);
        [vvObj layoutSubnodes];
        
    }
}
- (CGSize)calculateSize:(CGSize)maxSize{
    CGFloat maxWidth=0,maxHeight=0;
    CGSize contentSize = maxSize;
    
    if (self.layoutHeight!=VV_MATCH_PARENT && self.layoutHeight!=VV_WRAP_CONTENT) {
        contentSize.height = self.nodeHeight;
    }
    
    if (self.layoutWidth!=VV_MATCH_PARENT && self.layoutWidth!=VV_WRAP_CONTENT) {
        contentSize.width = self.nodeWidth;
    }
    
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            contentSize.height = contentSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case VVAutoDimDirectionY:
            contentSize.width = contentSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }

    contentSize.width -= self.paddingLeft + self.paddingRight;
    contentSize.height -= self.paddingTop + self.paddingBottom;
    
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    for (VVBaseNode* vvObj in self.subViews) {
        if (vvObj.visibility==VVVisibilityGone) {
            continue;
        }else if(self.layoutWidth==VV_WRAP_CONTENT && vvObj.layoutWidth==VV_MATCH_PARENT) {
            [tmpArray addObject:vvObj];
            continue;
        }
        CGSize itemSize = [vvObj calculateSize:CGSizeMake(contentSize.width-vvObj.layoutMarginLeft-vvObj.layoutMarginRight, contentSize.height-vvObj.layoutMarginTop-vvObj.layoutMarginBottom)];
        itemSize.width+=vvObj.layoutMarginLeft+vvObj.layoutMarginRight;
        itemSize.height+=vvObj.layoutMarginTop+vvObj.layoutMarginBottom;
        maxWidth = maxWidth<itemSize.width?itemSize.width:maxWidth;
        maxHeight= maxHeight<itemSize.height?itemSize.height:maxHeight;
    }
    
    switch ((int)self.layoutWidth) {
        case VV_WRAP_CONTENT:
            //
            self.nodeWidth = self.paddingRight+self.paddingLeft+maxWidth;
            break;
        case VV_MATCH_PARENT:
            self.nodeWidth = maxSize.width;
            
            break;
        default:
            self.nodeWidth = self.layoutWidth;
            break;
    }
    
    self.nodeWidth = self.nodeWidth<maxSize.width?self.nodeWidth:maxSize.width;
    
    
    switch ((int)self.layoutHeight) {
        case VV_WRAP_CONTENT:
            //
            self.nodeHeight = self.paddingTop+self.paddingBottom+maxHeight;
            break;
        case VV_MATCH_PARENT:
            self.nodeHeight = maxSize.height;
            
            break;
        default:
            self.nodeHeight = self.layoutHeight;
            break;
    }
    
    self.nodeHeight = self.nodeHeight<maxSize.height?self.nodeHeight:maxSize.height;
    
    
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            self.nodeHeight = self.nodeWidth*(self.autoDimY/self.autoDimX);
            break;
        case VVAutoDimDirectionY:
            self.nodeWidth = self.nodeHeight*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }

    //[self autoDim];
    
    CGSize tmpSize = CGSizeMake(self.nodeWidth, self.nodeHeight);
    for (VVBaseNode* vvObj in tmpArray) {
        [vvObj calculateSize:tmpSize];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
    
}

@end

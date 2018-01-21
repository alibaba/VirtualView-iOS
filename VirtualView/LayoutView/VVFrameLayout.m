//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout
- (void)layoutSubviews{
    [super layoutSubviews];
    for (VVBaseNode* vvObj in self.subViews) {
        if(vvObj.visible==VVVisibilityGone){
            continue;
        }
        CGFloat pX=self.frame.origin.x+self.paddingLeft,pY=self.frame.origin.y+self.paddingTop;
        CGFloat blanceW = (self.width-self.paddingLeft-self.paddingRight-vvObj.width-vvObj.marginLeft-vvObj.marginRight)/2.0;
        CGFloat blanceH = (self.height-self.paddingTop-self.paddingBottom-vvObj.height-vvObj.marginTop-vvObj.marginBottom)/2.0;
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
        vvObj.frame = CGRectMake(pX+vvObj.marginLeft, pY+vvObj.marginTop, vvObj.width, vvObj.height);
        [vvObj layoutSubviews];
        
    }
}
- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    CGFloat maxWidth=0,maxHeight=0;
    CGSize contentSize = maxSize;
    
    if (self.heightModle!=VV_MATCH_PARENT && self.heightModle!=VV_WRAP_CONTENT) {
        contentSize.height = self.height;
    }
    
    if (self.widthModle!=VV_MATCH_PARENT && self.widthModle!=VV_WRAP_CONTENT) {
        contentSize.width = self.width;
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
        if (vvObj.visible==VVVisibilityGone) {
            continue;
        }else if(self.widthModle==VV_WRAP_CONTENT && vvObj.widthModle==VV_MATCH_PARENT) {
            [tmpArray addObject:vvObj];
            continue;
        }
        CGSize itemSize = [vvObj calculateLayoutSize:CGSizeMake(contentSize.width-vvObj.marginLeft-vvObj.marginRight, contentSize.height-vvObj.marginTop-vvObj.marginBottom)];
        itemSize.width+=vvObj.marginLeft+vvObj.marginRight;
        itemSize.height+=vvObj.marginTop+vvObj.marginBottom;
        maxWidth = maxWidth<itemSize.width?itemSize.width:maxWidth;
        maxHeight= maxHeight<itemSize.height?itemSize.height:maxHeight;
    }
    
    switch ((int)self.widthModle) {
        case VV_WRAP_CONTENT:
            //
            self.width = self.paddingRight+self.paddingLeft+maxWidth;
            break;
        case VV_MATCH_PARENT:
            self.width = maxSize.width;
            
            break;
        default:
            self.width = self.widthModle;
            break;
    }
    
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    
    
    switch ((int)self.heightModle) {
        case VV_WRAP_CONTENT:
            //
            self.height = self.paddingTop+self.paddingBottom+maxHeight;
            break;
        case VV_MATCH_PARENT:
            self.height = maxSize.height;
            
            break;
        default:
            self.height = self.heightModle;
            break;
    }
    
    self.height = self.height<maxSize.height?self.height:maxSize.height;
    
    
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            self.height = self.width*(self.autoDimY/self.autoDimX);
            break;
        case VVAutoDimDirectionY:
            self.width = self.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }

    //[self autoDim];
    
    CGSize tmpSize = CGSizeMake(self.width, self.height);
    for (VVBaseNode* vvObj in tmpArray) {
        [vvObj calculateLayoutSize:tmpSize];
    }
    return CGSizeMake(self.width, self.height);
    
}

@end

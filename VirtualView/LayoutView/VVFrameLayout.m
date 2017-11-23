//
//  VVFrameLayout.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@implementation VVFrameLayout
- (void)layoutSubviews{
    [super layoutSubviews];
    for (VVViewObject* vvObj in self.subViews) {
        if(vvObj.visible==GONE){
            continue;
        }
        CGFloat pX=self.frame.origin.x+self.paddingLeft,pY=self.frame.origin.y+self.paddingTop;
        CGFloat blanceW = (self.width-self.paddingLeft-self.paddingRight-vvObj.width-vvObj.marginLeft-vvObj.marginRight)/2.0;
        CGFloat blanceH = (self.height-self.paddingTop-self.paddingBottom-vvObj.height-vvObj.marginTop-vvObj.marginBottom)/2.0;
        if((vvObj.layoutGravity&Gravity_H_CENTER)==Gravity_H_CENTER){
            //
            pX += blanceW<0?0:blanceW;
        }else if((vvObj.layoutGravity&Gravity_RIGHT)!=0){
            pX = pX+blanceW*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pX += 0;
        }
        
        if((vvObj.layoutGravity&Gravity_V_CENTER)==Gravity_V_CENTER){
            //
            pY += blanceH<0?0:blanceH;
        }else if((vvObj.layoutGravity&Gravity_BOTTOM)!=0){
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
    
    if (self.heightModle!=MATCH_PARENT && self.heightModle!=WRAP_CONTENT) {
        contentSize.height = self.height;
    }
    
    if (self.widthModle!=MATCH_PARENT && self.widthModle!=WRAP_CONTENT) {
        contentSize.width = self.width;
    }
    
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            contentSize.height = contentSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case AUTO_DIM_DIR_Y:
            contentSize.width = contentSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }

    contentSize.width -= self.paddingLeft + self.paddingRight;
    contentSize.height -= self.paddingTop + self.paddingBottom;
    
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    for (VVViewObject* vvObj in self.subViews) {
        if (vvObj.visible==GONE) {
            continue;
        }else if(self.widthModle==WRAP_CONTENT && vvObj.widthModle==MATCH_PARENT) {
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
        case WRAP_CONTENT:
            //
            self.width = self.paddingRight+self.paddingLeft+maxWidth;
            break;
        case MATCH_PARENT:
            self.width = maxSize.width;
            
            break;
        default:
            self.width = self.widthModle;
            break;
    }
    
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            self.height = self.paddingTop+self.paddingBottom+maxHeight;
            break;
        case MATCH_PARENT:
            self.height = maxSize.height;
            
            break;
        default:
            self.height = self.heightModle;
            break;
    }
    
    self.height = self.height<maxSize.height?self.height:maxSize.height;
    
    
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            self.height = self.width*(self.autoDimY/self.autoDimX);
            break;
        case AUTO_DIM_DIR_Y:
            self.width = self.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }

    //[self autoDim];
    
    CGSize tmpSize = CGSizeMake(self.width, self.height);
    for (VVViewObject* vvObj in tmpArray) {
        [vvObj calculateLayoutSize:tmpSize];
    }
    return CGSizeMake(self.width, self.height);
    
}

@end

//
//  VVRatioLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVRatioLayout.h"
@interface VVRatioLayout (){
    CGFloat   _totalRatio;
    CGFloat   _invalidHSize;
    CGFloat   _invalidVSize;
}
@end

@implementation VVRatioLayout
- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_orientation:
                self.orientation = value;
                break;
                
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (void)vertical{
    CGFloat pY = self.nodeFrame.origin.y + self.paddingTop ;
    //CGFloat validSize = self.height-_invalidHSize-self.paddingTop-self.paddingBottom;
    
    for (VVBaseNode* vvObj in self.subNodes) {
        if(vvObj.visibility==VVVisibilityGone){
            continue;
        }
        pY+=vvObj.marginTop;
        CGFloat pX = self.nodeFrame.origin.x + self.paddingLeft;
        
        CGFloat blanceW = (self.nodeWidth-vvObj.nodeWidth-vvObj.marginLeft-vvObj.marginRight)/2.0;
        //CGFloat blanceH = (self.height-vvObj.height-vvObj.marginTop-vvObj.marginBottom)/2.0;
        
         if((vvObj.layoutGravity&VVGravityHCenter)==VVGravityHCenter){
         //
         pX += vvObj.marginLeft+blanceW;
         }else if((vvObj.layoutGravity&VVGravityRight)!=0){
         pX += vvObj.marginLeft+blanceW*2;//(blanceW<0?0:blanceW)*2.0;
         }else{
         pX += vvObj.marginLeft;
         }
        /*
        if((vvObj.layoutGravity&VVGravityVCenter)==VVGravityVCenter){
            //
            pY += blanceH<0?0:blanceH;
        }else if((vvObj.layoutGravity&VVGravityBottom)!=0){
            pY = pY+blanceH*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pY += 0;
        }*/
        //CGFloat height = validSize*vvObj.layoutRatio/_totalRatio;
        
        self.nodeX = pX;
        self.nodeY = pY;
        [vvObj updateFrame];
        pY+=vvObj.nodeHeight+vvObj.marginBottom;
        [vvObj layoutSubNodes];
        
    }
}

- (void)horizontal{
    //
    CGFloat pX = self.paddingLeft ;
    //CGFloat validSize = self.width-_invalidHSize-self.paddingLeft-self.paddingRight;
    
    for (VVBaseNode* vvObj in self.subNodes) {
        if(vvObj.visibility==VVVisibilityGone){
            continue;
        }
        pX+=vvObj.marginLeft;
        CGFloat pY = self.paddingTop;
        
        CGFloat itemHeight = vvObj.layoutHeight == VV_MATCH_PARENT ? self.nodeHeight : vvObj.nodeHeight;
        CGFloat blanceH = (self.nodeHeight-itemHeight-vvObj.marginTop-vvObj.marginBottom)/2.0;
        /*
        if((vvObj.layoutGravity&VVGravityHCenter)==VVGravityHCenter){
            //
            pX += blanceW<0?0:blanceW;
        }else if((vvObj.layoutGravity&VVGravityRight)!=0){
            pX = pX+blanceW*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pX += 0;
        }*/
        
        if((vvObj.layoutGravity&VVGravityVCenter)==VVGravityVCenter){
            //
            pY += vvObj.marginTop+blanceH;
        }else if((vvObj.layoutGravity&VVGravityBottom)!=0){
            pY += vvObj.marginTop+blanceH*2;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pY += vvObj.marginTop;
        }
        //CGFloat width = validSize*vvObj.layoutRatio/_totalRatio;
        
        self.nodeX = pX;
        self.nodeY = pY;
        [vvObj updateFrame];
        pX+=vvObj.nodeWidth+vvObj.marginRight;
        [vvObj layoutSubNodes];
        
    }
}

- (void)layoutSubNodes{
    [super layoutSubNodes];
    
    switch (self.orientation) {
        case VVOrientationVertical:
            [self vertical];
            break;
        default:
            [self horizontal];
            break;
    }
}

- (CGSize)calculateSize:(CGSize)maxSize{
    _totalRatio = 0;
    CGSize itemSize = {0,0};
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
           maxSize.height = maxSize.width*(self.autoDimY/self.autoDimX);
            break;
        case VVAutoDimDirectionY:
           maxSize.width = maxSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    NSMutableArray* ratioSubViews   = [[NSMutableArray alloc] init];
    NSMutableArray* noratioSubViews = [[NSMutableArray alloc] init];
    
    CGSize blanceSize = CGSizeMake(maxSize.width-self.paddingLeft-self.paddingRight, maxSize.height-self.paddingTop-self.paddingBottom);
    
    for (VVBaseNode* vvObj in self.subNodes) {
        _totalRatio += vvObj.layoutRatio;
        if (vvObj.layoutRatio>0) {
            [ratioSubViews addObject:vvObj];
        }else{
            [noratioSubViews addObject:vvObj];
        }
        _invalidHSize+= vvObj.marginLeft+vvObj.marginRight;
        _invalidVSize+= vvObj.marginTop+vvObj.marginBottom;
    }
    
    for (VVBaseNode* vvObj in noratioSubViews) {
        //
        CGSize size = [vvObj calculateSize:blanceSize];
        if (self.orientation==VVOrientationHorizontal) {
            blanceSize.width = blanceSize.width - size.width;
        }else{
            blanceSize.height = blanceSize.height - size.height;
        }
        itemSize.width  += size.width;
        itemSize.height += size.height;
    }
    
    for (VVBaseNode* vvObj in ratioSubViews) {
        //
        CGSize size={0,0};
        if (self.orientation==VVOrientationHorizontal) {
            //
            size.width  = blanceSize.width*vvObj.layoutRatio/_totalRatio;
            size.height = blanceSize.height;
        }else{
            size.height = blanceSize.height*vvObj.layoutRatio/_totalRatio;
            size.width  = blanceSize.width;
        }
        
        [vvObj calculateSize:size];
        if (self.orientation==VVOrientationHorizontal) {
            vvObj.nodeWidth = size.width;
        }else{
            vvObj.nodeHeight = size.height;
        }
        
        itemSize.width  += size.width;
        itemSize.height += size.height;
    }
    
//    for (VVBaseNode* vvObj in self.subViews) {
//        _totalRatio += vvObj.layoutRatio;
//        _invalidHSize+= vvObj.marginLeft+vvObj.marginRight;
//        _invalidVSize+= vvObj.marginTop+vvObj.marginBottom;
//        CGSize itemSize = [vvObj calculateLayoutSize:maxSize];
//    }
    
    switch ((int)self.layoutWidth) {
        case VV_WRAP_CONTENT:
            //
            self.nodeWidth = self.paddingRight+self.paddingLeft+itemSize.width;
            break;
        case VV_MATCH_PARENT:
            self.nodeWidth=maxSize.width;
            
            break;
        default:
            self.nodeWidth = self.paddingRight+self.paddingLeft+self.nodeWidth;
            break;
    }
    self.nodeWidth = self.nodeWidth<maxSize.width?self.nodeWidth:maxSize.width;
    
    
    switch ((int)self.layoutHeight) {
        case VV_WRAP_CONTENT:
            //
            self.nodeHeight = self.paddingTop+self.paddingBottom+itemSize.height;
            break;
        case VV_MATCH_PARENT:
            self.nodeHeight=maxSize.height;
            
            break;
        default:
            self.nodeHeight = self.paddingTop+self.paddingBottom+self.nodeHeight;
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
    return CGSizeMake(self.nodeWidth, self.nodeHeight);

}
@end

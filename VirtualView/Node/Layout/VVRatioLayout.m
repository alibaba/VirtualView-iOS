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
    CGFloat pY = self.frame.origin.y + self.paddingTop ;
    //CGFloat validSize = self.height-_invalidHSize-self.paddingTop-self.paddingBottom;
    
    for (VVBaseNode* vvObj in self.subViews) {
        if(vvObj.visible==VVVisibilityGone){
            continue;
        }
        pY+=vvObj.marginTop;
        CGFloat pX = self.frame.origin.x + self.paddingLeft;
        
        CGFloat blanceW = (self.width-vvObj.width-vvObj.marginLeft-vvObj.marginRight)/2.0;
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
        
        vvObj.frame = CGRectMake(pX, pY, vvObj.width, vvObj.height);
        pY+=vvObj.height+vvObj.marginBottom;
        [vvObj layoutSubviews];
        
    }
}

- (void)horizontal{
    //
    CGFloat pX = self.frame.origin.x + self.paddingLeft ;
    //CGFloat validSize = self.width-_invalidHSize-self.paddingLeft-self.paddingRight;
    
    for (VVBaseNode* vvObj in self.subViews) {
        if(vvObj.visible==VVVisibilityGone){
            continue;
        }
        pX+=vvObj.marginLeft;
        CGFloat pY = self.frame.origin.y + self.paddingTop;
        
        CGFloat itemHeight = vvObj.heightModle == VV_MATCH_PARENT ? self.height : vvObj.height;
        CGFloat blanceH = (self.height-itemHeight-vvObj.marginTop-vvObj.marginBottom)/2.0;
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
        
        vvObj.frame = CGRectMake(pX, pY, vvObj.width, itemHeight);
        pX+=vvObj.width+vvObj.marginRight;
        [vvObj layoutSubviews];
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.orientation) {
        case VVOrientationVertical:
            [self vertical];
            break;
        default:
            [self horizontal];
            break;
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
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
    
    for (VVBaseNode* vvObj in self.subViews) {
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
        CGSize size = [vvObj calculateLayoutSize:blanceSize];
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
        
        [vvObj calculateLayoutSize:size];
        if (self.orientation==VVOrientationHorizontal) {
            vvObj.width = size.width;
        }else{
            vvObj.height = size.height;
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
    
    switch ((int)self.widthModle) {
        case VV_WRAP_CONTENT:
            //
            self.width = self.paddingRight+self.paddingLeft+itemSize.width;
            break;
        case VV_MATCH_PARENT:
            self.width=maxSize.width;
            
            break;
        default:
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
    }
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    
    
    switch ((int)self.heightModle) {
        case VV_WRAP_CONTENT:
            //
            self.height = self.paddingTop+self.paddingBottom+itemSize.height;
            break;
        case VV_MATCH_PARENT:
            self.height=maxSize.height;
            
            break;
        default:
            self.height = self.paddingTop+self.paddingBottom+self.height;
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
    return CGSizeMake(self.width, self.height);

}
@end

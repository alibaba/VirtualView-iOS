//
//  NVFoundationView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "NVFoundationView.h"

@implementation NVFoundationView
- (CGSize)nativeContentSize{
    return CGSizeZero;
}

- (void)layoutSubviews{
    
    //CGSize contentsize = [self nativeContentSize];
    
    CGFloat pY =0, pX=0;
    if ((self.gravity & Gravity_TOP)==Gravity_TOP) {
        pY += self.paddingTop;
    }else if ((self.gravity & Gravity_V_CENTER)==Gravity_V_CENTER){
        pY += (self.maxSize.height-self.paddingTop-self.paddingBottom-self.height)/2.0;
    }else{
        pY = pY+self.maxSize.height-self.paddingBottom-self.height;
    }
    
    if ((self.gravity & Gravity_RIGHT)==Gravity_RIGHT) {
        pX += self.maxSize.width-self.paddingRight-self.width;
    }else if ((self.gravity & Gravity_H_CENTER)==Gravity_H_CENTER){
        pX += (self.maxSize.width-self.paddingLeft-self.paddingRight-self.width)/2.0;
    }else{
        pX = self.paddingLeft;
    }
    
    self.cocoaView.frame = CGRectMake(self.frame.origin.x+pX, self.frame.origin.y+pY, self.width-self.paddingLeft-self.paddingRight,self.height-self.paddingTop-self.paddingBottom);
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    self.maxSize = maxSize;
    self.maxCotentSize = CGSizeMake(maxSize.width-self.paddingLeft-self.paddingRight, maxSize.height-self.paddingTop-self.paddingBottom);
    CGSize contentsize = [self nativeContentSize];
    
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            //
            self.width = contentsize.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
        case MATCH_PARENT:
            self.width=maxSize.width;
            //_textSize.width = self.width;
            break;
        default:
            //contentsize.width = self.width;
            self.width = self.widthModle;
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            self.height= contentsize.height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
        case MATCH_PARENT:
            self.height=maxSize.height;
            //_textSize.height = self.height;
            break;
        default:
            //contentsize.height = self.height;
            self.height = self.heightModle;
            break;
    }
    [self autoDim];
    CGSize size = CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
    return size;
}
@end

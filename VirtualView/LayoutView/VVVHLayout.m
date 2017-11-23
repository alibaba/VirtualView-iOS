//
//  VVVHLayout.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVVHLayout.h"

@implementation VVVHLayout
-(id)init{
    self = [super init];
    if (self) {
        self.orientation = HORIZONTAL;
    }
    return self;
}

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

- (void)layoutSubviews{
    [super layoutSubviews];
    switch (self.orientation) {
        case VERTICAL:
            [self vertical];
            break;
        default:
            [self horizontal];
            break;
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    CGSize itemsSize={0,0};
    CGFloat maxWidth=0.0, maxHeight = 0.0;
    
    if (self.heightModle!=MATCH_PARENT && self.heightModle!=WRAP_CONTENT) {
        maxSize.height = self.height;
    }
    
    if (self.widthModle!=MATCH_PARENT && self.widthModle!=WRAP_CONTENT) {
        maxSize.width = self.width;
    }
        
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            maxSize.height = maxSize.height = maxSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case AUTO_DIM_DIR_Y:
            maxSize.width = maxSize.width = maxSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    
     CGFloat blanceWidth = maxSize.width-self.paddingLeft-self.paddingRight, blanceHeight = maxSize.height-self.paddingTop-self.paddingBottom;
    
    int matchWidthType=0,matchHeightType=0;
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    for (VVViewObject* item in self.subViews) {
        if(item.visible==GONE){
            continue;
        }else if(self.widthModle==WRAP_CONTENT && item.widthModle==MATCH_PARENT) {
            [tmpArray addObject:item];
            continue;
        }
        matchWidthType = item.widthModle;
        matchHeightType = item.heightModle;
        CGSize toItemSize={0,0};
        switch (self.orientation) {
            case VERTICAL:
                if (item.widthModle==MATCH_PARENT && self.widthModle==WRAP_CONTENT) {
                    //continue;
                    toItemSize.width = maxSize.width;//maxWidth;
                }else/* if (item.widthModle==WRAP_CONTENT)*/{
                    toItemSize.width = maxSize.width;
                }
                toItemSize.height = blanceHeight;
                break;
            default:
                if (item.heightModle==MATCH_PARENT && self.heightModle==WRAP_CONTENT) {
                    //continue;
                    toItemSize.height = maxSize.height;//maxHeight;
                }else/* if (item.heightModle==WRAP_CONTENT)*/{
                    toItemSize.height = maxSize.height;
                }
                toItemSize.width = blanceWidth;
                break;
        }
        toItemSize.height-=item.marginTop+item.marginBottom;
        toItemSize.width -=item.marginLeft+item.marginRight;
        CGSize size = [item calculateLayoutSize:toItemSize];
        if (self.orientation==VERTICAL) {
            blanceHeight -= size.height+item.marginTop+item.marginBottom;
            itemsSize.height+=size.height+item.marginTop+item.marginBottom;
            self.childrenHeight = itemsSize.height;
            
            if (matchWidthType==WRAP_CONTENT) {
                maxWidth = maxWidth<size.width?size.width:maxWidth;
                self.childrenWidth = maxWidth;
            }else if (matchWidthType==MATCH_PARENT && self.widthModle!=WRAP_CONTENT){
                self.childrenWidth = maxWidth = maxSize.width;
            }else{
                self.childrenWidth = maxWidth =maxWidth<size.width?size.width:maxWidth;
            }
        }else{
            blanceWidth -= size.width+item.marginLeft+item.marginRight;
            itemsSize.width+=size.width+item.marginLeft+item.marginRight;
            self.childrenWidth = itemsSize.width;
            
            if (matchHeightType==WRAP_CONTENT) {
                maxHeight = maxHeight<size.height?size.height:maxHeight;
                self.childrenHeight = maxHeight;
            }else if (matchHeightType==MATCH_PARENT && self.heightModle!=WRAP_CONTENT){
                self.childrenHeight = maxHeight = maxSize.height;
            }else{
                self.childrenHeight = maxHeight = maxHeight<size.height?size.height:maxHeight;
            }
        }
    }
    
    //if (self.autoDimDirection==AUTO_DIM_DIR_X) {
        switch ((int)self.widthModle) {
            case WRAP_CONTENT:
                //
                self.width = self.orientation==VERTICAL?maxWidth:itemsSize.width;
                self.width = self.paddingRight+self.paddingLeft+self.width;
                break;
            case MATCH_PARENT:
                self.width=maxSize.width;
                
                break;
            default:
                self.width = self.paddingRight+self.paddingLeft+self.width;
                break;
        }
    //}
    
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    //if (self.autoDimDirection==AUTO_DIM_DIR_Y) {
        switch ((int)self.heightModle) {
            case WRAP_CONTENT:
                //
                self.height= self.orientation==VERTICAL?itemsSize.height:maxHeight;
                self.height = self.paddingTop+self.paddingBottom+self.height;
                break;
            case MATCH_PARENT:
                self.height=maxSize.height;
                
                break;
            default:
                self.height = self.paddingTop+self.paddingBottom+self.height;
                break;
        }
    //}

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

- (void)vertical{
    float pY = self.frame.origin.y;
    float height = self.height;
    
    if ((self.gravity & Gravity_BOTTOM)==Gravity_BOTTOM) {
        pY += self.height-self.paddingBottom-self.childrenHeight;
    }else if ((self.gravity & Gravity_V_CENTER)==Gravity_V_CENTER){
        pY += (self.height-self.paddingTop-self.paddingBottom-self.childrenHeight)/2.0;
    }else{
        pY += self.paddingTop;
    }
    
    for (VVViewObject* item in self.subViews) {
        //
        if(item.visible==GONE){
            continue;
        }
        CGSize size = CGSizeMake(item.width, item.height);//[item calculateLayoutSize:CGSizeMake(self.width, height)];
        
        
        CGFloat marginY = 0;
        CGFloat marginX = 0;
        int w = item.marginRight==0?0:(self.width - item.marginRight - size.width);
        int h = -item.marginBottom;
        //NSLog(@"V>>>>marginX:%d,marginY:%d",w,h);
        marginY += item.marginTop==0?h:item.marginTop;
        marginX += item.marginLeft==0?w:item.marginLeft;
        
        
        CGFloat blanceW = (self.width-size.width-item.marginLeft-item.marginRight)/2.0;
        //CGFloat blanceH = (self.height- size.height)/2.0;
        CGFloat pX = self.frame.origin.x + self.paddingLeft;
        
        
        pY += item.marginTop;
        
        if((item.layoutGravity&Gravity_H_CENTER)==Gravity_H_CENTER){
            //
            pX += item.marginLeft+blanceW;
        }else if((item.layoutGravity&Gravity_RIGHT)!=0){
            pX = pX+self.width-size.width-item.marginRight;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pX += item.marginLeft;
        }
        
        item.frame = CGRectMake(pX, pY, size.width, size.height);//CGRectOffset(frame, self.frame.origin.x, pY);
        [item layoutSubviews];
        
        pY+=size.height + item.marginBottom;
        height -= size.height + item.marginTop + item.marginBottom;
    }
}

- (void)horizontal{
    float pX = self.frame.origin.x;
    float width = self.width;
    
    if ((self.gravity & Gravity_RIGHT)==Gravity_RIGHT) {
        pX = pX+self.width-self.paddingRight-self.childrenWidth;
    }else if ((self.gravity & Gravity_H_CENTER)==Gravity_H_CENTER){
        pX += (self.width-self.paddingLeft-self.paddingRight-self.childrenWidth)/2.0;
    }else{
        pX += self.paddingLeft;
    }
    
    for (VVViewObject* item in self.subViews) {
        //
        if(item.visible==GONE){
            continue;
        }
        CGSize size = CGSizeMake(item.width, item.height);//[item calculateLayoutSize:CGSizeMake(width, self.height)];
        CGFloat pY = self.frame.origin.y + self.paddingTop;
                CGFloat marginY = 0;
        CGFloat marginX = 0;
        int w = -item.marginRight;
        int h = item.marginBottom==0?0:(self.height - item.marginBottom - size.height);
        //NSLog(@"H>>>>marginX:%d,marginY:%d",w,h);

        marginY += item.marginTop==0?h:item.marginTop;
        marginX += item.marginLeft==0?w:item.marginLeft;
        

        //CGFloat blanceW = (self.width-size.width)/2.0;
        CGFloat blanceH = (self.height-size.height-item.marginTop-item.marginBottom)/2.0;
        
        pX += item.marginLeft;
        
        if((item.layoutGravity&Gravity_V_CENTER)!=0){
            pY += item.marginTop+blanceH;
        }else if ((item.layoutGravity&Gravity_BOTTOM)!=0){
            //
            pY = pY+self.height-size.height-item.marginBottom;
        }else{
            pY += item.marginTop;
        }
        

        item.frame = CGRectMake(pX, pY, size.width, size.height);//CGRectOffset(frame, pX, self.frame.origin.y);
        [item layoutSubviews];
        
        
        pX+= size.width + item.marginRight;
        width -= size.width + item.marginLeft + item.marginRight;
    }
}
@end

//
//  VVVHLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVVHLayout.h"

@implementation VVVHLayout
-(id)init{
    self = [super init];
    if (self) {
        self.orientation = VVOrientationHorizontal;
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
        case VVOrientationVertical:
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
    
    if (self.heightModle!=VV_MATCH_PARENT && self.heightModle!=VV_WRAP_CONTENT) {
        maxSize.height = self.height;
    }
    
    if (self.widthModle!=VV_MATCH_PARENT && self.widthModle!=VV_WRAP_CONTENT) {
        maxSize.width = self.width;
    }
        
    switch (self.autoDimDirection) {
        case VVAutoDimDirectionX:
            maxSize.height = maxSize.height = maxSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case VVAutoDimDirectionY:
            maxSize.width = maxSize.width = maxSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    
     CGFloat blanceWidth = maxSize.width-self.paddingLeft-self.paddingRight, blanceHeight = maxSize.height-self.paddingTop-self.paddingBottom;
    
    int matchWidthType=0,matchHeightType=0;
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    for (VVBaseNode* item in self.subViews) {
        if(item.visible==VVVisibilityGone){
            continue;
        }else if(self.widthModle==VV_WRAP_CONTENT && item.widthModle==VV_MATCH_PARENT) {
            [tmpArray addObject:item];
            continue;
        }
        matchWidthType = item.widthModle;
        matchHeightType = item.heightModle;
        CGSize toItemSize={0,0};
        switch (self.orientation) {
            case VVOrientationVertical:
                if (item.widthModle==VV_MATCH_PARENT && self.widthModle==VV_WRAP_CONTENT) {
                    //continue;
                    toItemSize.width = maxSize.width;//maxWidth;
                }else/* if (item.widthModle==VV_WRAP_CONTENT)*/{
                    toItemSize.width = maxSize.width;
                }
                toItemSize.height = blanceHeight;
                break;
            default:
                if (item.heightModle==VV_MATCH_PARENT && self.heightModle==VV_WRAP_CONTENT) {
                    //continue;
                    toItemSize.height = maxSize.height;//maxHeight;
                }else/* if (item.heightModle==VV_WRAP_CONTENT)*/{
                    toItemSize.height = maxSize.height;
                }
                toItemSize.width = blanceWidth;
                break;
        }
        toItemSize.height-=item.marginTop+item.marginBottom;
        toItemSize.width -=item.marginLeft+item.marginRight;
        CGSize size = [item calculateLayoutSize:toItemSize];
        if (self.orientation==VVOrientationVertical) {
            blanceHeight -= size.height+item.marginTop+item.marginBottom;
            itemsSize.height+=size.height+item.marginTop+item.marginBottom;
            self.childrenHeight = itemsSize.height;
            
            if (matchWidthType==VV_WRAP_CONTENT) {
                maxWidth = maxWidth<size.width?size.width:maxWidth;
                self.childrenWidth = maxWidth;
            }else if (matchWidthType==VV_MATCH_PARENT && self.widthModle!=VV_WRAP_CONTENT){
                self.childrenWidth = maxWidth = maxSize.width;
            }else{
                self.childrenWidth = maxWidth =maxWidth<size.width?size.width:maxWidth;
            }
        }else{
            blanceWidth -= size.width+item.marginLeft+item.marginRight;
            itemsSize.width+=size.width+item.marginLeft+item.marginRight;
            self.childrenWidth = itemsSize.width;
            
            if (matchHeightType==VV_WRAP_CONTENT) {
                maxHeight = maxHeight<size.height?size.height:maxHeight;
                self.childrenHeight = maxHeight;
            }else if (matchHeightType==VV_MATCH_PARENT && self.heightModle!=VV_WRAP_CONTENT){
                self.childrenHeight = maxHeight = maxSize.height;
            }else{
                self.childrenHeight = maxHeight = maxHeight<size.height?size.height:maxHeight;
            }
        }
    }
    
    //if (self.autoDimDirection==VVAutoDimDirectionX) {
        switch ((int)self.widthModle) {
            case VV_WRAP_CONTENT:
                //
                self.width = self.orientation==VVOrientationVertical?maxWidth:itemsSize.width;
                self.width = self.paddingRight+self.paddingLeft+self.width;
                break;
            case VV_MATCH_PARENT:
                self.width=maxSize.width;
                
                break;
            default:
                self.width = self.paddingRight+self.paddingLeft+self.width;
                break;
        }
    //}
    
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    //if (self.autoDimDirection==VVAutoDimDirectionY) {
        switch ((int)self.heightModle) {
            case VV_WRAP_CONTENT:
                //
                self.height= self.orientation==VVOrientationVertical?itemsSize.height:maxHeight;
                self.height = self.paddingTop+self.paddingBottom+self.height;
                break;
            case VV_MATCH_PARENT:
                self.height=maxSize.height;
                
                break;
            default:
                self.height = self.paddingTop+self.paddingBottom+self.height;
                break;
        }
    //}

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

- (void)vertical{
    float pY = self.frame.origin.y;
    float height = self.height;
    
    if ((self.gravity & VVGravityBottom)==VVGravityBottom) {
        pY += self.height-self.paddingBottom-self.childrenHeight;
    }else if ((self.gravity & VVGravityVCenter)==VVGravityVCenter){
        pY += (self.height-self.paddingTop-self.paddingBottom-self.childrenHeight)/2.0;
    }else{
        pY += self.paddingTop;
    }
    
    for (VVBaseNode* item in self.subViews) {
        //
        if(item.visible==VVVisibilityGone){
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
        
        if((item.layoutGravity&VVGravityHCenter)==VVGravityHCenter){
            //
            pX += item.marginLeft+blanceW;
        }else if((item.layoutGravity&VVGravityRight)!=0){
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
    
    if ((self.gravity & VVGravityRight)==VVGravityRight) {
        pX = pX+self.width-self.paddingRight-self.childrenWidth;
    }else if ((self.gravity & VVGravityHCenter)==VVGravityHCenter){
        pX += (self.width-self.paddingLeft-self.paddingRight-self.childrenWidth)/2.0;
    }else{
        pX += self.paddingLeft;
    }
    
    for (VVBaseNode* item in self.subViews) {
        //
        if(item.visible==VVVisibilityGone){
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
        
        if((item.layoutGravity&VVGravityVCenter)!=0){
            pY += item.marginTop+blanceH;
        }else if ((item.layoutGravity&VVGravityBottom)!=0){
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

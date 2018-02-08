//
//  VVVH2Layout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVVH2Layout.h"

@implementation VVVH2Layout
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
    CGSize itemsSize={0,0};
    CGFloat maxWidth=0.0, maxHeight = 0.0;
    
    
    int matchWidthType=0,matchHeightType=0;
    
    if (self.layoutHeight!=VV_MATCH_PARENT && self.layoutHeight!=VV_WRAP_CONTENT) {
        maxSize.height = self.nodeHeight;
    }
    
    if (self.layoutWidth!=VV_MATCH_PARENT && self.layoutWidth!=VV_WRAP_CONTENT) {
        maxSize.width = self.nodeWidth;
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

    //CGFloat blanceWidth = maxSize.width, blanceHeight = maxSize.height;
    CGFloat blanceWidthLeft = maxSize.width-self.paddingLeft-self.paddingRight, blanceHeightTop = maxSize.height-self.paddingTop-self.paddingBottom;
    CGFloat blanceWidthRight = blanceWidthLeft, blanceHeightBottom=blanceHeightTop;

    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    for (VVBaseNode* item in self.subNodes) {
        if (item.visibility==VVVisibilityGone) {
            continue;
        }else if(self.layoutWidth==VV_WRAP_CONTENT && item.layoutWidth==VV_MATCH_PARENT) {
            [tmpArray addObject:item];
            continue;
        }

        matchWidthType = item.layoutWidth;
        matchHeightType = item.layoutHeight;
        CGSize toItemSize={0,0};
        switch (self.orientation) {
            case VVOrientationVertical:
                if (item.layoutWidth==VV_MATCH_PARENT && self.layoutWidth==VV_WRAP_CONTENT) {
                    //continue;
                    toItemSize.width = maxWidth;
                }else/* if (item.widthModle==VV_WRAP_CONTENT)*/{
                    toItemSize.width = maxSize.width-item.marginLeft-item.marginRight;
                }
                toItemSize.height = item.layoutDirection==VVDirectionBottom? blanceHeightBottom:blanceHeightTop;
                break;
            default:
                if (item.layoutHeight==VV_MATCH_PARENT && self.layoutHeight==VV_WRAP_CONTENT) {
                    //continue;
                    toItemSize.height = maxHeight;
                }else/* if (item.heightModle==VV_WRAP_CONTENT)*/{
                    toItemSize.height = maxSize.height-item.marginTop-item.marginBottom;
                }
                toItemSize.width = item.layoutDirection==VVDirectionRight? blanceWidthRight:blanceWidthLeft;
                break;
        }
        
        CGSize size = [item calculateSize:toItemSize];
        if (self.orientation==VVOrientationVertical) {
            if (item.layoutDirection==VVDirectionBottom) {
                blanceHeightBottom -= size.height+item.marginTop+item.marginBottom;
            }else{
                blanceHeightTop -= size.height+item.marginTop+item.marginBottom;
            }

            itemsSize.height+=size.height+item.marginTop+item.marginBottom;
            self.childrenHeight = itemsSize.height;
            
            if (matchWidthType==VV_WRAP_CONTENT) {
                maxWidth = maxWidth<size.width?size.width:maxWidth;
                self.childrenWidth = maxWidth;
            }else if (matchWidthType==VV_MATCH_PARENT && self.layoutWidth!=VV_WRAP_CONTENT){
                self.childrenWidth = maxWidth = maxSize.width;
            }else{
                self.childrenWidth = maxWidth =maxWidth<size.width?size.width:maxWidth;
            }
        }else{
            if (item.layoutDirection==VVDirectionRight) {
                blanceWidthRight -= size.width+item.marginLeft+item.marginRight;
            }else{
                blanceWidthLeft -= size.width+item.marginLeft+item.marginRight;
            }

            itemsSize.width+=size.width+item.marginLeft+item.marginRight;
            self.childrenWidth = itemsSize.width;
            
            if (matchHeightType==VV_WRAP_CONTENT) {
                maxHeight = maxHeight<size.height?size.height:maxHeight;
                self.childrenHeight = maxHeight;
            }else if (matchHeightType==VV_MATCH_PARENT && self.layoutHeight!=VV_WRAP_CONTENT){
                self.childrenHeight = maxHeight = maxSize.height;
            }else{
                self.childrenHeight = maxHeight = maxHeight<size.height?size.height:maxHeight;
            }
        }
        
        
    }
    
    //if (self.autoDimDirection==VVAutoDimDirectionX) {
        switch ((int)self.layoutWidth) {
            case VV_WRAP_CONTENT:
                //
                self.nodeWidth = self.orientation==VVOrientationVertical?maxWidth:itemsSize.width;
                self.nodeWidth = self.paddingRight+self.paddingLeft+self.nodeWidth;
                break;
            case VV_MATCH_PARENT:
                self.nodeWidth=maxSize.width;
                
                break;
            default:
                self.nodeWidth = self.paddingRight+self.paddingLeft+self.nodeWidth;
                break;
        }
    //}
    
    self.nodeWidth = self.nodeWidth<maxSize.width?self.nodeWidth:maxSize.width;
    //if (self.autoDimDirection==VVAutoDimDirectionY) {
        switch ((int)self.layoutHeight) {
            case VV_WRAP_CONTENT:
                //
                self.nodeHeight= self.orientation==VVOrientationVertical?itemsSize.height:maxHeight;
                self.nodeHeight = self.paddingTop+self.paddingBottom+self.nodeHeight;
                break;
            case VV_MATCH_PARENT:
                self.nodeHeight=maxSize.height;
                
                break;
            default:
                self.nodeHeight = self.paddingTop+self.paddingBottom+self.nodeHeight;
                break;
        }
    //}
    self.nodeHeight = self.nodeHeight<maxSize.height?self.nodeHeight:maxSize.height;
    //[self autoDim];
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

    CGSize tmpSize = CGSizeMake(self.nodeWidth, self.nodeHeight);
    for (VVBaseNode* vvObj in tmpArray) {
        [vvObj calculateSize:tmpSize];
    }

    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

- (void)vertical{
    float pY = self.nodeFrame.origin.y;
    float height = self.nodeHeight;

    if ((self.gravity & VVGravityBottom)==VVGravityBottom) {
        pY += self.nodeHeight-self.paddingBottom-self.childrenHeight;
    }else if ((self.gravity & VVGravityVCenter)==VVGravityVCenter){
        pY += (self.nodeHeight-self.paddingTop-self.paddingBottom-self.childrenHeight)/2.0;
    }else{
        pY += self.paddingTop;
    }

    CGFloat topStart = pY;
    CGFloat bottomStart = height - self.paddingBottom;
    for (VVBaseNode* item in self.subNodes) {

        if(item.visibility==VVVisibilityGone){
            continue;
        }

        CGSize size = CGSizeMake(item.nodeWidth, item.nodeHeight);//[item calculateLayoutSize:CGSizeMake(self.width, height)];

        CGFloat marginY = 0;
        CGFloat marginX = 0;
        int w = item.marginRight==0?0:(self.nodeWidth - item.marginRight - size.width);
        int h = -item.marginBottom;
        //NSLog(@"V2>>>>marginX:%d,marginY:%d",w,h);
        marginY += item.marginTop==0?h:item.marginTop;
        marginX += item.marginLeft==0?w:item.marginLeft;
        
        
        CGFloat blanceW = (self.nodeWidth-size.width-item.marginLeft-item.marginRight)/2.0;
        //CGFloat blanceH = (self.height- size.height)/2.0;
        CGFloat pX = self.nodeFrame.origin.x + self.paddingLeft;
        
        if((item.layoutDirection&VVDirectionTop)==VVDirectionTop){
            //
            pY = topStart+item.marginTop;
            topStart = pY + item.nodeHeight + item.marginBottom;
        }else{
            pY = bottomStart - item.marginBottom - item.nodeHeight;
            bottomStart = pY - item.marginTop;
        }
        
        if((item.layoutGravity&VVGravityHCenter)==VVGravityHCenter){
            //
            pX += item.marginLeft+blanceW;
        }else if((item.layoutGravity&VVGravityRight)!=0){
            pX = pX+self.nodeWidth-size.width-item.marginRight;//(blanceW<0?0:blanceW)*2.0;
        }else{
            pX += item.marginLeft;
        }
        
        item.nodeFrame = CGRectMake(pX, pY, size.width, size.height);//CGRectOffset(frame, self.frame.origin.x, pY);
        [item layoutSubNodes];
        
        //pY+=size.height + item.marginBottom;
        //height -= size.height + item.marginTop + item.marginBottom;
    }
}

- (void)horizontal{
    float pX = self.nodeFrame.origin.x;
    float width = self.nodeWidth;
    
    if ((self.gravity & VVGravityRight)==VVGravityRight) {
        pX += self.nodeWidth-self.paddingRight-self.childrenWidth;
    }else if ((self.gravity & VVGravityHCenter)==VVGravityHCenter){
        pX += (self.nodeWidth-self.paddingLeft-self.paddingRight-self.childrenWidth)/2.0;
    }else{
        pX += self.paddingLeft;
    }
    
    CGFloat leftStart = pX;
    CGFloat rightStart = pX + width - self.paddingRight;
    for (VVBaseNode* item in self.subNodes) {
        //
        if(item.visibility==VVVisibilityGone){
            continue;
        }

        CGSize size = CGSizeMake(item.nodeWidth, item.nodeHeight);//[item calculateLayoutSize:CGSizeMake(width, self.height)];
        CGFloat pY = self.nodeFrame.origin.y + self.paddingTop;
        CGFloat marginY = 0;
        CGFloat marginX = 0;
        int w = -item.marginRight;
        int h = item.marginBottom==0?0:(self.nodeHeight - item.marginBottom - size.height);
        //NSLog(@"H2>>>>marginX:%d,marginY:%d",w,h);
        
        marginY += item.marginTop==0?h:item.marginTop;
        marginX += item.marginLeft==0?w:item.marginLeft;
        
        
        //CGFloat blanceW = (self.width-size.width)/2.0;
        CGFloat blanceH = (self.nodeHeight-size.height-item.marginTop-item.marginBottom)/2.0;
        
        if((item.layoutDirection&VVDirectionLeft)==VVDirectionLeft){
            //
            pX = leftStart+item.marginLeft;
            leftStart = pX + item.nodeWidth + item.marginRight;
        }else{
            pX = rightStart - item.marginRight - item.nodeWidth;
            rightStart = pX - item.marginLeft;
        }
        
        if((item.layoutGravity&VVGravityVCenter)!=0){
            pY += item.marginTop+blanceH;
        }else if ((item.layoutGravity&VVGravityBottom)!=0){
            //
            pY = pY+self.nodeHeight-size.height-item.marginBottom;
        }else{
            pY += item.marginTop;
        }
        
        
        item.nodeFrame = CGRectMake(pX, pY, size.width, size.height);//CGRectOffset(frame, pX, self.frame.origin.y);
        [item layoutSubNodes];
        
        
        //pX+= size.width + item.marginRight;
        //width -= size.width + item.marginLeft + item.marginRight;
    }
}
@end

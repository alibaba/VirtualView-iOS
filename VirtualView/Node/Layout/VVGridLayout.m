//
//  VVGridLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVGridLayout.h"
@interface VVGridLayout (){

}
@end;

@implementation VVGridLayout
- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret = [ super setFloatValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_itemHeight:
                _itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                _itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                _itemVerticalMargin = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_colCount:
                _colCount = value;
                break;

            case STR_ID_itemHeight:
                _itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                _itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                _itemVerticalMargin = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (void)layoutSubnodes{
    [super layoutSubnodes];
    int index = 0;
    for (int row=0; row<_rowCount; row++) {
        for (int col=0; col<_colCount; col++) {
            if (index<self.subnodes.count) {
                VVBaseNode* vvObj = [self.subnodes objectAtIndex:index];
                if(vvObj.visibility==VVVisibilityGone){
                    continue;
                }
                CGFloat pX = self.nodeFrame.origin.x+(vvObj.nodeWidth+self.itemHorizontalMargin)*col+self.paddingLeft+vvObj.layoutMarginLeft;
                CGFloat pY = self.nodeFrame.origin.y+(vvObj.nodeHeight+self.itemVerticalMargin)*row+self.paddingTop+vvObj.layoutMarginTop;
                
                vvObj.nodeFrame = CGRectMake(pX, pY, vvObj.nodeWidth, vvObj.nodeHeight);
                [vvObj layoutSubnodes];
                index++;
            }else{
                break;
            }
        }
    }
}

- (CGSize)calculateSize:(CGSize)maxSize{
    
    if (_colCount<1) {
        return CGSizeZero;
    }
    
    CGSize contentSize = maxSize;
    
    if (self.layoutHeight!=VV_MATCH_PARENT && self.layoutHeight!=VV_WRAP_CONTENT) {
        contentSize.height = self.layoutHeight;
    }
    
    if (self.layoutWidth!=VV_MATCH_PARENT && self.layoutWidth!=VV_WRAP_CONTENT) {
        contentSize.width = self.layoutWidth;
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
    
    //CGFloat itemWidth = maxSize.width;
    CGFloat itemMaxHeight = _itemHeight;
    CGFloat itemMaxWidth = 0;
    CGFloat maxWidth=0,maxHeight=0;
    _rowCount = self.subnodes.count/_colCount;
    if (self.subnodes.count%_colCount>0) {
        _rowCount++;
    }
    //contentSize.width -= self.marginLeft+self.marginRight;
    //contentSize.height-= self.marginTop +self.marginBottom;
    if (_colCount>0) {
        itemMaxWidth = (contentSize.width-self.paddingLeft-self.paddingRight-self.itemHorizontalMargin*(_colCount-1))/_colCount;
//        if (self.widthModle==VV_WRAP_CONTENT || self.widthModle==VV_MATCH_PARENT) {
//            itemMaxWidth = (contentSize.width-self.paddingLeft-self.paddingRight)/_colCount;
//        }else{
//            itemMaxWidth = (self.widthModle-self.paddingLeft-self.paddingRight)/_colCount;
//        }
    }else{
        return CGSizeZero;
    }
    
    if (_itemHeight==0 && _rowCount>0) {
        _itemHeight = itemMaxHeight = (contentSize.height-self.paddingTop-self.paddingBottom-self.itemVerticalMargin*(_rowCount-1))/_rowCount;
//        if (self.heightModle==VV_WRAP_CONTENT || self.heightModle==VV_MATCH_PARENT){
//            itemMaxHeight = (maxSize.height-self.paddingTop-self.paddingBottom)/_rowCount;
//        }else{
//            itemMaxHeight = (self.heightModle-self.paddingTop-self.paddingBottom)/_rowCount;
//        }
    }
    
    _itemMaxSize = CGSizeMake(itemMaxWidth, itemMaxHeight);
    
    for (int index =0; index<self.subnodes.count; index+=_colCount) {
        CGFloat tmpWidth=0,tmpHeight=0;
        for (int j=0; j<_colCount; j++) {
            if (index+j==self.subnodes.count) {
                break;
            }
            VVBaseNode* vvObj = [self.subnodes objectAtIndex:index+j];
            CGSize itemSize = [vvObj calculateSize:_itemMaxSize];
            #ifdef VV_DEBUG
                NSLog(@"h:%f,w:%f",itemSize.height,itemSize.width);
            #endif
            tmpWidth+=itemSize.width;
            tmpHeight=itemSize.height;
        }
//        maxWidth = maxWidth<tmpWidth?tmpWidth:maxWidth;
//        maxHeight= maxHeight<tmpHeight?tmpHeight:maxHeight;
        maxWidth = tmpWidth;
        maxHeight += tmpHeight;
    }
    maxWidth += self.itemHorizontalMargin*(_colCount-1);
    maxHeight += self.itemVerticalMargin*(_rowCount-1);
    switch ((int)self.layoutWidth) {
        case VV_WRAP_CONTENT:
            //
            self.nodeWidth = self.paddingRight+self.paddingLeft+maxWidth;
            break;
        case VV_MATCH_PARENT:
            self.nodeWidth = maxSize.width - self.layoutMarginLeft - self.layoutMarginRight;
            
            break;
        default:
            self.nodeWidth = self.layoutWidth;
            break;
    }
    
    switch ((int)self.layoutHeight) {
        case VV_WRAP_CONTENT:
            //
            self.nodeHeight = self.paddingTop+self.paddingBottom+maxHeight;
            break;
        case VV_MATCH_PARENT:
            self.nodeHeight = maxSize.height - self.layoutMarginTop - self.layoutMarginBottom;
            
            break;
        default:
            self.nodeHeight = self.layoutHeight;
            break;
    }
    //[self autoDim];
    //return CGSizeMake(self.width, self.height);
    return CGSizeMake(self.nodeWidth=self.nodeWidth<maxSize.width?self.nodeWidth:maxSize.width, self.nodeHeight=self.nodeHeight<maxSize.height?self.nodeHeight:maxSize.height);
}
@end

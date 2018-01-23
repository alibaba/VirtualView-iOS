//
//  VVPageView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPageView.h"
#import "VVViewContainer.h"
#import "NVCarouselPageView.h"

@interface VVPageView ()<UIScrollViewDelegate>
@property(strong, nonatomic)CALayer*   drawLayer;
@property(strong, nonatomic)NVCarouselPageView * scrollView;

@property(strong, nonatomic) NSArray *data;
@end


@implementation VVPageView

- (id)init{
    self = [super init];
    if (self) {
        self.scrollView = [[NVCarouselPageView alloc] init];
        self.cocoaView = _scrollView;
    }
    return self;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
                case STR_ID_stayTime:
                break;
                case STR_ID_autoSwitchTime:
                break;
                case STR_ID_animatorTime:
                break;
                default:
                break;
        }
    }
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret = [super setStringValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
                case STR_ID_autoSwitch:
                break;
                case STR_ID_canSlide:
                break;
                default:
                break;
        }
    }
    return ret;
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    VVViewContainer* vvContainer = nil;
    if([[self superview].updateDelegate isKindOfClass:VVViewContainer.class]){
        vvContainer = (VVViewContainer*)[self superview].updateDelegate;
    }
    [self resetObj];
    NSArray* dataArray = (NSArray*)obj;
    self.data = dataArray;
    self.updateDelegate = (id<VVWidgetAction>)vvContainer;
    [self attachCocoaViews:self];
    if (self.scrollView.superview==nil) {
        [vvContainer addSubview:self.scrollView];
    }
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    for (VVBaseNode* subObj in self.subViews) {
        subObj.updateDelegate = (id<VVWidgetAction>)self.scrollView;
    }
}

- (void)attachCocoaViews:(VVBaseNode*)vvObj{

}

- (void)removeCocoaView:(VVBaseNode*)vvObj{
    
}

- (void)resetObj{
    
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
    
    for (VVBaseNode* item in self.subViews) {
        if(item.visible==VVVisibilityGone){
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
            //blanceHeight -= size.height;
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
            //blanceWidth -= size.width;
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
    
    return CGSizeMake(self.width, self.height);
}

- (void)layoutSubviews{
    NVCarouselPageView *pageView = (NVCarouselPageView*)self.cocoaView;
    pageView.frame = CGRectMake(0, 0, self.width, self.width);
    pageView.data = self.data;
    pageView.pageView = self;
    [pageView calculateLayout];
}


@end

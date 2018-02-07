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
@property (nonatomic, strong, readwrite) UIView *cocoaView;
@property(strong, nonatomic)CALayer*   drawLayer;
@property(strong, nonatomic)NVCarouselPageView * scrollView;

@property(strong, nonatomic) NSArray *data;
@end


@implementation VVPageView
@synthesize cocoaView;

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
    if([[self supernode].rootCocoaView isKindOfClass:[VVViewContainer class]]){
        vvContainer = (VVViewContainer*)[self supernode].rootCocoaView;
    }
    [self resetObj];
    NSArray* dataArray = (NSArray*)obj;
    self.data = dataArray;
    self.rootCocoaView = self.scrollView;
    self.rootCanvasLayer = self.scrollView.layer;
    [self attachCocoaViews:self];
    if (self.scrollView.superview == nil) {
        [vvContainer addSubview:self.scrollView];
    }
}

- (void)attachCocoaViews:(VVBaseNode*)vvObj{

}

- (void)removeCocoaView:(VVBaseNode*)vvObj{
    
}

- (void)resetObj{
    
}

- (CGSize)calculateSize:(CGSize)maxSize{
    CGSize itemsSize={0,0};
    CGFloat maxWidth=0.0, maxHeight = 0.0;
    
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
    
    CGFloat blanceWidth = maxSize.width-self.paddingLeft-self.paddingRight, blanceHeight = maxSize.height-self.paddingTop-self.paddingBottom;
    
    int matchWidthType=0,matchHeightType=0;
    
    for (VVBaseNode* item in self.subnodes) {
        if(item.visibility==VVVisibilityGone){
            continue;
        }
        matchWidthType = item.layoutWidth;
        matchHeightType = item.layoutHeight;
        CGSize toItemSize={0,0};
        switch (self.orientation) {
            case VVOrientationVertical:
                if (item.layoutWidth==VV_MATCH_PARENT && self.layoutWidth==VV_WRAP_CONTENT) {
                    //continue;
                    toItemSize.width = maxSize.width;//maxWidth;
                }else/* if (item.widthModle==VV_WRAP_CONTENT)*/{
                    toItemSize.width = maxSize.width;
                }
                toItemSize.height = blanceHeight;
                break;
            default:
                if (item.layoutHeight==VV_MATCH_PARENT && self.layoutHeight==VV_WRAP_CONTENT) {
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
        CGSize size = [item calculateSize:toItemSize];
        if (self.orientation==VVOrientationVertical) {
            //blanceHeight -= size.height;
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
            //blanceWidth -= size.width;
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

- (void)layoutSubnodes{
    NVCarouselPageView *pageView = (NVCarouselPageView*)self.cocoaView;
    pageView.frame = CGRectMake(0, 0, self.nodeWidth, self.nodeWidth);
    pageView.data = self.data;
    pageView.pageView = self;
    [pageView calculateLayout];
    [super layoutSubnodes];
}


@end

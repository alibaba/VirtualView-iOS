//
//  VVGridView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVGridView.h"
#import "VVGridLayout.h"
#import "VVViewContainer.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"

@interface VVGridView (){

}
@property(strong, nonatomic)VVGridLayout*   gridlayout;
@property(strong, nonatomic)UIView*         gridContainer;
@property(weak, nonatomic)NSObject*       updateDataObj;
@end

@implementation VVGridView

- (id)init{
    self = [super init];
    if (self) {
        self.gridContainer = [[UIView alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (self.canvasLayer) {
        self.canvasLayer.delegate = nil;
    }
}

- (void)layoutSubNodes{
    
    
    CGFloat x = self.nodeFrame.origin.x;
    CGFloat y = self.nodeFrame.origin.y;
    self.nodeWidth = self.nodeWidth<0?self.superNode.nodeFrame.size.width:self.nodeWidth;
    self.nodeHeight = self.nodeHeight<0?self.superNode.nodeFrame.size.height:self.nodeHeight;
    self.nodeX = x;
    self.nodeY = y;
    [self updateFrame];
    
    self.gridContainer.frame = self.nodeFrame;
    int index = 0;
    for (int row=0; row<self.rowCount; row++) {
        for (int col=0; col<self.colCount; col++) {
            if (index<self.subNodes.count) {
                VVBaseNode* vvObj = [self.subNodes objectAtIndex:index];
                if(vvObj.visibility==VVVisibilityGone){
                    continue;
                }
                CGFloat pX = (vvObj.nodeWidth+self.itemHorizontalMargin)*col+self.paddingLeft+vvObj.marginLeft;
                CGFloat pY = (vvObj.nodeHeight+self.itemVerticalMargin)*row+self.paddingTop+vvObj.marginTop;
                
                self.nodeX = pX;
                self.nodeY = pY;
                [vvObj updateFrame];
                [vvObj layoutSubNodes];
                index++;
            }else{
                break;
            }
        }
    }
    [super layoutSubNodes];
}

- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret = [ super setFloatValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_itemHeight:
                self.itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                self.itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                self.itemVerticalMargin = value;
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
                self.colCount = value;
                break;
                
            case STR_ID_itemHeight:
                self.itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                self.itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                self.itemVerticalMargin = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (BOOL)setDataObj:(NSObject*)obj forKey:(int)key
{
    if (obj==nil || obj==self.updateDataObj) {
        return NO;
    }else{
        self.updateDataObj = obj;
    }
    VVViewContainer* vvContainer = nil;
    if([self.superNode.rootCocoaView isKindOfClass:[VVViewContainer class]]){
        vvContainer = (VVViewContainer*)self.superNode.rootCocoaView;
    }
    [self resetObj];
    NSArray* dataArray = (NSArray*)obj;
    for (NSDictionary* jsonData in dataArray) {
        NSString* nodeType=[jsonData objectForKey:@"type"];
        NSMutableArray* updateObjs = [[NSMutableArray alloc] init];
        VVBaseNode* vv = [[VVTemplateManager sharedManager] createNodeTreeForType:nodeType];
        [VVViewContainer getDataTagObjsHelper:vv collection:updateObjs];
        for (VVBaseNode* item in updateObjs) {
            [item reset];
            for (VVPropertyExpressionSetter *setter in item.expressionSetters.allValues) {
                if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                    [setter applyToNode:item withDict:jsonData];
                }
            }
        }
        vv.actionValue = [jsonData objectForKey:vv.action];
        [self addSubNode:vv];

    }
    self.rootCocoaView = self.gridContainer;
    self.rootCanvasLayer = self.gridContainer.layer;
    [self attachCocoaViews:self];
    if (self.gridContainer.superview == nil) {
        [vvContainer addSubview:self.gridContainer];
    }
    return YES;
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    if (self.canvasLayer == nil) {
        self.canvasLayer = [VVLayer layer];
        self.canvasLayer.drawsAsynchronously = YES;
        self.canvasLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.canvasLayer.delegate =  (id<CALayerDelegate>)self;
    }
    if (self.canvasLayer) {
        if (self.canvasLayer.superlayer) {
            [self.canvasLayer removeFromSuperlayer];
        }
        [rootCanvasLayer addSublayer:self.canvasLayer];
    }
    [super setRootCanvasLayer:rootCanvasLayer];
}

- (void)attachCocoaViews:(VVBaseNode*)vvObj{
    for (VVBaseNode* subView in vvObj.subNodes) {
        [self attachCocoaViews:subView];
        if (subView.cocoaView && subView.visibility!=VVVisibilityGone) {
            [self.gridContainer addSubview:subView.cocoaView];
        }
    }
}

- (void)removeCocoaView:(VVBaseNode*)vvObj{

    NSArray* subViews = [NSArray arrayWithArray:vvObj.subNodes];
    for (VVBaseNode* item in subViews) {
        [self removeCocoaView:item];
    }

    if (vvObj.cocoaView) {
        [vvObj.cocoaView removeFromSuperview];
    }
}

- (void)resetObj{
    NSArray* subViews = [NSArray arrayWithArray:self.subNodes];
    for (VVBaseNode* subView in subViews) {
        [self removeCocoaView:subView];
        [subView removeFromSuperNode];
    }

}
@end

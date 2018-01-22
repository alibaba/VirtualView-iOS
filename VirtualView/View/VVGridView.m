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
    if (self.drawLayer) {
        self.drawLayer.delegate = nil;
    }
}

- (void)layoutSubviews{
    
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    self.width = self.width<0?self.superview.frame.size.width:self.width;
    self.height = self.height<0?self.superview.frame.size.height:self.height;
    CGFloat a1,a2,w,h;
    a1 = (int)x*1;
    a2 = (int)y*1;
    w = (int)self.width*1;
    h = (int)self.height*1;
    self.frame = CGRectMake(a1, a2, w, h);
    
    self.gridContainer.frame = self.frame;
    int index = 0;
    for (int row=0; row<self.rowCount; row++) {
        for (int col=0; col<self.colCount; col++) {
            if (index<self.subViews.count) {
                VVBaseNode* vvObj = [self.subViews objectAtIndex:index];
                if(vvObj.visible==VVVisibilityGone){
                    continue;
                }
                CGFloat pX = (vvObj.width+self.itemHorizontalMargin)*col+self.paddingLeft+vvObj.marginLeft;
                CGFloat pY = (vvObj.height+self.itemVerticalMargin)*row+self.paddingTop+vvObj.marginTop;
                
                vvObj.frame = CGRectMake(pX, pY, vvObj.width, vvObj.height);
                [vvObj layoutSubviews];
                index++;
            }else{
                break;
            }
        }
    }

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

- (int)getValue4Array:(NSArray*)arr{
    int value=0;
    for (NSString* item in arr) {
        if ([item compare:@"left" options:NSCaseInsensitiveSearch]) {
            value=value|VVGravityLeft;
        }else if ([item compare:@"right" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityRight;
        }else if ([item compare:@"h_center" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityHCenter;
        }else if ([item compare:@"top" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityTop;
        }else if ([item compare:@"bottom" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityBottom;
        }else if ([item compare:@"v_center" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityVCenter;
        }else if ([item compare:@"center" options:NSCaseInsensitiveSearch]){
            value=value|VVGravityHCenter|VVGravityVCenter;
        }
    }
    return value;
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    VVViewContainer* vvContainer = nil;
    if([[self superview].updateDelegate isKindOfClass:VVViewContainer.class]){
        vvContainer = (VVViewContainer*)[self superview].updateDelegate;
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
            for (VVPropertyExpressionSetter *setter in item.expressionSetters) {
                if ([setter isKindOfClass:[VVPropertyExpressionSetter class]] == NO) {
                    continue;
                }
                id objectValue = [setter.expression resultWithObject:jsonData];
                NSString *stringValue = [objectValue description];
                switch (setter.valueType) {
                    case TYPE_INT:
                    {
                        [item setIntValue:[stringValue intValue] forKey:setter.key];
                    }
                        break;
                    case TYPE_FLOAT:
                    {
                        [item setFloatValue:[stringValue floatValue] forKey:setter.key];
                    }
                        break;
                    case TYPE_STRING:
                    case TYPE_COLOR:
                    {
                        [item setStringDataValue:stringValue forKey:setter.key];
                    }
                        break;
                    case TYPE_BOOLEAN:
                    {
                        if ([stringValue isEqualToString:@"true"]) {
                            [item setIntValue:1 forKey:setter.key];
                        }else{
                            [item setIntValue:0 forKey:setter.key];
                        }
                    }
                        
                        break;
                    case TYPE_VISIBILITY:
                    {
                        if ([stringValue isEqualToString:@"invisible"]) {
                            [item setIntValue:VVVisibilityInvisible forKey:setter.key];
                        }else if([stringValue isEqualToString:@"visible"]) {
                            [item setIntValue:VVVisibilityVisible forKey:setter.key];
                        }else{
                            [item setIntValue:VVVisibilityGone forKey:setter.key];
                        }
                    }
                        break;
                    case TYPE_GRAVITY:
                    {
                        [item setIntValue:[self getValue4Array:[stringValue componentsSeparatedByString:@"|"]] forKey:setter.key];
                    }
                        break;
                    case TYPE_OBJECT:
                    {
                        [item setDataObj:objectValue forKey:setter.key];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        vv.actionValue = [jsonData objectForKey:vv.action];
        [self addSubview:vv];

    }
    self.updateDelegate = (id<VVWidgetAction>)vvContainer;
    [self attachCocoaViews:self];
    if (self.gridContainer.superview==nil) {
        [vvContainer addSubview:self.gridContainer];
    }
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    if (self.drawLayer==nil) {
        self.drawLayer = [VVLayer layer];
        self.drawLayer.drawsAsynchronously = YES;
        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.drawLayer.delegate =  (id<CALayerDelegate>)self;
        [self.gridContainer.layer addSublayer:self.drawLayer];
    }
    for (VVBaseNode* subObj in self.subViews) {
        subObj.updateDelegate = (id<VVWidgetAction>)self.gridContainer;
    }
}

- (void)attachCocoaViews:(VVBaseNode*)vvObj{
    for (VVBaseNode* subView in vvObj.subViews) {
        [self attachCocoaViews:subView];
        if (subView.cocoaView && subView.visible!=VVVisibilityGone) {
            [self.gridContainer addSubview:subView.cocoaView];
        }
    }
}

- (void)removeCocoaView:(VVBaseNode*)vvObj{

    NSArray* subViews = [NSArray arrayWithArray:vvObj.subViews];
    for (VVBaseNode* item in subViews) {
        [self removeCocoaView:item];
    }

    if (vvObj.cocoaView) {
        [vvObj.cocoaView removeFromSuperview];
    }
}

- (void)resetObj{
    NSArray* subViews = [NSArray arrayWithArray:self.subViews];
    for (VVBaseNode* subView in subViews) {
        [self removeCocoaView:subView];
        [subView removeFromSuperview];
    }

}
@end

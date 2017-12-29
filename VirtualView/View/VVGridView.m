//
//  VVGridView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVGridView.h"
#import "VVViewFactory.h"
#import "VVBinaryLoader.h"
#import "VVViewFactory.h"
#import "VVGridLayout.h"
#import "VVViewContainer.h"
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
        //_colCount = 2;
        //self.gridlayout = [[VVGridLayout alloc] init];
        self.gridContainer = [[UIView alloc] init];
        //self.gridContainer.backgroundColor = [UIColor grayColor];
    }
    return self;
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
    //[super layoutSubviews];
    int index = 0;
    for (int row=0; row<self.rowCount; row++) {
        for (int col=0; col<self.colCount; col++) {
            if (index<self.subViews.count) {
                VVViewObject* vvObj = [self.subViews objectAtIndex:index];
                if(vvObj.visible==GONE){
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

- (void)setDataTag:(NSString *)dataTag{
    //
    NSArray* subItems  = (NSArray*)dataTag;
    for (NSDictionary* item in subItems) {
        //
        //NSUInteger itemId = [[item objectForKey:@"type"] intValue];
        VVViewObject* vvObj = [[VVViewFactory shareFactoryInstance] parseWidgetWithTypeID:@"" collection:nil];
        [vvObj setDataObj:item forKey:0];
        [self addSubview:vvObj];
    }
}

- (int)getValue4Array:(NSArray*)arr{
    int value=0;
    for (NSString* item in arr) {
        if ([item compare:@"left" options:NSCaseInsensitiveSearch]) {
            value=value|Gravity_LEFT;
        }else if ([item compare:@"right" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_RIGHT;
        }else if ([item compare:@"h_center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_H_CENTER;
        }else if ([item compare:@"top" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_TOP;
        }else if ([item compare:@"bottom" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_BOTTOM;
        }else if ([item compare:@"v_center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_V_CENTER;
        }else if ([item compare:@"center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_H_CENTER|Gravity_V_CENTER;
        }
    }
    return value;
}

- (NSString*)valueForVariable:(id)obj fromJsonData:(NSDictionary*)jsonData{
    
    NSString* valueObj = nil;
    
    if ([obj isKindOfClass:NSArray.class]) {
        NSDictionary* tmpDictionary = jsonData;
        //NSString* varName = nil;
        NSArray* varList = (NSArray*)obj;
        for (NSDictionary* varItem in varList) {
            NSString* varName = [varItem objectForKey:@"varName"];
            int index = [[varItem objectForKey:@"varIndex"] intValue];

            if (index>=0) {
                NSArray* items = [tmpDictionary objectForKey:varName];
                if (items.count>index) {
                    valueObj = [items objectAtIndex:index];
                }else{
                    valueObj = @"";
                }
            }else{
                valueObj = [tmpDictionary objectForKey:varName];
            }

            if ([valueObj isKindOfClass:NSDictionary.class]) {
                tmpDictionary = (NSDictionary*)valueObj;
            }

        }
    }else{
        NSString* varString = (NSString*)obj;
        NSRange startPos = [varString rangeOfString:@"${"];
        if (startPos.location==NSNotFound) {
            return varString;
        }

        NSRange endPos   = [varString rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(startPos.location, varString.length-startPos.location)];

        if (endPos.location==NSNotFound) {
            return varString;
        }

        if (startPos.location!=NSNotFound && endPos.location!=NSNotFound && endPos.location>startPos.location) {
            NSString* key = [varString substringWithRange:NSMakeRange(startPos.location+2, endPos.location-startPos.length)];
            valueObj = [jsonData objectForKey:key];
        }
    }

    return valueObj;
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    //
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    NSMutableArray* dataTagObjs = nil;
    VVViewContainer* vvContainer = nil;
    if([[self superview].updateDelegate isKindOfClass:VVViewContainer.class]){
        vvContainer = (VVViewContainer*)[self superview].updateDelegate;
        dataTagObjs = vvContainer.dataTagObjs;
    }
    [self resetObj];
    NSArray* dataArray = (NSArray*)obj;
    for (NSDictionary* jsonData in dataArray) {
        //
        NSString* widget=[jsonData objectForKey:@"type"];
        NSMutableArray* updateObjs = [[NSMutableArray alloc] init];
        VVViewObject* vv = [[VVViewFactory shareFactoryInstance] parseWidgetWithTypeID:widget collection:updateObjs];
        //[vv calculateLayoutSize:size];
        for (VVViewObject* item in updateObjs) {
            [item reset];
            for (NSNumber* key in [item.mutablePropertyDic allKeys]) {
                NSDictionary* propertyInfo = [item.mutablePropertyDic objectForKey:key];
                //NSString* varName = [propertyInfo objectForKey:@"varName"];
                NSNumber* valueType = [propertyInfo objectForKey:@"valueType"];
                NSArray* varObj = [propertyInfo objectForKey:@"varValues"];
                
                //NSArray* nodes = [varName componentsSeparatedByString:@"."];
                NSObject* valueObj = nil;
                NSDictionary* tmpDictionary = jsonData;
                NSString* varName = nil;
                if([varObj isKindOfClass:NSArray.class]){
                    for (NSDictionary* varItem in varObj) {
                        NSString* var = [varItem objectForKey:@"varName"];
                        int index = [[varItem objectForKey:@"varIndex"] intValue];
                        if (index>=0) {
                            NSArray* items = [tmpDictionary objectForKey:var];
                            if (items.count>index) {
                                valueObj = [items objectAtIndex:index];
                            }else{
                                valueObj = @"";
                            }
                        }else{
                            valueObj = [tmpDictionary objectForKey:var];
                        }

                        if ([valueObj isKindOfClass:NSDictionary.class]) {
                            tmpDictionary = (NSDictionary*)valueObj;
                        }

                        varName = var;
                    }
                }else if ([varObj isKindOfClass:NSString.class]){
                    valueObj = [tmpDictionary objectForKey:varObj];
                    varName = (NSString*)varObj;
                }
                /*for (NSString* node in nodes) {
                    //NSLog(@"%@",node);
                    NSRange start = [node rangeOfString:@"["];
                    NSRange end   = [node rangeOfString:@"]"];
                    if (start.location!=NSNotFound && end.location!=NSNotFound && start.location<end.location) {
                        NSRange indexRange = NSMakeRange(start.location+1, end.location-start.location-1);
                        NSString* indexString = [node substringWithRange:indexRange];
                        NSUInteger index = [indexString integerValue];
                        NSString* nodeName = [node substringToIndex:start.location];
                        NSArray* items = [tmpDictionary objectForKey:nodeName];
                        if (items.count>index) {
                            valueObj = [items objectAtIndex:index];
                        }else{
                            valueObj = @"";
                        }
                    }else{
                        valueObj = [tmpDictionary objectForKey:node];
                    }
                    
                    if ([valueObj isKindOfClass:NSDictionary.class]) {
                        tmpDictionary = (NSDictionary*)valueObj;
                    }
                }*/

                int keyValue = [key intValue];

                switch ([valueType intValue]) {
                    case TYPE_INT:
                    {
                        int value=0;
                        if ([propertyInfo allValues].count>2) {
                            NSObject* objValue;
                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                objValue = [propertyInfo objectForKey:@"v1"];
                            }else{
                                objValue = [propertyInfo objectForKey:@"v2"];
                            }
                            value = [[self valueForVariable:objValue fromJsonData:jsonData] intValue];
                        }else{
                            value = [(NSNumber*)valueObj intValue];
                        }
                        [item setIntValue:value forKey:keyValue];
                        
                    }
                        break;
                    case TYPE_FLOAT:
                    {
                        CGFloat value=0;
                        if ([propertyInfo allValues].count>2) {
                            NSObject* objValue;
                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                objValue = [propertyInfo objectForKey:@"v1"];
                            }else{
                                objValue = [propertyInfo objectForKey:@"v2"];
                            }
                            value = [[self valueForVariable:objValue fromJsonData:jsonData] floatValue];
                        }else{
                            value = [(NSNumber*)valueObj floatValue];
                            [item setFloatValue:value forKey:keyValue];
                        }
                        
                        [item setFloatValue:value forKey:keyValue];
                    }
                        break;
                    case TYPE_STRING:
                    {
                        NSString* value=@"";
                        if ([propertyInfo allValues].count>2) {
                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                value = [propertyInfo objectForKey:@"v1"];
                            }else{
                                value = [propertyInfo objectForKey:@"v2"];
                            }
                        }else{
                            value = (NSString*)valueObj;
                        }
                        value = [self valueForVariable:value fromJsonData:jsonData];
                        [item setStringDataValue:value forKey:keyValue];
                    }
                        break;
                    case TYPE_COLOR:
                    {
                        {
                            NSString* value=@"";
                            if ([propertyInfo allValues].count>2) {
                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                    value = [propertyInfo objectForKey:@"v1"];
                                }else{
                                    value = [propertyInfo objectForKey:@"v2"];
                                }
                            }else{
                                value = (NSString*)valueObj;
                            }
                            value = [self valueForVariable:value fromJsonData:jsonData];
                            [item setStringDataValue:value forKey:keyValue];
                        }
                        break;
                    case TYPE_BOOLEAN:
                        {
                            NSString* value=@"";
                            if ([propertyInfo allValues].count>2) {
                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                    value = [propertyInfo objectForKey:@"v1"];
                                }else{
                                    value = [propertyInfo objectForKey:@"v2"];
                                }
                            }else{
                                value = (NSString*)valueObj;
                            }

                            value = [self valueForVariable:value fromJsonData:jsonData];
                            if ([value isEqualToString:@"true"]) {
                                [item setIntValue:1 forKey:[key intValue]];
                            }else{
                                [item setIntValue:0 forKey:[key intValue]];
                            }
                        }

                        break;
                    case TYPE_VISIBILITY:
                        {
                            NSString* value=@"";
                            if ([propertyInfo allValues].count>2) {
                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                    value = [propertyInfo objectForKey:@"v1"];
                                }else{
                                    value = [propertyInfo objectForKey:@"v2"];
                                }
                            }else{
                                value = (NSString*)valueObj;
                            }

                            value = [self valueForVariable:value fromJsonData:jsonData];
                            if ([value isEqualToString:@"invisible"]) {
                                [item setIntValue:INVISIBLE forKey:[key intValue]];
                            }else if([value isEqualToString:@"visible"]) {
                                [item setIntValue:VISIBLE forKey:[key intValue]];
                            }else{
                                [item setIntValue:GONE forKey:[key intValue]];
                            }
                        }
                        
                        break;
                    case TYPE_GRAVITY:
                        {
                            NSString* value=@"";
                            if ([propertyInfo allValues].count>2) {
                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                                    value = [propertyInfo objectForKey:@"v1"];
                                }else{
                                    value = [propertyInfo objectForKey:@"v2"];
                                }
                            }else{
                                value = (NSString*)valueObj;
                            }
                            value = [self valueForVariable:value fromJsonData:jsonData];
                            [item setIntValue:[self getValue4Array:[value componentsSeparatedByString:@"|"]] forKey:keyValue];
                        }

                        break;
                    case TYPE_OBJECT:
                        [item setDataObj:[jsonData objectForKey:varName] forKey:keyValue];
                        break;
                    default:
                        break;
                    }
                }
                //[item setDataObj:(NSDictionary*)obj];
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
    for (VVViewObject* subObj in self.subViews) {
        subObj.updateDelegate = (id<VVWidgetAction>)self.gridContainer;
    }
}

- (void)attachCocoaViews:(VVViewObject*)vvObj{
    for (VVViewObject* subView in vvObj.subViews) {
        [self attachCocoaViews:subView];
        if (subView.cocoaView && subView.visible!=GONE) {
            [self.gridContainer addSubview:subView.cocoaView];
        }
    }
}

- (void)removeCocoaView:(VVViewObject*)vvObj{

    NSArray* subViews = [NSArray arrayWithArray:vvObj.subViews];
    for (VVViewObject* item in subViews) {
        [self removeCocoaView:item];
    }

    if (vvObj.cocoaView) {
        [vvObj.cocoaView removeFromSuperview];
    }
    //[vvObj removeFromSuperview];
}

- (void)resetObj{
    NSArray* subViews = [NSArray arrayWithArray:self.subViews];
    for (VVViewObject* subView in subViews) {
        [self removeCocoaView:subView];
        [subView removeFromSuperview];
    }

}
@end

//
//  VVViewContainer.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewContainer.h"
#import "VVLayout.h"
#import "VVBinaryLoader.h"
@interface VVViewContainer()<VVWidgetAction>{
    UILongPressGestureRecognizer* _pressRecognizer;
}
@property(strong, nonatomic)NSMutableDictionary* dataCacheDic;
@property(weak, nonatomic)NSObject*            updateDataObj;
@end

@implementation VVViewContainer


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    [self.virtualView drawRect:rect];
//}

- (void)updateDisplayRect:(CGRect)rect{
    //[self setNeedsDisplayInRect:rect];
}
/*
- (void)layerWillDraw:(CALayer *)layer{
    NSLog(@"____________________________________________________________________________");
    [self.virtualView calculateLayoutSize:self.frame.size];
    [self.virtualView layoutSubviews];
}*/

/*
- (void)layoutSubviews{
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.virtualView.frame.size.width, self.virtualView.frame.size.height);
    [self.virtualView calculateLayoutSize:self.frame.size];
    self.virtualView.width = self.frame.size.width;
    self.virtualView.height = self.frame.size.height;

    [self.virtualView layoutSubviews];
   }
*/

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint pt =[gestureRecognizer locationInView:self];
    #ifdef VV_DEBUG
        NSLog(@"x:%f y:%f",pt.x,pt.y);
    #endif
    id<VVWidgetObject> vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [(VVViewObject*)vvobj isLongClickable]) {
        #ifdef VV_DEBUG
            NSLog(@"%@:%@",vvobj.action,vvobj.actionValue);
        #endif
        [self.delegate subViewLongPressed:vvobj.action andValue:vvobj.actionValue gesture:gestureRecognizer];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //
    UITouch *touch =  [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    id<VVWidgetObject> vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [(VVViewObject*)vvobj isClickable]) {
        #ifdef VV_DEBUG
            NSLog(@"%@:%@",vvobj.action,vvobj.actionValue);
        #endif
        if([self.delegate respondsToSelector:@selector(subView:clicked:andValue:)])
        {
            [self.delegate subView:vvobj clicked:vvobj.action andValue:vvobj.actionValue];
        }
        else if([self.delegate respondsToSelector:@selector(subViewClicked:andValue:)])
        {
            [self.delegate subViewClicked:vvobj.action andValue:vvobj.actionValue];
        }
    }else{
        [super touchesEnded:touches withEvent:event];
    }
}

- (id)initWithVirtualView:(VVViewObject*)virtualView{
    self = [super init];
    if (self) {
        self.virtualView = virtualView;
        self.virtualView.updateDelegate = self;
        //virtualView.superview = self;
        self.backgroundColor = [UIColor clearColor];
        self.dataCacheDic = [[NSMutableDictionary alloc] init];//((VVBinaryLoader*)[VVBinaryLoader shareInstance]).dataCacheDic;

        if ([self.virtualView isLongClickable]) {
            _pressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
            //代理
            //longPress.delegate = self;
            //将长按手势添加到需要实现长按操作的视图里
            [self addGestureRecognizer:_pressRecognizer];
        }
    }
    return self;
}

- (void) attachViews {
    [self attachViews:self.virtualView];
}

- (void) attachViews:(VVViewObject*)virtualView {
    
    if ([virtualView isKindOfClass:VVLayout.class]) {
        for (VVLayout* item in virtualView.subViews) {
            [self attachViews:item];
        }
    } else if(virtualView.cocoaView && virtualView.visible!=GONE) {
        [self addSubview:virtualView.cocoaView];
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
- (void)update:(NSObject*)obj{
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    NSDictionary* jsonData = (NSDictionary*)obj;

    NSMutableArray* widgetValues = [[NSMutableArray alloc] init];
    for (VVViewObject* item in self.dataTagObjs) {
        [item reset];

        for (NSNumber* key in [item.mutablePropertyDic allKeys]) {

            NSMutableDictionary* dataCache = [[NSMutableDictionary alloc] init];
            [widgetValues addObject:dataCache];
            [dataCache setObject:item forKey:@"object"];

            NSDictionary* propertyInfo = [item.mutablePropertyDic objectForKey:key];
            [dataCache setObject:key forKey:@"key"];

            //NSString* varName = [propertyInfo objectForKey:@"varName"];
            NSNumber* valueType = [propertyInfo objectForKey:@"valueType"];
            [dataCache setObject:valueType forKey:@"type"];

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
                            valueObj = nil;
                            break;
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

            int keyValue = [key intValue];
            int intValue = 0;
            NSObject* objValue = nil;
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
                    [dataCache setObject:[NSNumber numberWithInt:value] forKey:@"value"];

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
                    }
                    [item setFloatValue:value forKey:keyValue];
                    [dataCache setObject:[NSNumber numberWithFloat:value] forKey:@"value"];

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
                        value = [self valueForVariable:value fromJsonData:jsonData];
                    }else{
                        value = (NSString*)valueObj;
                    }
                    if (value) {
                        [item setStringDataValue:value forKey:keyValue];
                        [dataCache setObject:value forKey:@"value"];
                    }
                }
                    break;
                case TYPE_COLOR:
                {
                    NSString* value=@"";
                    if ([propertyInfo allValues].count>2) {
                        if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
                            value = [propertyInfo objectForKey:@"v1"];
                        }else{
                            value = [propertyInfo objectForKey:@"v2"];
                        }
                        value = [self valueForVariable:value fromJsonData:jsonData];
                    }else{
                        value = (NSString*)valueObj;
                    }
                    if (value) {
                        [item setStringDataValue:value forKey:keyValue];
                        [dataCache setObject:value forKey:@"value"];
                    }
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
                        intValue = 1;
                    }else{
                        intValue = 0;
                    }
                    [item setIntValue:intValue forKey:keyValue];
                    [dataCache setObject:[NSNumber numberWithInt:intValue] forKey:@"value"];
                }
                    break;
                case TYPE_VISIBILITY:
                {
                    NSString* value=@"";
                    if ([propertyInfo allValues].count>2) {
                        if ((valueObj!=nil && ![valueObj isKindOfClass:NSString.class]) || (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO)) {
                            value = [propertyInfo objectForKey:@"v1"];
                        }else{
                            value = [propertyInfo objectForKey:@"v2"];
                        }
                        value = [self valueForVariable:value fromJsonData:jsonData];
                    }else{
                        value = (NSString*)valueObj;
                    }

                    if ([value isEqualToString:@"invisible"]) {
                        intValue = INVISIBLE;
                    }else if([value isEqualToString:@"visible"]) {
                        intValue = VISIBLE;
                    }else{
                        intValue = GONE;
                    }
                    [item setIntValue:intValue forKey:[key intValue]];
                    [dataCache setObject:[NSNumber numberWithInt:intValue] forKey:@"value"];
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
                        value = [self valueForVariable:value fromJsonData:jsonData];
                    }else{
                        value = (NSString*)valueObj;
                    }

                    intValue = [self getValue4Array:[value componentsSeparatedByString:@"|"]];
                    [item setIntValue:intValue forKey:keyValue];
                    [dataCache setObject:[NSNumber numberWithInt:intValue] forKey:@"value"];
                }
                    break;
                case TYPE_OBJECT:
                    objValue = [jsonData objectForKey:varName];
                    if (objValue) {
                        [item setDataObj:objValue forKey:keyValue];
                        [dataCache setObject:objValue forKey:@"value"];
                    }
                    break;
                default:
                    break;
            }
        }
        //[item setDataObj:(NSDictionary*)obj];
        item.actionValue = [jsonData objectForKey:item.action];
        
        [item didFinishBinding];
    }
    [self.dataCacheDic setObject:widgetValues forKey:jsonData];

    [self.virtualView calculateLayoutSize:self.frame.size];
    
    [self.virtualView layoutSubviews];
    [self setNeedsDisplay];

}

- (VVViewObject*)findObjectByID:(int)tagid{
    //
    VVViewObject* obj=[self.virtualView findViewByID:tagid];
    return obj;
}
@end

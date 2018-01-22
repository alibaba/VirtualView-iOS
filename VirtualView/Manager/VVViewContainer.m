//
//  VVViewContainer.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVViewContainer.h"
#import "VVLayout.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"

@interface VVViewContainer()<VVWidgetAction>{
    UILongPressGestureRecognizer* _pressRecognizer;
}
@property(nonatomic, strong)NSMutableArray *dataTagObjs;
@property(weak, nonatomic)NSObject*            updateDataObj;
@end

@implementation VVViewContainer

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type
{
    VVBaseNode *vv = [[VVTemplateManager sharedManager] createNodeTreeForType:type];
    VVViewContainer *vvc = [[VVViewContainer alloc] initWithVirtualView:vv];
    [vvc attachViews];
    return vvc;
}

- (void)updateDisplayRect:(CGRect)rect{

}

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint pt =[gestureRecognizer locationInView:self];
    id<VVWidgetObject> vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [(VVBaseNode*)vvobj isLongClickable]) {
        [self.delegate subViewLongPressed:vvobj.action andValue:vvobj.actionValue gesture:gestureRecognizer];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch =  [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    id<VVWidgetObject> vvobj=[self.virtualView hitTest:pt];
    if (vvobj!=nil && [(VVBaseNode*)vvobj isClickable]) {
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

- (id)initWithVirtualView:(VVBaseNode*)virtualView{
    self = [super init];
    if (self) {
        self.virtualView = virtualView;
        self.virtualView.updateDelegate = self;
        self.backgroundColor = [UIColor clearColor];
        _dataTagObjs = [NSMutableArray array];
        [VVViewContainer getDataTagObjsHelper:virtualView collection:_dataTagObjs];
        if ([self.virtualView isLongClickable]) {
            _pressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
            [self addGestureRecognizer:_pressRecognizer];
        }
    }
    return self;
}

- (void) attachViews {
    [self attachViews:self.virtualView];
}

- (void) attachViews:(VVBaseNode*)virtualView {
    
    if ([virtualView isKindOfClass:VVLayout.class]) {
        for (VVLayout* item in virtualView.subViews) {
            [self attachViews:item];
        }
    } else if(virtualView.cocoaView && virtualView.visible!=VVVisibilityGone) {
        [self addSubview:virtualView.cocoaView];
    }
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

- (void)update:(NSObject*)obj{
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    NSDictionary* jsonData = (NSDictionary*)obj;

    for (VVBaseNode* item in self.dataTagObjs) {
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
                    } else {
                        [item setIntValue:0 forKey:setter.key];
                    }
                }
                    break;
                case TYPE_VISIBILITY:
                {
                    if ([stringValue isEqualToString:@"invisible"]) {
                        [item setIntValue:VVVisibilityInvisible forKey:setter.key];
                    } else if ([stringValue isEqualToString:@"visible"]) {
                        [item setIntValue:VVVisibilityVisible forKey:setter.key];
                    } else {
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
        item.actionValue = [jsonData objectForKey:item.action];
        
        [item didFinishBinding];
    }

    [self.virtualView calculateLayoutSize:self.frame.size];
    
    [self.virtualView layoutSubviews];
    [self setNeedsDisplay];

}

- (VVBaseNode*)findObjectByID:(int)tagid{
    VVBaseNode* obj=[self.virtualView findViewByID:tagid];
    return obj;
}

+ (void)getDataTagObjsHelper:(VVBaseNode *)node collection:(NSMutableArray *)dataTagObjs
{
    if (node.expressionSetters.count > 0) {
        [dataTagObjs addObject:node];
    }
    for (VVBaseNode *subNode in node.subViews) {
        [self getDataTagObjsHelper:subNode collection:dataTagObjs];
    }
}

@end

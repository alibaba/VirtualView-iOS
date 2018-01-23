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

- (void)update:(NSObject*)obj{
    if (obj==nil || obj==self.updateDataObj) {
        return;
    }else{
        self.updateDataObj = obj;
    }
    NSDictionary* jsonData = (NSDictionary*)obj;

    for (VVBaseNode* item in self.dataTagObjs) {
        [item reset];

        for (VVPropertyExpressionSetter *setter in item.expressionSetters.allValues) {
            if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                [setter applyToNode:item withDict:jsonData];
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

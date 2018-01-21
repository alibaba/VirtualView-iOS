//
//  VVViewContainer.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"

@protocol VirtualViewDelegate
@optional
- (void)subViewClicked:(NSString*)action andValue:(NSString*)value;
- (void)subView:(VVBaseNode *)view clicked:(NSString*)action andValue:(NSString*)value;
- (void)subViewLongPressed:(NSString*)action andValue:(NSString*)value gesture:(UILongPressGestureRecognizer *)gesture;
@end

@interface VVViewContainer : UIView
@property(nonatomic, strong)VVBaseNode* virtualView;
@property(nonatomic, weak)NSObject<VirtualViewDelegate> *delegate;

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type;

- (id)initWithVirtualView:(VVBaseNode*)virtualView;
- (void)attachViews;
- (void) attachViews:(VVBaseNode*)virtualView;
- (void)update:(NSObject*)obj;
- (VVBaseNode*)findObjectByID:(int)tagid;

+ (void)getDataTagObjsHelper:(VVBaseNode *)node collection:(NSMutableArray *)dataTagObjs;

@end

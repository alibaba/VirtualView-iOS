//
//  VVViewContainer.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVViewObject.h"

@protocol VirtualViewDelegate
@optional
- (void)subViewClicked:(NSString*)action andValue:(NSString*)value;
- (void)subView:(VVViewObject *)view clicked:(NSString*)action andValue:(NSString*)value;
- (void)subViewLongPressed:(NSString*)action andValue:(NSString*)value gesture:(UILongPressGestureRecognizer *)gesture;
@end

@interface VVViewContainer : UIView
@property(nonatomic, strong)NSMutableArray *dataTagObjs;
@property(nonatomic, strong)VVViewObject* virtualView;
@property(nonatomic, weak)NSObject<VirtualViewDelegate> *delegate;
- (id)initWithVirtualView:(VVViewObject*)virtualView;
- (void)attachViews;
- (void) attachViews:(VVViewObject*)virtualView;
- (void)update:(NSObject*)obj;
- (VVViewObject*)findObjectByID:(int)tagid;
@end

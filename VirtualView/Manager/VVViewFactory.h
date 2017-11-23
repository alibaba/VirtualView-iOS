//
//  VVViewFactory.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VVViewObject;

@interface StringInfo : NSObject
@property(assign, nonatomic)CGSize drawRect;
@property(strong, nonatomic)NSMutableAttributedString* attstr;
@end

@interface VVViewFactory : NSObject
+ (VVViewFactory*)shareFactoryInstance;
- (VVViewObject*)parseWidgetWithTypeID:(NSString*)key collection:(NSMutableArray*)dataTagObjs;
//- (VVViewObject*)parseWidgetWithTypeID:(NSUInteger)typeID;
- (VVViewObject*)makeWidgetWithID:(short)widgetid;
- (UIView*)obtainVirtualWithKey:(NSString*)key;
- (UIView*)obtainVirtualWithKey:(NSString*)key maxSize:(CGSize)size;
- (StringInfo*)getDrawStringInfo:(NSString*)value andFrontSize:(CGFloat)size;
- (void)setDrawStringInfo:(StringInfo*)strInfo forString:(NSString*)value frontSize:(CGFloat)size;
@end

//
//  VVViewFactory.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VVViewObject;

//****************************************************************

@interface StringInfo : NSObject

@property (nonatomic, assign) CGSize drawRect;
@property (nonatomic, strong) NSMutableAttributedString *attstr;

@end

//****************************************************************

@interface VVViewFactory : NSObject

+ (VVViewFactory *)shareFactoryInstance;
- (VVViewObject *)parseWidgetWithTypeID:(NSString *)key collection:(NSMutableArray *)dataTagObjs;
- (UIView *)obtainVirtualWithKey:(NSString *)key;

- (StringInfo*)getDrawStringInfo:(NSString*)value andFrontSize:(CGFloat)size;
- (void)setDrawStringInfo:(StringInfo*)strInfo forString:(NSString*)value frontSize:(CGFloat)size;

@end

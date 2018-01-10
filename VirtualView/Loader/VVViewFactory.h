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

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface StringInfo : NSObject

@property (nonatomic, assign) CGSize drawRect __deprecated;
@property (nonatomic, strong) NSMutableAttributedString *attstr __deprecated;

@end

//****************************************************************

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVViewFactory : NSObject

+ (VVViewFactory *)shareFactoryInstance __deprecated;
- (VVViewObject *)parseWidgetWithTypeID:(NSString *)key collection:(NSMutableArray *)dataTagObjs __deprecated;
- (UIView *)obtainVirtualWithKey:(NSString *)key __deprecated;

- (StringInfo *)getDrawStringInfo:(NSString *)value andFrontSize:(CGFloat)size __deprecated;
- (void)setDrawStringInfo:(StringInfo *)strInfo forString:(NSString *)value frontSize:(CGFloat)size __deprecated;

@end

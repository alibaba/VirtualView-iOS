//
//  VVViewFactory.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VVViewObject;
@class VVViewContainer;

//****************************************************************

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface StringInfo : NSObject

@property (nonatomic, assign) CGSize drawRect /*__deprecated*/;
@property (nonatomic, strong) NSMutableAttributedString *attstr /*__deprecated*/;

@end

//****************************************************************

/**
 This class will be deprecated.
 DO NOT use it.
 */
@interface VVViewFactory : NSObject

+ (VVViewFactory *)shareFactoryInstance __deprecated;
- (VVViewObject *)parseWidgetWithTypeID:(NSString *)key collection:(NSMutableArray *)dataTagObjs __deprecated_msg("use [VVTemplateManager createNodeTreeForType:] and get dataTagObjs by yourself");
- (VVViewContainer *)obtainVirtualWithKey:(NSString *)key __deprecated_msg("will be moved to VVViewContainer");

- (StringInfo *)getDrawStringInfo:(NSString *)value andFrontSize:(CGFloat)size /*__deprecated*/;
- (void)setDrawStringInfo:(StringInfo *)strInfo forString:(NSString *)value frontSize:(CGFloat)size /*__deprecated*/;

@end

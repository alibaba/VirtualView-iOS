//
//  VVViewContainer.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"

@protocol VirtualViewDelegate <NSObject>

@optional

- (void)virtualViewClickedWithAction:(NSString *)action andValue:(NSString *)value;
- (void)virtualView:(VVBaseNode *)node clickedWithAction:(NSString *)action andValue:(NSString *)value;
- (void)virtualViewLongPressedWithAction:(NSString *)action andValue:(NSString *)value;
- (void)virtualView:(VVBaseNode *)node longPressedWithAction:(NSString *)action andValue:(NSString *)value;

@end

@interface VVViewContainer : UIView

@property (nonatomic, strong, readonly) VVBaseNode *rootNode;
@property (nonatomic, weak) id<VirtualViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL alwaysRefresh;

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type;
+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type alwaysRefresh:(BOOL)alwaysRefresh;
- (id)initWithRootNode:(VVBaseNode *)rootNode;
- (id)initWithRootNode:(VVBaseNode *)rootNode alwaysRefresh:(BOOL)alwaysRefresh;

/**
 Get estimated size of VirtualView.
 Cannot get correct size if VirtualView will change size after binding data (wrap_content).
 If you want to calculate size via this method, try these steps:
 (will cost a lot of CPU resources & not tested adequately)
 1. call "updateData:"
 2. call "estimatedSize:" to calculate correct size
 3. update the frame of VVViewContainer
 4. call "updatelayout"
 */
- (CGSize)estimatedSize:(CGSize)maxSize;
/**
 Get established size of VirtualView.
 Will get zero size if VirtualView will change size after binding data (wrap_content).
 */
- (CGSize)establishedSize:(CGSize)maxSize;
/**
 Get established fixed size of VirtualView.
 Will get zero size if size of VirtualView is not fixed.
 */
- (CGSize)establishedSize;

/**
 Bind new data to VirtualView and resize & layout it if it is necessary.
 */
- (void)update:(id)data;
/**
 Bind new data to VirtualView.
 */
- (void)updateData:(id)data;
/**
 Resize & layout VirtualView if it is necessary.
 */
- (void)updateLayout;

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID;

+ (NSArray *)variableNodes:(VVBaseNode *)rootNode;

@end

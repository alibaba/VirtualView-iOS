//
//  NVLineView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"
#import "VVLineLayer.h"

@interface NVLineView : VVBaseNode

@property (nonatomic, strong, nonnull) VVLineLayer *lineLayer;

@property (nonatomic, assign) VVOrientation orientation;
@property (nonatomic, assign) VVGravity gravity;
//@property (nonatomic, assign) VVLineStyle style;
//@property (nonatomic, assign) NSArray<NSNumber *> *dashEffect;

@end

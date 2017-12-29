//
//  NVTextView.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVViewObject.h"

typedef enum : NSUInteger {
    VVTextStyleNormal = 0,
    VVTextStyleBold = 1,
    VVTextStyleItalic = 2,
    VVTextStyleUnderLine = 4,
    VVTextStyleStrike = 8
} VVTextStyle;

@interface NVTextView : VVViewObject
@property(strong, nonatomic)NSString* text;
@property(strong, nonatomic)NSAttributedString *attributedText;
@property(assign, nonatomic)CGFloat frontSize;
@property(assign, nonatomic)VVTextStyle textStyle;
@property(assign, nonatomic, readonly)BOOL bold;
@property(strong, nonatomic)UIColor*   borderColor;
- (void)updateTextFrameSize;
@end

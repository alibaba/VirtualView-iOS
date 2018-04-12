//
//  NVTextView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"

@interface VVLabel : UILabel

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingBottom;

@end

//################################################################

@interface NVTextView : VVBaseNode

@property (nonatomic, strong) VVLabel *textView;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSAttributedString *attributedText;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, assign) VVTextStyle textStyle;
@property (nonatomic, assign) VVEllipsize ellipsize;
@property (nonatomic, assign) int lines;
@property (nonatomic, assign) int maxLines;
@property (nonatomic, assign) VVGravity gravity;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineSpaceExtra; // appearance may be different from Android

@end

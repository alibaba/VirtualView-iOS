//
//  NVTextView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"



@interface NVTextView : VVBaseNode
@property(strong, nonatomic)NSString* text;
@property(strong, nonatomic)NSAttributedString *attributedText;
@property(assign, nonatomic)CGFloat frontSize;
@property(assign, nonatomic)VVTextStyle textStyle;
@property(assign, nonatomic, readonly)BOOL bold;
@property(strong, nonatomic)UIColor*   borderColor;
- (void)updateTextFrameSize;
@end

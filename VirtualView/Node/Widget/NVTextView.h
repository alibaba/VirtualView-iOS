//
//  NVTextView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"
#import "VVDefines.h"

@interface NVTextView : VVBaseNode
@property(strong, nonatomic)NSString* text;
@property(strong, nonatomic)NSAttributedString *attributedText;
@property(nonatomic, strong)UILabel* textView;
@property(assign, nonatomic)CGFloat frontSize;
@property(assign, nonatomic)VVTextStyle textStyle;
@property(strong, nonatomic)UIColor*   borderColor;
- (void)updateTextFrameSize;
@end

//
//  NVTextView.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVViewObject.h"
@interface NVTextView : VVViewObject
@property(strong, nonatomic)NSString* text;
@property(strong, nonatomic)NSAttributedString *attributedText;
@property(assign, nonatomic)CGFloat frontSize;
@property(assign, nonatomic)BOOL bold;
@property(strong, nonatomic)UIColor*   borderColor;
- (void)updateTextFrameSize;
@end

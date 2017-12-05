//
//  VVNavtiveViewContainer.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVNavtiveViewContainer.h"
#import "VVBinaryLoader.h"
#import "VVSystemKey.h"
@interface VVNavtiveViewContainer ()
@property(weak, nonatomic)id<NativeViewObject> nativeView;
@end

@implementation VVNavtiveViewContainer
- (BOOL)setStringValue:(int)value forKey:(int)key{
    int ret = [super setStringValue:value forKey:key];
    if (!ret) {
        switch (key) {
            case STR_ID_NativeContainer:
            {
                NSString* stringValue  = [[VVBinaryLoader shareInstance] getStrCodeWithType:value];
                NSString* className = [[VVSystemKey shareInstance] classNameForTag:stringValue];
                Class cls = NSClassFromString(className);
                #ifdef VV_DEBUG
                    NSLog(@"make native class name:%@",className);
                #endif

                self.cocoaView = [[cls alloc] init];
                self.nativeView = (id<NativeViewObject>)self.cocoaView;
                if ([self.cocoaView isKindOfClass:UIView.class]==NO) {
                    #ifdef VV_DEBUG
                        NSLog(@"'%@' is not kind of native view, container can't load.",self.cocoaView);
                    #endif
                    self.cocoaView = nil;
                }
            }
                break;
                
            default:
                break;
        }
    }
    return ret;
}

- (void)setDataObj:(NSObject *)obj forKey:(int)key{
    
    switch (key) {
        case STR_ID_dataTag:
            if ([self.nativeView respondsToSelector:@selector(setDataObject:forKey:)]) {
                [self.nativeView setDataObject:obj forKey:key];
            }
            break;
            
        default:
            break;
    }
}

- (CGSize)nativeContentSize{
    return self.maxSize;
}

@end

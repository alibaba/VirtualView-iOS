//
//  VVErrors.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSErrorDomain const VVErrorDomain;

#if __IPHONE_OS_VERSION_MAX_ALLOWED <=  __IPHONE_10_2
NS_ENUM(NSInteger) {
#else
NS_ERROR_ENUM(VVErrorDomain) {
#endif
    VVUnknownError = 0,
    VVNeedToBeOverridedError,
    VVWrongHeaderError,
    VVInvalidDataError
};

#define VVMakeError(errorCode, errorDescription) [NSError errorWithDomain:VVErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@ - %@: %@", self.class, NSStringFromSelector(_cmd), errorDescription]}]

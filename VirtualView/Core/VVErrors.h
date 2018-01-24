//
//  VVErrors.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSErrorDomain const VVErrorDomain;

NS_ERROR_ENUM(VVErrorDomain) {
    VVUnknownError = 0,
    VVNeedToBeOverridedError,
    VVWrongHeaderError,
    VVInvalidDataError
};

#define VVMakeError(errorCode, errorDescription) [NSError errorWithDomain:VVErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@ - %@: %@", self.class, NSStringFromSelector(_cmd), errorDescription]}]

//
//  VVErrors.h
//  VirtualView
//
//  Created by HarrisonXi on 2018/1/12.
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

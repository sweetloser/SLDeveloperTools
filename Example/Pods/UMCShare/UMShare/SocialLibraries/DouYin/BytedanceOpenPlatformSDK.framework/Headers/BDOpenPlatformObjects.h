//
//  BDOpenPlatformObjects.h
//
//  Created by ByteDance on 2019/7/8.
//  Copyright (c) 2018年 ByteDance Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDOpenPlatformBaseResponse;

typedef NS_ENUM(NSInteger, BDOpenPlatformErrorCode) {
    BDOpenPlatformSuccess                = 0,
    BDOpenPlatformErrorCodeCommon        = -1,
    BDOpenPlatformErrorCodeUserCanceled  = -2,
    BDOpenPlatformErrorCodeSendFailed    = -3,
    BDOpenPlatformErrorCodeAuthDenied    = -4,
    BDOpenPlatformErrorCodeUnsupported   = -5,
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^BDOpenPlatformRequestCompletedBlock) (BDOpenPlatformBaseResponse *resp);

@interface BDOpenPlatformBaseRequest : NSObject
/**
Passing additional sharing requests param;
*/
@property (nonatomic, copy, nullable) NSDictionary *extraInfo;
@end

@interface BDOpenPlatformBaseResponse : NSObject

@property (nonatomic, readonly, assign) BOOL isSucceed;//!< YES for succeess

@property (nonatomic, assign) BDOpenPlatformErrorCode errCode;//!< if failed failed error code

@property (nonatomic, copy, nullable) NSString *errString;//!< if failed error description

@end

NS_ASSUME_NONNULL_END

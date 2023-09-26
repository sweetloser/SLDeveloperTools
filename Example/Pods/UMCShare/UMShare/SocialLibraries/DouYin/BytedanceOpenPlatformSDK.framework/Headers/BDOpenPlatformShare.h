//
//  BDOpenPlatformShareRequest.h
//
//  Created by ByteDance on 2019/7/8.
//  Copyright (c) 2018年 ByteDance Ltd. All rights reserved.

#import "BDOpenPlatformObjects.h"
#import "BDOpenPlatformApplicationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BDOpenPlatformShareMediaType) {
    BDOpenPlatformShareMediaTypeImage = 0, //!< Map to PHAssetMediaTypeImage
    BDOpenPlatformShareMediaTypeVideo, //!< Map to PHAssetMediaTypeVideo
};

typedef NS_ENUM(NSUInteger, BDOpenPlatformLandedPageType) {
    BDOpenPlatformLandedPageClip = 0,//!< Landed to Clip ViewController
    BDOpenPlatformLandedPageEdit,//!< Landed to Edit ViewController
    BDOpenPlatformLandedPagePublish,//!< Landed to Edit ViewController
};


typedef NS_ENUM(NSInteger, BDOpenPlatformShareRespState) {
    BDOpenPlatformShareRespStateSuccess                         = 20000, //!< Success
    BDOpenPlatformShareRespStateUnknownError                    = 20001, //!< Unknown or current SDK version unclassified error
    BDOpenPlatformShareRespStateParamValidError                 = 20002, //!< Params parsing error, media resource type difference you pass
    BDOpenPlatformShareRespStateSharePermissionDenied           = 20003, //!< Not enough permissions to operation.
    BDOpenPlatformShareRespStateUserNotLogin                    = 20004, //!< User not login
    BDOpenPlatformShareRespStateNotHavePhotoLibraryPermission   = 20005, //!< Has no album permissions
    BDOpenPlatformShareRespStateNetworkError                    = 20006, //!< Network error
    BDOpenPlatformShareRespStateVideoTimeLimitError             = 20007, //!< Video length doesn't meet requirements
    BDOpenPlatformShareRespStatePhotoResolutionError            = 20008, //!< Photo doesn't meet requirements
    BDOpenPlatformShareRespTimeStampError                       = 20009, //!< Timestamp check failed
    BDOpenPlatformShareRespStateHandleMediaError                = 20010, //!< Processing photo resources faild
    BDOpenPlatformShareRespStateVideoResolutionError            = 20011, //!< Video resolution doesn't meet requirements
    BDOpenPlatformShareRespStateVideoFormatError                = 20012, //!< Video format is not supported
    BDOpenPlatformShareRespStateCancel                          = 20013, //!< Sharing canceled
    BDOpenPlatformShareRespStateHaveUploadingTask               = 20014, //!< Another video is currently uploading
    BDOpenPlatformShareRespStateSaveAsDraft                     = 20015, //!< Users store shared content for draft or user accounts are not allowed to post videos
    BDOpenPlatformShareRespStatePublishFailed                   = 20016, //!< Post share content failed
    BDOpenPlatformShareRespStateMediaInIcloudError              = 21001, //!< Downloading from iCloud faild
    BDOpenPlatformShareRespStateParamsParsingError              = 21002, //!< Internal params parsing error
    BDOpenPlatformShareRespStateGetMediaError                   = 21003, //!< Media resources do not exist
};

BDOpenPlatformShareRespState BDOpenPlatformStringToShareState(NSString *string);


@class BDOpenPlatformShareResponse;

typedef void(^BDOpenPlatformShareCompleteBlock)(BDOpenPlatformShareResponse *Response);

@interface BDOpenPlatformShareRequest : BDOpenPlatformBaseRequest

- (instancetype)init  __attribute__((unavailable("use -initWithType: for initialization")));

/**
 * @brief Designated Initization
 *
 * @return An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
 */
- (instancetype)initWithType:(NSInteger)type;

/**
 The local identifier of the video or image shared by the your application to Open Platform in the **Photo Album**. The content must be all images or video.

 - The aspect ratio of the images or videos should between: [1/2.2, 2.2]
 - If mediaType is Image:
    - The number of images should be more than one and up to 12.
 - If mediaType is Video:
    - Total video duration should be longer than 3 seconds.
    - No more than 12 videos can be shared
 - Video with brand logo or watermark will lead to video deleted or account banned. Make sure your applications share contents without watermark.
 */
@property (nonatomic, strong) NSArray *localIdentifiers;

/**
 Which page do you want to land on?
 Defualt is Clip Viewcontroller
 */

@property (nonatomic, assign) BDOpenPlatformLandedPageType landedPageType;
/**
 To associate your video with a hashtag, set the hashtag property on the request. The length cannot exceed 35
 */
@property (nonatomic, copy) NSString *hashtag;

/**
 The Media type of localIdentifiers in Album, All attachment localIdentifiers must be the same type
 */
@property (nonatomic, assign) BDOpenPlatformShareMediaType mediaType;

/**
 Used to identify the uniqueness of the request, and finally returned by App when jumping back to the third-party program
 */
@property (nonatomic, copy, nullable) NSString *state;

/**
 * @brief Send share request to Open Platform.
 *
 * @param completed  The async result call back. You can get result in share response.isSucceed;
 *
 * @return Share request is valid will return YES;
 */
- (BOOL)sendShareRequestWithCompleteBlock:(BDOpenPlatformShareCompleteBlock) completed;
@end

@interface BDOpenPlatformShareResponse : BDOpenPlatformBaseResponse
/**
 Used to identify the uniqueness of the request, and finally returned by App when jumping back to the third-party program
 */
@property (nonatomic, copy, nullable) NSString *state;

@property (nonatomic, assign) BDOpenPlatformShareRespState shareState;

@end

NS_ASSUME_NONNULL_END

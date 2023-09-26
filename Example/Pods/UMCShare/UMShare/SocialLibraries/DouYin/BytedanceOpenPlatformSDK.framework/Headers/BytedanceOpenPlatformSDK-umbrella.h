#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BDOpenPlatformApplicationDelegate.h"
#import "BDOpenPlatformAuth.h"
#import "BDOpenPlatformObjects.h"
#import "BDOpenPlatformShare.h"

FOUNDATION_EXPORT double BytedanceOpenPlatformSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char BytedanceOpenPlatformSDKVersionString[];


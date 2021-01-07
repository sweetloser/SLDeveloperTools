//
//  BXKTVHTTPCacheManager.h
//  BXlive
//
//  Created by bxlive on 2019/4/3.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXKTVHTTPCacheManager : NSObject

+ (BXKTVHTTPCacheManager *)shareHTTPCacheManager;

+ (NSURL *)getProxyURLWithOriginalURL:(NSURL *)URL;







@end

NS_ASSUME_NONNULL_END

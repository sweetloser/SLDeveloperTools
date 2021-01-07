//
//  BXKTVHTTPCacheManager.m
//  BXlive
//
//  Created by bxlive on 2019/4/3.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXKTVHTTPCacheManager.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface BXKTVHTTPCacheManager ()

@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation BXKTVHTTPCacheManager

+ (BXKTVHTTPCacheManager *)shareHTTPCacheManager {
    static dispatch_once_t onceToken;
    static BXKTVHTTPCacheManager *_cacheManager = nil;
    dispatch_once(&onceToken, ^{
        _cacheManager = [[BXKTVHTTPCacheManager alloc]init];
    });
    return _cacheManager;
}

+ (NSURL *)getProxyURLWithOriginalURL:(NSURL *)URL {
    if (!URL) {
        return URL;
    }
    BXKTVHTTPCacheManager *cacheManager = [BXKTVHTTPCacheManager shareHTTPCacheManager];
    NSURL * proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:URL];
    if (cacheManager.urls.count > 15) {
        NSInteger len = cacheManager.urls.count - 15;
        NSArray *subUrls = [cacheManager.urls subarrayWithRange:NSMakeRange(0, len)];
        for (NSURL *theURL in subUrls) {
            [KTVHTTPCache cacheDeleteCacheWithURL:theURL];
            [cacheManager.urls removeObject:theURL];
        }
    }
    if (![cacheManager.urls containsObject:proxyURL]) {
        [cacheManager.urls addObject:proxyURL];
    }
    return proxyURL;
}

- (instancetype)init {
    if ([super init]) {
        _urls = [NSMutableArray array];
    }
    return self;
}

@end

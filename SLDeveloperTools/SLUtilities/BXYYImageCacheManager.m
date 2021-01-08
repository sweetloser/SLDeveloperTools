//
//  BXYYImageCacheManager.m
//  BXlive
//
//  Created by bxlive on 2019/5/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXYYImageCacheManager.h"
#import <YYWebImage/YYWebImage.h>

@interface BXYYImageCacheManager ()

@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation BXYYImageCacheManager

+ (BXYYImageCacheManager *)sharedCacheManager {
    static dispatch_once_t onceToken;
    static BXYYImageCacheManager *_cacheManager = nil;
    dispatch_once(&onceToken, ^{
        _cacheManager = [[BXYYImageCacheManager alloc]init];
    });
    return _cacheManager;
}

- (void)addImageURLForKey:(NSURL *)imageURL{
    if (!imageURL) {
        return;
    }
    BXYYImageCacheManager *cacheManager = [BXYYImageCacheManager sharedCacheManager];
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *cacheUrl = [manager cacheKeyForURL:imageURL];
    if (cacheManager.urls.count > 15) {
        NSInteger len = cacheManager.urls.count - 15;
        NSArray *subUrls = [cacheManager.urls subarrayWithRange:NSMakeRange(0, len)];
        for (NSString *theURL in subUrls) {
            [[YYImageCache sharedCache].memoryCache removeObjectForKey:theURL];
            [cacheManager.urls removeObject:theURL];
        }
        
    }
    if (![cacheManager.urls containsObject:cacheUrl]) {
        [cacheManager.urls addObject:cacheUrl];
    }
    
}

- (instancetype)init {
    if ([super init]) {
        _urls = [NSMutableArray array];
    }
    return self;
}

@end

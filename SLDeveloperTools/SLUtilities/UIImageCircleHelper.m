//
//  UIImageCircleHelper.m
//  BXlive
//
//  Created by bxlive on 2019/5/5.
//  Copyright © 2019 cat. All rights reserved.
//

#import "UIImageCircleHelper.h"
#import <YYCategories/YYCategories.h>

@implementation UIImageCircleHelper







+ (YYWebImageManager *)avatarImageManagerCornerRadius:(CGFloat)radius
                                          borderWidth:(CGFloat)borderWidth
                                          borderColor:(UIColor *)borderColor{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"doushu.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image yy_imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor]; // a large value
        };
    });
    return manager;
}



@end

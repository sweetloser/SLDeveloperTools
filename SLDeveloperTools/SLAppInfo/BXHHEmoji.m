//
//  BXHHEmoji.m
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXHHEmoji.h"
#import <YYCache/YYCache.h>
#import <YYImage/YYImage.h>
#import <YYCategories/YYCategories.h>
#import <SDWebImage/UIImage+ForceDecode.h>
@implementation BXHHEmoji

+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"InnerStickersInfo" ofType:@"plist"];
        dic = [self _emoticonDicFromPath:path];
    });
    return dic;
}
+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        NSArray *emoticons = dict[@"emoticons"];
        for (NSDictionary *theDic in emoticons) {
            [dic setValue:theDic[@"image"] forKey:theDic[@"desc"]];
        }
    }
    return dic;
}

+ (YYCache *)imageCache {
    static YYCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYCache alloc] initWithName:@"emojiImageCache"];
//        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
//        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
//        cache.name = @"emojiImageCache";
    });
    return cache;
}

+ (UIImage *)imageWithPath:(NSString *)path{
    if (!path) return nil;
    UIImage *image  = (UIImage *)[[self imageCache] objectForKey:path];
    if (image) return image;
    NSString *paths = [[NSBundle mainBundle] pathForResource:@"Sticker" ofType:@"bundle"];
    paths = [paths stringByAppendingPathComponent:path];
    image = [UIImage imageWithContentsOfFile:paths];
    if (image) {
        image = [image yy_imageByDecoded];
        [[self imageCache] setObject:image forKey:path];
    }
    return image;
}
+(UIImage *)imageWithEmojiString:(NSString *)emojiString{
    if(!emojiString) return nil;
    NSString *imagePath = [BXHHEmoji emoticonDic][emojiString];
    UIImage *image = [BXHHEmoji imageWithPath:imagePath];
    return image;
}

@end

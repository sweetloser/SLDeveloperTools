//
//  HHCacheHelper.m
//  BXlive
//
//  Created by bxlive on 2018/4/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "CacheHelper.h"
#import "FilePathHelper.h"

#define kStorage   @"Storage"



@implementation CacheHelper




+ (BOOL)containsObjectForKey:(NSString *)key {
    return [FilePathHelper fileIsExistsAtPath:[self getFilePathWithKey:key]];
}

+ (void)setObject:(id)object forKey:(NSString *)key {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    BOOL result = [data writeToFile:[self getFilePathWithKey:key] atomically:YES];
    if (result) {
        NSLog(@"归档成功");
    } else {
        NSLog(@"归档失败");
    }
}

+ (id<NSCoding>)objectForKey:(NSString *)key {
    NSData *data = [NSData dataWithContentsOfFile:[self getFilePathWithKey:key]];
    if (data && data.length) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        id object = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return object;
    } else {
        return nil;
    }
}

/// 删除文件 （ 将 ~/Documents/Storage/${key} 文件删除）
/// @param key 文件名
+ (void)removeObjectForKey:(NSString *)key {
    [FilePathHelper removeFileAtPath:[self getFilePathWithKey:key]];
}

/// 返回一个路径  ` ~/Documents/Storage/${key}`
/// @param key 文件名
+ (NSString *)getFilePathWithKey:(NSString *)key {
    NSString *cachesPath = [FilePathHelper getDocumentsPath];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:kStorage];
    [FilePathHelper createFolder:filePath];
    return [filePath stringByAppendingPathComponent:key];
}

//+ (BOOL)containsObjectForKey:(NSString *)key {
//    return [[self getCache] containsObjectForKey:key];
//}
//
//+ (void)setObject:(id)object forKey:(NSString *)key {
//    [[self getCache] setObject:object forKey:key];
//}
//
//+ (id<NSCoding>)objectForKey:(NSString *)key {
//    return [[self getCache] objectForKey:key];
//}
//
//+ (void)removeObjectForKey:(NSString *)key {
//    [[self getCache] removeObjectForKey:key];
//}
//+ (void)removeAllObjects {
//    [[self getCache] removeAllObjects];
//}
//
//+ (YYCache*)getCache {
//    if (!_cache) {
//        _cache = [YYCache cacheWithName:@"HHCache"];
//    }
//    return _cache;
//}

@end

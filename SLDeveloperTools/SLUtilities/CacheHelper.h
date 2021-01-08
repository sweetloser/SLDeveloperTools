//
//  HHCacheHelper.h
//  BXlive
//
//  Created by bxlive on 2018/4/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject

+ (BOOL)containsObjectForKey:(NSString *)key;
+ (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
+ (id<NSCoding>)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

@end

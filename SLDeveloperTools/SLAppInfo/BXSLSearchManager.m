//
//  BXSLSearchManager.m
//  BXlive
//
//  Created by bxlive on 2019/3/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchManager.h"
#import <MMKV/MMKV.h>

@implementation BXSLSearchManager

+ (BXSLSearchManager *)shareSearchManager {
    static dispatch_once_t onceToken;
    static BXSLSearchManager *_searchManager = nil;
    dispatch_once(&onceToken, ^{
        _searchManager = [[BXSLSearchManager alloc]init];
    });
    return _searchManager;
}

+ (void)addSearchHistoryWithSearchText:(NSString *)searchText {
    if (searchText) {
        NSMutableArray *searchHistorys = [BXSLSearchManager getSearchHistorys].mutableCopy;
        if ([searchHistorys containsObject:searchText]) {
            [searchHistorys removeObject:searchText];
        }
        [searchHistorys insertObject:searchText atIndex:0];
        MMKV *mmkv = [MMKV defaultMMKV];
        [mmkv setObject:searchHistorys forKey:@"SearchHistory"];
    }
}

+ (NSArray *)getSearchHistorys {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSArray *searchHistorys = [mmkv getObjectOfClass:[NSArray class] forKey:@"SearchHistory"];
    if (!searchHistorys) {
        searchHistorys = [NSMutableArray array];
    }
    return searchHistorys;
}

+ (void)removeSearchHistoryWithSearchText:(NSString *)searchText {
    MMKV *mmkv = [MMKV defaultMMKV];
    if (!searchText) {
        [mmkv removeValueForKey:@"SearchHistory"];
    } else {
        NSMutableArray *searchHistorys = [BXSLSearchManager getSearchHistorys].mutableCopy;
        if ([searchHistorys containsObject:searchText]) {
            [searchHistorys removeObject:searchText];
            [mmkv setObject:searchHistorys forKey:@"SearchHistory"];
        }
    }
}

+ (void)addMusicSearchHistoryWithSearchText:(NSString *)searchText {
    if (searchText) {
        NSMutableArray *musicSearchHistorys = [BXSLSearchManager getMusicSearchHistorys].mutableCopy;
        if ([musicSearchHistorys containsObject:searchText]) {
            [musicSearchHistorys removeObject:searchText];
        }
        [musicSearchHistorys insertObject:searchText atIndex:0];
        MMKV *mmkv = [MMKV defaultMMKV];
        [mmkv setObject:musicSearchHistorys forKey:@"MusicSearchHistory"];
    }
}

+ (NSArray *)getMusicSearchHistorys {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSArray *musicSearchHistorys = [mmkv getObjectOfClass:[NSArray class] forKey:@"MusicSearchHistory"];
    if (!musicSearchHistorys) {
        musicSearchHistorys = [NSMutableArray array];
    }
    return musicSearchHistorys;
}

+ (void)removeMusicSearchHistoryWithSearchText:(NSString *)searchText {
    MMKV *mmkv = [MMKV defaultMMKV];
    if (!searchText) {
        [mmkv removeValueForKey:@"MusicSearchHistory"];
    } else {
        NSMutableArray *musicSearchHistorys = [BXSLSearchManager getMusicSearchHistorys].mutableCopy;
        if ([musicSearchHistorys containsObject:searchText]) {
            [musicSearchHistorys removeObject:searchText];
            [mmkv setObject:musicSearchHistorys forKey:@"MusicSearchHistory"];
        }
    }
}


+ (void)addGoodsSearchHistoryWithSearchText:(NSString *)searchText {
    if (searchText) {
        NSMutableArray *goodsSearchHistorys = [BXSLSearchManager getGoodsSearchHistorys].mutableCopy;
        if ([goodsSearchHistorys containsObject:searchText]) {
            [goodsSearchHistorys removeObject:searchText];
        }
        [goodsSearchHistorys insertObject:searchText atIndex:0];
        MMKV *mmkv = [MMKV defaultMMKV];
        [mmkv setObject:goodsSearchHistorys forKey:@"GoodsSearchHistory"];
    }
}

+ (NSArray *)getGoodsSearchHistorys {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSArray *goodsSearchHistorys = [mmkv getObjectOfClass:[NSArray class] forKey:@"GoodsSearchHistory"];
    if (!goodsSearchHistorys) {
        goodsSearchHistorys = [NSMutableArray array];
    }
    return goodsSearchHistorys;
}

+ (void)removeGoodsSearchHistoryWithSearchText:(NSString *)searchText {
    MMKV *mmkv = [MMKV defaultMMKV];
    if (!searchText) {
        [mmkv removeValueForKey:@"GoodsSearchHistory"];
    } else {
        NSMutableArray *goodsSearchHistorys = [BXSLSearchManager getGoodsSearchHistorys].mutableCopy;
        if ([goodsSearchHistorys containsObject:searchText]) {
            [goodsSearchHistorys removeObject:searchText];
            [mmkv setObject:goodsSearchHistorys forKey:@"GoodsSearchHistory"];
        }
    }
}


@end

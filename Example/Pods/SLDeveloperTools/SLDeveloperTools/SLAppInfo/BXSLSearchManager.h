//
//  BXSLSearchManager.h
//  BXlive
//
//  Created by bxlive on 2019/3/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXSLSearchManager : NSObject

+ (BXSLSearchManager *)shareSearchManager;

+ (void)addSearchHistoryWithSearchText:(NSString *)searchText;
+ (NSArray *)getSearchHistorys;
+ (void)removeSearchHistoryWithSearchText:(NSString *)searchText;  //searchText为nil，移除全部

+ (void)addMusicSearchHistoryWithSearchText:(NSString *)searchText;
+ (NSArray *)getMusicSearchHistorys;
+ (void)removeMusicSearchHistoryWithSearchText:(NSString *)searchText;  //searchText为nil，移除全部

+ (void)addGoodsSearchHistoryWithSearchText:(NSString *)searchText;
+ (NSArray *)getGoodsSearchHistorys;
+ (void)removeGoodsSearchHistoryWithSearchText:(NSString *)searchText;  //searchText为nil，移除全部

@end



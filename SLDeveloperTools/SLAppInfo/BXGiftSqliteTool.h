//
//  BXGiftSqliteTool.h
//  BXlive
//
//  Created by bxlive on 2019/7/23.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGift.h"


@interface BXGiftSqliteTool : NSObject

@property (nonatomic, assign) BOOL isDownloading;

+ (void)insertGift:(BXGift *)gift tableName:(NSString*)tableName;
+ (void)deleteGift:(BXGift *)gift tableName:(NSString*)tableName;
+ (void)queryGiftsWithTableName:(NSString*)tableName block:(void(^)(NSArray <BXGift *>*gifts))block;

+ (void)deleteGiftWithGiftId:(NSString *)giftId tableName:(NSString*)tableName;

@end



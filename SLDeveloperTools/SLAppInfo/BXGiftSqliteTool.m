//
//  BXGiftSqliteTool.m
//  BXlive
//
//  Created by bxlive on 2019/7/23.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXGiftSqliteTool.h"

#import <FMDB.h>

static FMDatabaseQueue *_queue;
@implementation BXGiftSqliteTool

+ (void)initialize {
    [self openSqlite];
}

+ (void)openSqlite {
    if (_queue) {
        return;
    }
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"gift.sqlite"];
    NSLog(@"=============:%@",path);
    _queue = [[FMDatabaseQueue alloc] initWithPath:path];
}

+ (void)closeSqlite {
    if (_queue) {
        [_queue close];
    }
}

+ (void)createTable:(NSString *)tableName {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, giftId text, file text, size text)",tableName];
        [db executeUpdate:sql];
    }];
}

+ (void)insertGift:(BXGift *)gift tableName:(NSString *)tableName {
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (giftId, file, size) values(?, ?, ?)",tableName];
        [db executeUpdate:sql,gift.giftId,gift.file,gift.size];
    }];
    
}

+ (void)deleteGift:(BXGift *)gift tableName:(NSString *)tableName {
    [self deleteGiftWithGiftId:gift.giftId tableName:tableName];
}

+ (void)deleteGiftWithGiftId:(NSString *)giftId tableName:(NSString*)tableName {
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql =  [NSString stringWithFormat:@"delete from %@ where giftId = ?",tableName];
        [db executeUpdate:sql,giftId];
    }];
}

+ (void)queryGiftsWithTableName:(NSString *)tableName block:(void (^)(NSArray<BXGift *> *))block {
    [self createTable:tableName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *gifts = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            BXGift *gift = [[BXGift alloc]init];
            gift.giftId = [resultSet stringForColumn:@"giftId"];
            gift.file = [resultSet stringForColumn:@"file"];
            gift.size = [resultSet stringForColumn:@"size"];
            [gifts addObject:gift];
        }
        [resultSet close];
        block(gifts);
    }];
}
@end

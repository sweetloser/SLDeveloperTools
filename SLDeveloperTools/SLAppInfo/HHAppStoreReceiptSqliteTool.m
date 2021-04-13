//
//  HHAppStoreReceiptSqliteTool.m
//  BXlive
//
//  Created by bxlive on 2018/10/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHAppStoreReceiptSqliteTool.h"
#import <FMDB.h>
#import <SLDeveloperTools/BXLiveUser.h>

static FMDatabaseQueue *_queue;
@implementation HHAppStoreReceiptSqliteTool

+ (void)initialize {
    [self openSqlite];
}

+ (void)openSqlite {
    if (_queue) {
        return;
    }
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"appStoreReceipt.sqlite"];
    NSLog(@"==================:%@",path);
    _queue = [[FMDatabaseQueue alloc] initWithPath:path];
}

+ (void)closeSqlite {
    if (_queue) {
        [_queue close];
    }
}

+ (void)createTable:(NSString *)tableName {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, receipt text, receiptId text)",tableName];
        [db executeUpdate:sql];
    }];
}

+ (void)dropSqlite:(NSString *)tableName {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"drop table if exists %@",tableName];
        [db executeUpdate:sql];
    }];
}

+ (void)insertAppStoreReceipt:(HHAppStoreReceipt *)appStoreReceipt {
    NSString *tableName = [NSString stringWithFormat:@"t_AppStoreReceipt_%@",[BXLiveUser currentBXLiveUser].user_id];
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (receipt, receiptId) values(?, ?)",tableName];
        [db executeUpdate:sql,appStoreReceipt.receipt,appStoreReceipt.receiptId];
    }];
    
}

+ (void)deleteAppStoreReceipt:(HHAppStoreReceipt *)appStoreReceipt {
    NSString *tableName = [NSString stringWithFormat:@"t_AppStoreReceipt_%@",[BXLiveUser currentBXLiveUser].user_id];
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql =  [NSString stringWithFormat:@"delete from %@ where receiptId = ?",tableName];
        [db executeUpdate:sql,appStoreReceipt.receiptId];
    }];
}

+ (void)queryAppStoreReceiptsBlock:(void (^)(NSArray *))block{
    NSString *tableName = [NSString stringWithFormat:@"t_AppStoreReceipt_%@",[BXLiveUser currentBXLiveUser].user_id];
    [self createTable:tableName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *appStoreReceipts = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            HHAppStoreReceipt *appStoreReceipt = [[HHAppStoreReceipt alloc]init];
            appStoreReceipt.receiptId = [resultSet stringForColumn:@"receiptId"];
            appStoreReceipt.receipt = [resultSet stringForColumn:@"receipt"];
            [appStoreReceipts addObject:appStoreReceipt];
        }
        [resultSet close];
        block(appStoreReceipts);
    }];
}
@end

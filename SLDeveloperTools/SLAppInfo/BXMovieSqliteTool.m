//
//  StudentTwoSqliteTool.m
//  数据库
//
//  Created by bxlive on 2018/1/31.
//  Copyright © 2018年 曹化徽. All rights reserved.
//

#import "BXMovieSqliteTool.h"
#import <FMDB/FMDB.h>

static FMDatabaseQueue *_queue;
@implementation BXMovieSqliteTool

+ (void)initialize {
    [self openSqlite];
}

+ (void)openSqlite {
    if (_queue) {
        return;
    }
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"movie.sqlite"];
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
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, uid text, videoPath text, progress real, describe text, sign text,topic text,friend text, coverImage blob,lng text,lat text,location_name text,visible text,music_id text,region_level text, video_url text, cover_url text, video_id text, duration text, film_size text, uploadType text)",tableName];
        
        [db executeUpdate:sql];
    }];
}

+ (void)dropSqlite:(NSString *)tableName {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"drop table if exists %@",tableName];
        [db executeUpdate:sql];
    }];
}

+ (void)insertMovie:(BXHMovieModel *)movie tableName:(NSString *)tableName {
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSData *data = UIImageJPEGRepresentation(movie.coverImage, 1.0);

        NSString *sql = [NSString stringWithFormat:@"insert into %@ (uid, videoPath, progress, describe , sign ,topic ,friend , coverImage ,lng ,lat ,location_name,visible,music_id,region_level, video_url, cover_url, video_id, duration, film_size, uploadType) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",tableName];
        [db executeUpdate:sql,movie.uid,movie.videoPath,@(movie.progress),movie.describe,movie.sign,movie.topic,movie.friendes,data,movie.video_url,movie.cover_url,movie.lng,movie.lat,movie.location_name,movie.visible,movie.music_id,movie.region_level,movie.movieID,movie.duration,movie.film_size,movie.uploadType];
    }];
}

+ (void)deleteMovie:(BXHMovieModel *)movie tableName:(NSString *)tableName {
    [self createTable:tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql =  [NSString stringWithFormat:@"delete from %@ where sign = ?",tableName];
        [db executeUpdate:sql,movie.sign];
    }];
}

+ (void)updateMovie:(BXHMovieModel *)movie tableName:(NSString *)tableName {
    [self createTable:tableName];
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSData *data = UIImageJPEGRepresentation(movie.coverImage, 1.0);
        NSString *sql = [NSString stringWithFormat:@"update %@ set videoPath = ?, progress = ?, describe = ?, coverImage = ?, video_url = ?, cover_url = ?, video_id = ?, duration = ?, film_size = ?, uploadType = ? where sign = ?",tableName];
        [db executeUpdate:sql,movie.videoPath,@(movie.progress),movie.describe,data,movie.video_url,movie.cover_url,movie.movieID,movie.duration,movie.film_size,movie.uploadType,movie.sign];
    }];
}

+ (void)queryMoviesWithTableName:(NSString *)tableName block:(void (^)(NSArray *))block{
    [self createTable:tableName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *movies = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSData *data=[resultSet dataForColumn:@"coverImage"];
            BXHMovieModel *movie = [[BXHMovieModel alloc]init];
            movie.uid = [resultSet stringForColumn:@"uid"];
            movie.videoPath = [resultSet stringForColumn:@"videoPath"];
            movie.progress = [resultSet doubleForColumn:@"progress"];
            movie.describe = [resultSet stringForColumn:@"describe"];
            movie.topic = [resultSet stringForColumn:@"topic"];
            movie.friendes = [resultSet stringForColumn:@"friend"];
            movie.sign = [resultSet stringForColumn:@"sign"];
            movie.video_url = [resultSet stringForColumn:@"video_url"];
            movie.cover_url = [resultSet stringForColumn:@"cover_url"];
            movie.lng = [resultSet stringForColumn:@"lng"];
            movie.lat = [resultSet stringForColumn:@"lat"];
            movie.location_name =[resultSet stringForColumn:@"location_name"];
            movie.visible =[resultSet stringForColumn:@"lat"];
            movie.music_id =[resultSet stringForColumn:@"music_id"];
            movie.region_level =[resultSet stringForColumn:@"region_level"];
            movie.movieID = [resultSet stringForColumn:@"video_id"];
            movie.duration = [resultSet stringForColumn:@"duration"];
            movie.film_size = [resultSet stringForColumn:@"film_size"];
            movie.uploadType = [resultSet stringForColumn:@"uploadType"];
            movie.coverImage = [UIImage imageWithData:data];
            [movies addObject:movie];
        }
        [resultSet close];
        block(movies);
    }];
}
@end

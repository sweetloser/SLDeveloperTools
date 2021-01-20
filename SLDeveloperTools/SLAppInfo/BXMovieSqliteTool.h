//
//  StudentTwoSqliteTool.h
//  数据库
//
//  Created by bxlive on 2018/1/31.
//  Copyright © 2018年 曹化徽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXHMovieModel.h"

@interface BXMovieSqliteTool : NSObject
+ (void)dropSqlite:(NSString *)tableName;
+ (void)insertMovie:(BXHMovieModel *)movie tableName:(NSString*)tableName;
+ (void)deleteMovie:(BXHMovieModel *)movie tableName:(NSString*)tableName;
+ (void)updateMovie:(BXHMovieModel *)movie tableName:(NSString*)tableName;
+ (void)queryMoviesWithTableName:(NSString*)tableName block:(void(^)(NSArray *movies))block;
@end

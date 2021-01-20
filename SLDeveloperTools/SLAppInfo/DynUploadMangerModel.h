//
//  DynUploadMangerModel.h
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXHMovieModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DynUploadMangerModel : NSObject
+ (DynUploadMangerModel *)sharedUploadMovieManager;
+ (NSString *)getTableName;
+ (void)dropUploadSqlite;

- (void)uploadMovie:(BXHMovieModel *)movie;
- (void)removeMovie:(BXHMovieModel *)movie;
@end

NS_ASSUME_NONNULL_END

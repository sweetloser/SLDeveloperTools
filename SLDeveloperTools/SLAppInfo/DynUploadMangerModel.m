//
//  DynUploadMangerModel.m
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DynUploadMangerModel.h"
#import "BXUploadMovieTool.h"
#import "BXMovieSqliteTool.h"
#import "NewHttpRequestPort.h"
#import "FilePathHelper.h"
#import "BXLiveUser.h"
#import "NewHttpManager.h"
#import "SLAppInfoConst.h"
#import "SLAppInfoConst.h"

@interface DynUploadMangerModel () <BXUploadMovieToolDelegate>
@property (strong, nonatomic) NSMutableArray *totalMovies;
@property (strong, nonatomic) NSMutableArray *uploadingTools;

@property (assign, nonatomic) NSInteger maxCount;
@end

@implementation DynUploadMangerModel
+ (DynUploadMangerModel *)sharedUploadMovieManager {
    static DynUploadMangerModel *_uploadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadManager = [[DynUploadMangerModel alloc]init];
    });
    return _uploadManager;
}

+ (NSString *)getTableName {
    return [NSString stringWithFormat:@"t_upload_%@",[BXLiveUser currentBXLiveUser].user_id];
}

+ (void)dropUploadSqlite {
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"movie.sqlite"];
    
    if ([FilePathHelper fileIsExistsAtPath:path]) {
        [FilePathHelper removeFileAtPath:path];
    }
}

- (instancetype)init {
    if ([super init]) {
        _totalMovies = [NSMutableArray array];
        _uploadingTools = [NSMutableArray array];
        _maxCount = 3;
    }
    return self;
}

- (void)uploadMovie:(BXHMovieModel *)movie {
    BXHMovieModel *otherMovie = [self getMovieWithMovie:movie];
    if (!otherMovie) {
        [_totalMovies insertObject:movie atIndex:0];
        otherMovie = movie;
    }
    
    switch ([otherMovie.uploadType integerValue]) {
        case 0:
            if (_uploadingTools.count < _maxCount) {
                [self startUploadMovie:otherMovie];
            }
            break;
            
        case 1://正在上传 不做处理
        {
            if (![self getUploadMovieToolWithMovie:otherMovie]) {
                otherMovie.uploadType = @"0";
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [BXMovieSqliteTool updateMovie:otherMovie tableName:[BXUploadMovieManager getTableName]];
                });
                if (_uploadingTools.count < _maxCount) {
                    [self startUploadMovie:otherMovie];
                }
            }
        }
            break;
            
        case 2:
            if (_uploadingTools.count < _maxCount) {
                [self startUploadMovie:otherMovie];
            }
            break;
            
        case 3:
            [self didUploadMovie:otherMovie];
            break;
            
        default://上传成功 不做处理
            
            break;
    }
}


- (void)startUploadMovie:(BXHMovieModel *)movie {
    movie.uploadType = @"1";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
    });
    
    BXUploadMovieTool *uploadMovieTool = [[BXUploadMovieTool alloc]init];
    uploadMovieTool.delegate = self;
    [uploadMovieTool uploadMovie:movie];
    [_uploadingTools addObject:uploadMovieTool];
}

- (void)removeMovie:(BXHMovieModel *)movie {
    BXHMovieModel *theMovie = [self getMovieWithMovie:movie];
    if (theMovie) {
        [_totalMovies removeObject:theMovie];
    }
    
    BXUploadMovieTool *uploadMovieTool = [self getUploadMovieToolWithMovie:movie];
    if (uploadMovieTool) {
        [uploadMovieTool cancelUploadMovie];
        [_uploadingTools removeObject:uploadMovieTool];
    }

//    [BXMovieSqliteTool deleteMovie:movie tableName:[BXUploadMovieManager getTableName]];
}

- (void)didUploadMovie:(BXHMovieModel *)movie {
    [NewHttpManager publishFilmWithLng:movie.lng lat:movie.lat uid:movie.uid goods_id:movie.goods_id locationName:movie.location_name musicId:movie.music_id regionLevel:movie.region_level visible:movie.visible  describe:movie.describe videoId:movie.movieID videoUrl:movie.video_url coverUrl:movie.cover_url topic:movie.topic friends:movie.friendes duration:movie.duration filmSize:movie.film_size success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
//            [BXMovieSqliteTool deleteMovie:movie tableName:[BXUploadMovieManager getTableName]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUploadMovieSuccessNotification object:nil userInfo:@{@"sign":movie.sign}];
        } else {
            movie.uploadType = @"3";
//            [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUploadServerFailNotification object:nil userInfo:@{@"sign":movie.sign}];
        }
    } failure:^(NSError *error) {
        movie.uploadType = @"3";
//        [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUploadServerFailNotification object:nil userInfo:@{@"sign":movie.sign}];
    }];
}

- (BXHMovieModel *)getMovieWithMovie:(BXHMovieModel *)movie {
    BXHMovieModel *theMovie = nil;
    for (BXHMovieModel *otherMovie in _totalMovies) {
        if ([otherMovie.sign isEqualToString:movie.sign]) {
            theMovie = otherMovie;
        }
    }
    return theMovie;
}

- (BXUploadMovieTool *)getUploadMovieToolWithMovie:(BXHMovieModel *)movie {
    BXUploadMovieTool *theUploadMovieTool = nil;
    for (BXUploadMovieTool *uploadMovieTool in _uploadingTools) {
        if ([movie.sign isEqualToString:uploadMovieTool.movie.sign]) {
            theUploadMovieTool = uploadMovieTool;
            break;
        }
    }
    return theUploadMovieTool;
}

#pragma - mark BXUploadMovieToolDelegate
- (void)uploadMovieProgress:(CGFloat)progress movie:(BXHMovieModel *)movie {
    movie.progress = progress;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadProgressChange" object:nil userInfo:@{@"sign":movie.sign,@"progress":@(movie.progress)}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
    });
}
- (void)uploadMovieComplete:(TXPublishResult *)result movie:(BXHMovieModel *)movie {
    BXUploadMovieTool *theTool = nil;
    for (BXUploadMovieTool *uploadMovieTool in _uploadingTools) {
        if ([uploadMovieTool.movie.sign isEqualToString:movie.sign]) {
            theTool = uploadMovieTool;
            break;
        }
    }
    if (theTool) {
        [_uploadingTools removeObject:theTool];
    }
    
    if (!result.retCode) {
        movie.progress = 1.0;
        movie.video_url = result.videoURL;
        movie.cover_url = result.coverURL;
        movie.movieID = result.videoId;
//        [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
        
        BXHMovieModel *theMovie = [self getMovieWithMovie:movie];
        if (theMovie) {
            [_totalMovies removeObject:theMovie];
        }
        if (_totalMovies.count) {
            [self startUploadMovie:_totalMovies[0]];
        }
        
        [self didUploadMovie:movie];
    } else {
        movie.uploadType = @"2";
//        [BXMovieSqliteTool updateMovie:movie tableName:[BXUploadMovieManager getTableName]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUploadTencentCloudFailNotification object:nil userInfo:@{@"sign":movie.sign}];
    }
}

@end

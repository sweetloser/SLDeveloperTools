//
//  BXReportVideoManager.m
//  BXlive
//
//  Created by bxlive on 2019/4/23.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXReportVideoManager.h"
#import "JsonHelper.h"
#import "NewHttpManager.h"
@interface BXReportVideoManager ()

@property (nonatomic, strong) NSMutableArray *jsonStrs;

@property (nonatomic, strong) NSMutableDictionary *historyDic;

@end

@implementation BXReportVideoManager

+ (BXReportVideoManager *)shareReportVideoManager {
    static dispatch_once_t onceToken;
    static BXReportVideoManager *_reportVideoManager = nil;
    dispatch_once(&onceToken, ^{
        _reportVideoManager = [[BXReportVideoManager alloc]init];
    });
    return _reportVideoManager;
}

+ (void)addWatchHistoryWithVideoId:(NSString *)videoId startTime:(NSString *)startTime duration:(NSString *)duration {
    BXReportVideoManager *reportVideoManager = [BXReportVideoManager shareReportVideoManager];
    NSMutableDictionary *dic = [reportVideoManager.historyDic[videoId] mutableCopy];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        dic[@"sum_duration"] = duration;
        dic[@"max_duration"] = duration;
    } else {
        NSInteger oldSumDuration = [dic[@"sum_duration"] integerValue];
        oldSumDuration += [duration integerValue];
        dic[@"sum_duration"] = [NSString stringWithFormat:@"%ld",oldSumDuration];
        
        NSInteger oldMaxDuration = [dic[@"max_duration"] integerValue];
        oldMaxDuration = MAX([duration integerValue], oldMaxDuration);
        dic[@"max_duration"] = [NSString stringWithFormat:@"%ld",oldMaxDuration];
    }
    dic[@"video_id"] = videoId;
    dic[@"start_time"] = startTime;
    reportVideoManager.historyDic[videoId] = dic;

    if (reportVideoManager.historyDic.count >= 5) {

        NSMutableArray *historyArr = [NSMutableArray array];
        [reportVideoManager.historyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [historyArr addObject:obj];
        }];
        [reportVideoManager.historyDic removeAllObjects];
        NSString *jsonStr = [JsonHelper jsonStringWithObject:historyArr];
        [reportVideoManager.jsonStrs addObject:jsonStr];
    }
    [self reportHistory:reportVideoManager.jsonStrs];
}

+ (void)reportHistory:(NSMutableArray *)jsonStrs {
    for (NSString *jsonStr in jsonStrs) {
        [NewHttpManager behaviorWatchWithData:jsonStr success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            if (flag) {
                if ([jsonStrs containsObject:jsonStr]) {
                    [jsonStrs removeObject:jsonStr];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (instancetype)init {
    if ([super init]) {
        _historyDic = [NSMutableDictionary dictionary];
        _jsonStrs = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willTerminate {
    if (_historyDic.count) {
        NSMutableArray *historyArr = [NSMutableArray array];
        [_historyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [historyArr addObject:obj];
        }];
        [_historyDic removeAllObjects];
        NSString *jsonStr = [JsonHelper jsonStringWithObject:historyArr];
        [_jsonStrs addObject:jsonStr];
    }
    [BXReportVideoManager reportHistory:_jsonStrs];
}

@end

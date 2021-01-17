//
//  SLMoviePlayVCCoonfig.m
//  BXlive
//
//  Created by sweetloser on 2020/8/12.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLMoviePlayVCCoonfig.h"
#import "BXSLLiveRoom.h"
#import "../SLMacro/SLMacro.h"
#import "NewHttpManager.h"
#import "../SLCategory/SLCategory.h"

@interface SLMoviePlayVCCoonfig()

@property(nonatomic,assign)BOOL isLoading;

@end

@implementation SLMoviePlayVCCoonfig

+(SLMoviePlayVCCoonfig *)shareMovePlayConfig;{
    static dispatch_once_t onceToken;
    static SLMoviePlayVCCoonfig *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[SLMoviePlayVCCoonfig alloc] init];
    });
    
    return config;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.liveRooms = [NSMutableArray new];
    }
    return self;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
}


-(void)getMoreLive:(void(^)(void))complateBlock;{
    
    if (_isLoading) {
        return;
    }
    if (_hasMore == NO) {
        return;
    }
    _isLoading = YES;
    WS(weakSelf);
    NSMutableDictionary *m = nil;
    if (self.additionalParams) {
        m = [self.additionalParams mutableCopy];
    }else{
        m = [NSMutableDictionary new];
    }
    [m setObject:[NSString stringWithFormat:@"%ld",(long)_liveRooms.count] forKey:@"offset"];
    
    [[NewHttpManager sharedNetManager] POST:self.loadUrl parameters:m success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if ([code integerValue] == 0) {
//            成功获到数据
            NSArray *data = responseObject[@"data"];
            if (data && [data isArray] && data.count > 0) {
                
                for (NSDictionary *roomDic in data) {
                    BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                    [liveRoom updateWithJsonDic:roomDic];
                    [weakSelf.liveRooms addObject:liveRoom];
                }
                if (complateBlock) {
                    complateBlock();
                }
                
                weakSelf.hasMore = YES;
            }else{
                //没有更多了。
                weakSelf.hasMore = NO;
            }
            weakSelf.isLoading = NO;
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.isLoading = NO;
    }];
}

@end

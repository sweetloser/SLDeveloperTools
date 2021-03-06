//
//  BXHMovieModel.m
//  BXlive
//
//  Created by huang on 2017/12/21.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXHMovieModel.h"
#import "BXTopicModel.h"
#import "FilePathHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "BXLiveUser.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"

//#import "BXPersonHomeVC.h"
@interface BXHMovieModel ()

@property (nonatomic, copy) NSString *webp_url;

@end

@implementation BXHMovieModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"movieID":@"id"};
}

- (instancetype)init {
    if ([super init]) {
        _friends = [NSMutableArray array];
        _topics = [NSMutableArray array];
        _rewardUsers = [NSMutableArray array];
        _commentlist = [NSMutableArray array];
    }
    return self;
}

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _movieID = jsonDic[@"id"];
    
    _location = [[BXLocation alloc]init];
    NSDictionary *locationDic = jsonDic[@"location"];
    if (locationDic && locationDic.count) {
        [_location updateWithJsonDic:locationDic];
    }
    
    NSArray *friends = jsonDic[@"friend_group"];
    if (friends && [friends isArray] && friends.count) {
        for (NSDictionary *dic in friends) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            liveUser.user_id = dic[@"user_id"];
            liveUser.nickname = dic[@"nickname"];
            [_friends addObject:liveUser];
        }
    }
    
    NSArray *topics = jsonDic[@"topic_group"];
    if (topics && [topics isArray] && topics.count) {
        for (NSDictionary *dic in topics) {
            BXTopicModel *topic = [[BXTopicModel alloc]init];
            [topic updateWithJsonDic:dic];
            [_topics addObject:topic];
        }
    }
    
    NSDictionary *videoActDic = jsonDic[@"video_act"];
    if (videoActDic && videoActDic.count) {
        _activity = [[BXActivity alloc]init];
        _activity.video_id = _movieID;
        _activity.position = videoActDic[@"position"];
        _activity.slider_url = videoActDic[@"slider_url"];
    }
    
    NSDictionary *musicDic = jsonDic[@"music"];
    if (musicDic && [musicDic isDictionary]) {
        _bgMusic = [[BXMusicModel alloc]init];
        _bgMusic.music_id = musicDic[@"music_id"];
        _bgMusic.singer = musicDic[@"singer"];
        _bgMusic.title = musicDic[@"title"];
        _bgMusic.image = musicDic[@"image"];
        
        _music_id = _bgMusic.music_id;
    }
    
    NSArray *reward_rankArray = jsonDic[@"reward_rank"];
    if (reward_rankArray && [reward_rankArray isArray]) {
        for (NSDictionary *dic in reward_rankArray) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            liveUser.user_id = dic[@"user_id"];
            liveUser.avatar = dic[@"avatar"];
            if (_rewardUsers.count < 3) {
                [_rewardUsers addObject:liveUser];
            }
        }
    }
    
    //评论
    NSArray *comment_lists = jsonDic[@"comment_list"];
    if (comment_lists && [comment_lists isArray]) {
        WS(ws);
        for (NSDictionary *dic in comment_lists) {
            BXCommentModel *model = [[BXCommentModel alloc] initWithDict:dic];
            [model processAttributedStringWithAttaties];
            model.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws toPersonHomeWithUserId:userId];
            };
        
            [_commentlist addObject:model];
        }
    }
    
    
    
}

- (NSInteger)getScalingModeWithScreenHeight:(CGFloat)screenHeight {
    if (screenHeight < 0) {
        screenHeight = __kHeight;
    }
    
    NSInteger scalingMode = 1;
    CGFloat width = [_width floatValue];
    CGFloat height = [_height floatValue];
    if (width > 0 && height > 0) {
        CGFloat rate = height / width;
        CGFloat screenRate = screenHeight / __kWidth;
        if (screenRate * .8 <= rate) {
            scalingMode = 2;
        }
    }
    return scalingMode;
}

- (CGFloat)getRate {
    CGFloat width = [self.width floatValue];
    CGFloat height = [self.height floatValue];
    if (!width) {
        return 1.0;
    }
    return height / width;
}

-(void)toPersonHomeWithUserId:(NSString *)userId{
    
//    [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:[[UIApplication sharedApplication] activityViewController].navigationController handle:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
}

@end

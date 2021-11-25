//
//  BXliveDescribeResponder.m
//  BXlive
//
//  Created by bxlive on 2019/3/4.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoDescribeResponder.h"
#import "HMovieModel+DescribeAttri.h"
//#import "BXTopicDetailVC.h"
#import "UIApplication+ActivityViewController.h"
//#import "BXPersonHomeVC.h"
//#import "BXRecordMusicVC.h"
#import "SLAmwayListModel+ContentAttri.h"
#import "SLAmwayTopicModel.h"
#import "SLAmwayDetailModel+ContentAttri.h"
#import "TMSeedingTopicHomeVC.h"
#import <YYText/YYText.h>



@implementation BXVideoDescribeResponder

+ (BXVideoDescribeResponder *)shareVideoDescribeResponder {
    static dispatch_once_t onceToken;
    static BXVideoDescribeResponder * _videoDescribeResponder = nil;
    dispatch_once(&onceToken, ^{
        _videoDescribeResponder = [[BXVideoDescribeResponder alloc]init];
    });
    return _videoDescribeResponder;
}
#pragma mark - 种草详情
+ (void)processAmwayDetailContentAttri:(SLAmwayDetailModel *)video;{
    BXVideoDescribeResponder *videoDescribeResponder = [BXVideoDescribeResponder shareVideoDescribeResponder];
    [videoDescribeResponder beiginProcessAmwayDetailContentAttri:video];
}
- (void)beiginProcessAmwayDetailContentAttri:(SLAmwayDetailModel *)video {
    if (!video.contentAttri && !IsNilString(video.content)) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.content];
        attri.yy_font = CFont(15);
        attri.yy_color = sl_textColors;
        attri.yy_lineSpacing = 3;
        
        WS(ws);
        for (SLAmwayTopicModel *topic in video.title) {
            NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.topic_name];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.content subText:topicTitle];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], topicTitle.length);
                [attri yy_setFont:SLBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:[UIColor sl_colorWithHex:0x91B8F4] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws amwayDetailTopicDetail:[NSString stringWithFormat:@"%@",topic.topic_id] video:video];
                }];
            }
        }
        
        for (BXLiveUser *liveUser in video.privatemsg) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.content subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                [attri yy_setFont:SLBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:[UIColor sl_colorWithHex:0x91B8F4] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        video.contentAttri = attri;
        video.contentHeight = [self getAttributedTextHeightWithAttributedText:attri width:__kWidth - __ScaleWidth(30)];
    }
}

#pragma mark - 视频详情
+ (void)processAmwayVideoContentAttri:(SLAmwayListModel *)video;{
    BXVideoDescribeResponder *videoDescribeResponder = [BXVideoDescribeResponder shareVideoDescribeResponder];
    [videoDescribeResponder beiginProcessAmwayVideoContentAttri:video];
}
- (void)beiginProcessAmwayVideoContentAttri:(SLAmwayListModel *)video {
    if (!video.contentAttri && !IsNilString(video.content)) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.content];
        attri.yy_font = CFont(15);
        attri.yy_color = CHHCOLOR_D(0xE9E9F2);
        attri.yy_lineSpacing = 3;
        
        WS(ws);
        for (SLAmwayTopicModel *topic in video.title) {
            NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.topic_name];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.content subText:topicTitle];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], topicTitle.length);
                [attri yy_setFont:CBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:TextBrightestColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws amwayTopicDetail:[NSString stringWithFormat:@"%@",topic.topic_id] video:video];
                }];
            }
        }
        
        for (BXLiveUser *liveUser in video.privatemsg) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.content subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                [attri yy_setFont:SLBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:sl_whiteTextColors backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        video.contentAttri = attri;
        video.contentHeight = [self getAttributedTextHeightWithAttributedText:attri width:__kWidth - 16 - 75];
    }
}


#pragma mark - 短视频
+ (void)processVideoDescribeAttri:(BXHMovieModel *)video {
    BXVideoDescribeResponder *videoDescribeResponder = [BXVideoDescribeResponder shareVideoDescribeResponder];
    [videoDescribeResponder beiginProcessVideoDescribeAttri:video];
}

- (void)beiginProcessVideoDescribeAttri:(BXHMovieModel *)video {
    if (!video.describeAttri && !IsNilString(video.describe)) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.describe];
        attri.yy_font = CFont(15);
        attri.yy_color = CHHCOLOR_D(0xE9E9F2);
        attri.yy_lineSpacing = 3;
        
        WS(ws);
        for (BXTopicModel *topic in video.topics) {
            NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.title];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.describe subText:topicTitle];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], topicTitle.length);
                [attri yy_setFont:CBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:TextBrightestColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws topicDetail:topic.topic_id video:video];
                }];
            }
        }
        
        for (BXLiveUser *liveUser in video.friends) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.describe subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                [attri yy_setFont:CBFont(15) range:range];
                [attri yy_setTextHighlightRange:range color:TextBrightestColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        video.describeAttri = attri;
        video.describeHeight = [self getAttributedTextHeightWithAttributedText:attri width:__kWidth - 16 - 75];
    }
    
}
//if (_video.bgMusic && _video.bgMusic.music_id) {
//    BXRecordMusicVC *vc = [[BXRecordMusicVC alloc] init];
//    vc.musicId = _video.bgMusic.music_id;
//    [self pushWithVC:vc];
//}
- (void)topicDetail:(NSString *)topicId video:(BXHMovieModel *)video{
    if ([BXLiveUser isLogin]) {
//        BXTopicDetailVC *vc = [[BXTopicDetailVC alloc]init];
//        vc.topicId = topicId;
        if (video.bgMusic && video.bgMusic.music_id) {
//            BXRecordMusicVC *vc = [[BXRecordMusicVC alloc] init];
//            vc.musicId = video.bgMusic.music_id;
//            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:vc animated:YES];
        }
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":[UIApplication sharedApplication].activityViewController.navigationController}];
        
    }
}

- (void)amwayTopicDetail:(NSString *)topicId video:(SLAmwayListModel *)video{
    if ([BXLiveUser isLogin]) {
        TMSeedingTopicHomeVC *vc = [[TMSeedingTopicHomeVC alloc]init];
        vc.topic_id = topicId;
//        if (video.bgMusic && video.bgMusic.music_id) {
//            BXRecordMusicVC *vc = [[BXRecordMusicVC alloc] init];
//            vc.musicId = video.bgMusic.music_id;
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:vc animated:YES];
//        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":[UIApplication sharedApplication].activityViewController.navigationController}];
    }
}

- (void)amwayDetailTopicDetail:(NSString *)topicId video:(SLAmwayDetailModel *)video{
    if ([BXLiveUser isLogin]) {
        TMSeedingTopicHomeVC *vc = [[TMSeedingTopicHomeVC alloc]init];
        vc.topic_id = topicId;
//        if (video.bgMusic && video.bgMusic.music_id) {
//            BXRecordMusicVC *vc = [[BXRecordMusicVC alloc] init];
//            vc.musicId = video.bgMusic.music_id;
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:vc animated:YES];
//        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":[UIApplication sharedApplication].activityViewController.navigationController}];
    }
}

- (void)userDetail:(NSString *)userId {
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
}

#pragma - mark tool
- (NSMutableArray *)getRangeLocationsWithText:(NSString *)text subText:(NSString *)subText {
    NSMutableArray *rangeLocations=[NSMutableArray new];
    NSArray *array=[text componentsSeparatedByString:subText];
    NSInteger d = 0;
    for (NSInteger i = 0; i<array.count-1; i++) {
        NSString *string = array[i];
        NSNumber *number = @(d += string.length);
        d += subText.length;
        [rangeLocations addObject:number];
    }
    return rangeLocations;
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 3;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}

@end

//
//  ShareObject.m
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "ShareObject.h"

@interface ShareObject ()

@property (copy, nonatomic) NSString *likeNum;
@property (copy, nonatomic) NSString *is_zan;
@property (copy, nonatomic) NSString *is_collect;
@property (copy, nonatomic) NSString *is_follow;
@end

@implementation ShareObject

- (void)setType:(ShareObjectType)type {
    _type = type;
    switch (type) {
#ifdef ChongYouURL
        case ShareObjectTypeOfFacebook:
            _name = @"Facebook";
            _iconName = @"icon_share_facebook";
            break;
#endif
        case ShareObjectTypeOfQQ:
            _name = @"QQ";
            _iconName = @"视频qq";
            break;
            
        case ShareObjectTypeOfQzone:
            _name = @"QQ空间";
            _iconName = @"视频qq空间";
            break;
            
        case ShareObjectTypeOfWechatSession:
            _name = @"微信";
            _iconName = @"视频微信";
            break;
            
        default:
            _name = @"朋友圈";
            _iconName = @"视频朋友圈";
            break;
    }
}

- (void)setNormalType:(ShareObjectType)normalType{
    _normalType = normalType;
    switch (normalType) {
#ifdef ChongYouURL
        case ShareObjectTypeOfFacebook:
            _name = @"Facebook";
            _iconName = @"icon_share_facebook";
            break;
#endif
        case ShareObjectTypeOfQQ:
            _name = @"QQ";
            _iconName = @"video_pop up_icon_qq";
            break;
        case ShareObjectTypeOfQzone:
            _name = @"QQ空间";
            _iconName = @"video_pop up_icon_qqkongjian";
            break;
        case ShareObjectTypeOfWechatSession:
            _name = @"微信好友";
            _iconName = @"video_pop up_icon_weixin";
            break;
        case ShareObjectTypeOfWechatTimeLine:
            _name = @"朋友圈";
            _iconName = @"video_pop up_icon_penyouquan";
            break;
        case ShareObjectTypeOfLike:
            if ([_is_zan integerValue]) {
                _name = [NSString stringWithFormat:@"%@赞",_likeNum];
                _iconName = @"video_pop up_icon_zan_selected";
            }else{
                _name = @"赞";
                _iconName = @"video_pop up_icon_zan_default";
            }
            break;
        case ShareObjectTypeOfCollection:
            if ([_is_collect integerValue]) {
                _name = @"已收藏";
                _iconName = @"video_pop up_icon_shoucang_selected";
            }else{
                _name = @"收藏";
                _iconName = @"video_pop up_icon_shoucang_default";
            }
           
            break;
        case ShareObjectTypeOfFollow:
            if ([_is_follow integerValue]) {
                _name = @"已关注";
                _iconName = @"video_pop up_icon_guanzhu_selected";
            }else{
                _name = @"关注";
                _iconName = @"video_pop up_icon_guanzhu";
            }
            break;
        case ShareObjectTypeOfDownload:
            _name = @"下载本地";
            _iconName = @"video_pop up_icon_huancun";
            break;
        case ShareObjectTypeOfUnLike:
            _name = @"不感兴趣";
            _iconName = @"icon_dislike";
            break;
        case ShareObjectTypeOfReport:
            _name = @"举报";
            _iconName = @"video_pop up_icon_jubao";
            break;
        case ShareObjectTypeOfDelete:
            _name = @"删除";
            _iconName = @"video_pop up_icon_delete";
            break;
        default:
            
            break;
    }
}

+(instancetype)sharelikeNum:(NSString *)likeNum  is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow type:(NSInteger)type{
    ShareObject *share = [[ShareObject alloc] init];
    share.is_follow = is_follow;
    share.is_collect = is_collect;
    share.is_zan = is_zan;
    share.likeNum = likeNum;
    share.normalType = type;
    return share;
}


@end

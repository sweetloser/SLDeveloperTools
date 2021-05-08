//
//  ShareObject.m
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "DynShareObject.h"

@interface DynShareObject ()

@property (copy, nonatomic) NSString *likeNum;
@property (copy, nonatomic) NSString *is_zan;
@property (copy, nonatomic) NSString *is_collect;
@property (copy, nonatomic) NSString *is_follow;
@end

@implementation DynShareObject

- (void)setType:(DynShareObjectType)type {
    _type = type;
    switch (type) {
#ifdef ChongYouURL
        case DynShareObjectTypeOfFacebook:
            _name = @"Facebook";
            _iconName = @"icon_share_facebook";
            break;
#endif
        case DynShareObjectTypeOfQQ:
            _name = @"QQ";
            _iconName = @"视频qq";
            break;
            
        case DynShareObjectTypeOfQzone:
            _name = @"QQ空间";
            _iconName = @"视频qq空间";
            break;
            
        case DynShareObjectTypeOfWechatSession:
            _name = @"微信好友";
            _iconName = @"视频微信";
            break;
            
        default:
            _name = @"朋友圈";
            _iconName = @"视频朋友圈";
            break;
    }
}

- (void)setNormalType:(DynShareObjectType)normalType{
    _normalType = normalType;
    switch (normalType) {
#ifdef ChongYouURL
        case DynShareObjectTypeOfFacebook:
            _name = @"Facebook";
            _iconName = @"icon_share_facebook";
            break;
#endif
        case DynShareObjectTypeOfQQ:
            _name = @"QQ";
            _iconName = @"video_pop up_icon_qq";
            break;
        case DynShareObjectTypeOfQzone:
            _name = @"QQ空间";
            _iconName = @"video_pop up_icon_qqkongjian";
            break;
        case DynShareObjectTypeOfWechatSession:
            _name = @"微信好友";
            _iconName = @"video_pop up_icon_weixin";
            break;
        case DynShareObjectTypeOfWechatTimeLine:
            _name = @"朋友圈";
            _iconName = @"video_pop up_icon_penyouquan";
            break;
        case DynShareObjectTypeOfLike:
            if ([_is_zan integerValue]) {
                _name = [NSString stringWithFormat:@"%@赞",_likeNum];
                _iconName = @"video_pop up_icon_zan_selected";
            }else{
                _name = @"赞";
                _iconName = @"video_pop up_icon_zan_default";
            }
            break;
        case DynShareObjectTypeOfCollection:
            if ([_is_collect integerValue]) {
                _name = @"已收藏";
                _iconName = @"video_pop up_icon_shoucang_selected";
            }else{
                _name = @"收藏";
                _iconName = @"video_pop up_icon_shoucang_default";
            }
           
            break;
        case DynShareObjectTypeOfFollow:
            if ([_is_follow integerValue]) {
                _name = @"已关注";
                _iconName = @"video_pop up_icon_guanzhu_selected";
            }else{
                _name = @"关注";
                _iconName = @"video_pop up_icon_guanzhu";
            }
            break;
        case DynShareObjectTypeOfDownload:
            _name = @"下载本地";
            _iconName = @"video_pop up_icon_huancun";
            break;
        case DynShareObjectTypeOfUnLike:
            _name = @"不感兴趣";
            _iconName = @"icon_dislike";
            break;
        case DynShareObjectTypeOfReport:
            _name = @"举报";
            _iconName = @"video_pop up_icon_jubao";
            break;
        case DynShareObjectTypeOfDelete:
            _name = @"删除";
            _iconName = @"video_pop up_icon_delete";
            break;
        default:
            
            break;
    }
}

+(instancetype)sharelikeNum:(NSString *)likeNum  is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow type:(NSInteger)type{
    DynShareObject *share = [[DynShareObject alloc] init];
    share.is_follow = is_follow;
    share.is_collect = is_collect;
    share.is_zan = is_zan;
    share.likeNum = likeNum;
    share.normalType = type;
    return share;
}


@end

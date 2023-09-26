//
//  BXDynMsgDetailModel.h
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"
#import "BXDynCircleModel.h"
#import "BXDynTopicModel.h"
#import "BXdynSystemplusModel.h"
#import "BXHMovieModel.h"
#import "BXLiveUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynMsgDetailModel : BaseObject
@property (copy, nonatomic) NSString *dynID;            //动态id
@property (copy, nonatomic) NSString *uid;           //uid
@property (copy, nonatomic) NSString *fcmid;          //消息id
@property (copy, nonatomic) NSString *is_own;          //是否是自己发的
@property (copy, nonatomic) NSString *create_time;        //建立时间
@property (copy, nonatomic) NSString *issueType;           //发布类型 2:话题 3:圈子 6:表白
@property (copy, nonatomic) NSString *msg_type;           //消息类型（谁可以看）1:所有人 2:好友 3:陌生人 4:私密
@property (copy, nonatomic) NSString *is_recommend;         //是否推荐  1是 0否
@property (copy, nonatomic) NSString *status;             //状态 0 1
@property (copy, nonatomic) NSString *difftime;            //距离现在时间
@property (copy, nonatomic) NSString *extend_type;            //扩展分类 1综合 2视频
@property (copy, nonatomic) NSString *cmment_num;            //评论数
@property (copy, nonatomic) NSString *extend_talk;            //备用
@property (copy, nonatomic) NSString *extend_cirlce;            //圈子id
@property (copy, nonatomic) NSString *address;            //地址
@property (copy, nonatomic) NSString *location;            //经纬度
@property (copy, nonatomic) NSString *lat;            //纬度
@property (copy, nonatomic) NSString *lng;            //经度
@property (copy, nonatomic) NSString *systemtype;            //系统信息类型 0:非系统发 1更换头像 2分享商品 3开播公共
@property (strong, nonatomic) NSMutableArray *picture;            //图片
@property (strong, nonatomic) NSMutableArray *smallpicture;            //缩略图片
@property (strong, nonatomic) NSMutableArray *imgs_detail;            //图片信息
@property (strong, nonatomic) NSMutableArray *picture_long;            //图片长度

@property (copy, nonatomic) NSString *privateid;            //好友id

@property (copy, nonatomic) NSString *comment_status;            //是否可用评论
@property (copy, nonatomic) NSString *comment_num;            //评论数
@property (copy, nonatomic) NSString *like_num;            //喜欢数
@property (copy, nonatomic) NSString *cover_url;            //封面
@property (copy, nonatomic) NSString *smallcover_url;

@property (copy, nonatomic) BXdynSystemplusModel *sysModel;
@property (strong, nonatomic) NSMutableDictionary *systemplus;            //
@property (strong, nonatomic) NSMutableArray *systemplusArray;            //
@property (copy, nonatomic) NSString *goods_id;            //商品id
@property (copy, nonatomic) NSString *goods_name;            //商品名称
@property (copy, nonatomic) NSString *mansong_name;            //
@property (copy, nonatomic) NSString *coupon;            //
@property (copy, nonatomic) NSString *sales;            //卖的数量
@property (copy, nonatomic) NSString *pic_cover;            //封面
@property (copy, nonatomic) NSString *commissin;            //
@property (copy, nonatomic) NSString *price;            //价格
@property (copy, nonatomic) NSString *promotion_price;            //价格
@property (copy, nonatomic) NSString *comfrom;            //

@property (copy, nonatomic) NSString *dynamic_title;            //标题
@property (copy, nonatomic) NSString *extend_already_live;            //用户是否对此动态点赞 0:没有 1:有
@property (copy, nonatomic) NSString *voice;            //声音
@property (copy, nonatomic) NSString *video;            //视频
@property (copy, nonatomic) NSString *content;            //内容

@property (copy, nonatomic) NSString *extend_circle;
@property (strong, nonatomic) NSMutableArray *extend_circledetail;            //圈子详情
@property (strong, nonatomic) NSMutableArray *extend_circledetailArray;            //圈子详情
@property (copy, nonatomic) NSString *circle_id;            //圈子id
@property (copy, nonatomic) NSString *circle_name;            //圈子名称
@property (copy, nonatomic) NSString *circle_describe;            //圈子描述
@property (copy, nonatomic) NSString *circle_cover_img;            //圈子封面
@property (copy, nonatomic) NSString *circle_background_img;            //圈子背景
@property (copy, nonatomic) NSString *render_type;            //渲染ID（页面布局判断）

@property (copy, nonatomic) NSString *sing_title;
@property (copy, nonatomic) NSString *sing_author;

@property (strong, nonatomic) NSMutableArray *circle_recomed;            //圈子推荐
@property (strong, nonatomic) NSMutableArray *circle_recomedArray;            //圈子推荐
@property (copy, nonatomic) BXDynCircleModel *circle_recModel;            //圈子推荐


@property (strong, nonatomic) NSMutableArray *title;            //话题
@property (strong, nonatomic) NSMutableArray *titleArray;            //话题
@property (copy, nonatomic) NSString *topic_id;            //话题id
@property (copy, nonatomic) NSString *topic_name;            //话题名称
@property (copy, nonatomic) BXDynTopicModel *topic_model;            //圈子推荐

@property (strong, nonatomic) NSMutableDictionary *usermsg;            //用户信息
@property (copy, nonatomic) NSString *gender;            //性别
@property (copy, nonatomic) NSString *user_id;            //用户id
@property (copy, nonatomic) NSString *nickname;            //用户昵称
@property (copy, nonatomic) NSString *avatar;            //用户头像

@property (copy, nonatomic) NSMutableArray *privatemsg;
@property (copy, nonatomic) NSMutableDictionary *privateDic;    //好友信息
@property (copy, nonatomic) NSMutableArray *AiTeFriendmsg;            //好友信息
@property (copy, nonatomic) NSString *friend_gender;            //性别
@property (copy, nonatomic) NSString *friend_user_id;            //用户id
@property (copy, nonatomic) NSString *friend_nickname;            //用户昵称
@property (copy, nonatomic) NSString *friend_avatar;            //用户头像


@property (copy, nonatomic) NSString *extend_followed;            //是否关注发圈用户

@property (copy, nonatomic) NSString *extend_circlfollowed;

@property (copy, nonatomic) NSString *comment_img_limit; //评论图片数量

//分级标题
@property (copy, nonatomic) NSString *icon;

@property (copy, nonatomic) BXLiveUser *liveuserModel;     
@property (copy, nonatomic) BXHMovieModel *MovieModel;          

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat dyncontentHeight;
@property (nonatomic, assign) CGFloat PersondyncontentHeight;
@property (nonatomic , copy) NSMutableAttributedString * attatties;


- (void)processAttributedString;


//种草模块
@property(nonatomic, copy)void(^goToTopic)(NSString *topic_id);

@end

NS_ASSUME_NONNULL_END

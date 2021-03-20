//
//  BXSLLiveRoom.h
//  BXlive
//
//  Created by bxlive on 2018/4/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseObject.h"
//#import "HHAdvertisement.h"
#import "SLLiveActivityGoods.h"
#import "SLLiveCoupon.h"
#import "SLLiveGoodsModel.h"
/*
 {
 detail : {
 discount_price : 5.00,
 coupon_price : 0,
 img : https://static.cnibx.cn/upload/5/common/images/20201113/20201113085733160522905329064.jpg,
 shop_type : Z,
 title : 我的昵称很长很长很长--商品名称
},
 top_time : 0,
 add_time : 1607652874,
 live_status : 0,
 id : 313,
 content : ,
 goods_activty : {
 start_time : 0,
 end_time : 2591680,
 promotion_type : 1
},
 goods_type : 1,
 goods_id : 39
}
 */


@interface BXSLLiveRoom : BaseObject

@property (copy, nonatomic) NSString *user_id;             //主播id
@property (copy, nonatomic) NSString *avatar;              //主播头像
@property (copy, nonatomic) NSString *nickname;            //主播昵称


@property (copy, nonatomic) NSString *room_id;              //房间号
@property (copy, nonatomic) NSString *cover_url;            //房间封面
@property (copy, nonatomic) NSString *title;               //直播标题
@property (copy, nonatomic) NSString *create_time;         //创建时间
@property (strong, nonatomic) NSNumber *audience;            //观众数量
@property (copy, nonatomic) NSString *status_desc;         //直播状态
@property (strong, nonatomic) NSNumber *type;              //房间类型
@property (copy, nonatomic) NSString *type_val;            //类型具体值
@property (copy, nonatomic) NSString *photo_frame;//相框

@property (copy, nonatomic) NSString *room_model;          //内容内容类型
@property (copy, nonatomic) NSString *room_desc;           //房间类型描述
@property (copy, nonatomic) NSString *province;            //开播定位省份
@property (copy, nonatomic) NSString *city;                //开播定位城市

@property (copy, nonatomic) NSString *red_icon;

@property (copy, nonatomic) NSString *is_pk;
@property (copy, nonatomic) NSString *active_cover;
@property (copy, nonatomic) NSString *target_cover;
@property (copy, nonatomic) NSString *energy;
@property (copy, nonatomic) NSString *smoke_time;

@property (nonatomic, strong) NSArray *linkMics;          //进入直播间 连麦信息

@property (copy, nonatomic) NSString *chat_server;
@property (copy, nonatomic) NSString *chat_server_port;
@property (copy, nonatomic) NSString *game_server;
@property (copy, nonatomic) NSString *game_server_port;
@property (copy, nonatomic) NSString *pull;
@property (copy, nonatomic) NSString *push;
@property (copy, nonatomic) NSString *room_channel;
@property (copy, nonatomic) NSString *game_channel;
@property (copy, nonatomic) NSString *barrage;              //飘屏

@property (copy, nonatomic) NSString *total_millet;         //直播收益
@property (copy, nonatomic) NSNumber *rank;                 //主播排行
@property (copy, nonatomic) NSString *level;                //主播等级
@property (copy, nonatomic) NSString *guard_avatar;         //守护者头像
@property (strong, nonatomic) NSMutableArray *guardlist;         //守护者头像

@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *activity_url;

//心愿单
@property (copy, nonatomic) NSString *wish_position;
@property (copy, nonatomic) NSString *wish_url;
@property (copy, nonatomic) NSString *wish_status;

@property (nonatomic, assign) NSInteger initialTime;
@property (nonatomic, assign) NSInteger addTime;


@property (copy, nonatomic) NSString *movieTitle;           //直播电影名称
@property (copy, nonatomic) NSString *start_time;           //开始时间
@property (copy, nonatomic) NSString *start_time_stamp;     //开始时间（s）
@property (copy, nonatomic) NSString *duration;             //总时长
@property (copy, nonatomic) NSString *video_rate;           //视频比例
@property (copy, nonatomic) NSString *notice;               //下场预告

@property (copy, nonatomic) NSString *tips;                 //弹出文字

@property (strong, nonatomic) NSNumber *is_follow;          //本人是否已关注
@property (copy, nonatomic) NSString *act_balance;

@property (strong, nonatomic, readonly) NSMutableArray *advertisements;    //广告
@property (strong, nonatomic, readonly) NSMutableArray *messages;          //消息流

@property (nonatomic , strong) NSDictionary * target_info;  //pk右边用户信息
@property (nonatomic , strong) NSDictionary * active_info;  //pk左边用户信息

@property (nonatomic , strong)  NSArray * pk_conf;  //pk 配置信息

@property (copy, nonatomic) NSString *jump;//本地协议

@property (copy, nonatomic) NSString *is_living;//0休息中.1直播中

@property (copy, nonatomic) NSString *is_live;//0休息中.1直播中
@property (copy, nonatomic) NSString *is_see;
@property (copy, nonatomic) NSString *verified;


@property (nonatomic, copy) NSString *index;

@property (nonatomic, copy) NSString *mode;

@property (nonatomic, strong)NSString *shop_type;

//附近
@property (nonatomic, strong)NSNumber *gender;
@property (nonatomic, strong)NSNumber *distance;

///讲解商品
@property (nonatomic, strong)SLLiveGoodsModel *say_goods;

///限时抢购商品
@property (nonatomic, strong)SLLiveActivityGoods *activty_goods;
///优惠券信息
@property (nonatomic, strong)SLLiveCoupon *coupon;

@end

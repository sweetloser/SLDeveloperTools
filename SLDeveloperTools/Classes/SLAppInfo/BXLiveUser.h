//
//  BXLiveUser.h
//  BXlive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXLiveUser : BaseObject

@property (copy, nonatomic) NSString *user_id;            
@property (copy, nonatomic) NSString *avatar;             //头像
@property (copy, nonatomic) NSString *cover;              //封面图
@property (copy, nonatomic) NSString *birthday;           //生日
@property (strong, nonatomic) NSNumber *age;              //年龄
@property (copy, nonatomic) NSString *nickname;           //昵称
@property (copy, nonatomic) NSString *username;           //用户名
@property (copy, nonatomic) NSString *sign;               //个性签名
@property (copy, nonatomic) NSString *province_name;      //省份
@property (copy, nonatomic) NSString *city_name;          //市名
@property (copy, nonatomic) NSString *district_name;      //县
@property (copy, nonatomic) NSString *level;              //等级
@property (copy, nonatomic) NSString *member_level;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *phone_code;
@property (copy, nonatomic) NSString *millet_status;
@property (copy, nonatomic) NSString *pay_status;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *need_phone;
@property (copy, nonatomic) NSString *cash_status;
@property (copy, nonatomic) NSString *exp;
@property (copy, nonatomic) NSString *unregistered;
@property (copy, nonatomic) NSString *invite_code;
@property (copy, nonatomic) NSString *impression;
@property (copy, nonatomic) NSString *bond;
@property (copy, nonatomic) NSString *taoke_level;
@property (copy, nonatomic) NSString *total_bean;
@property (copy, nonatomic) NSString *fans_num;
@property (copy, nonatomic) NSString *download_num;
@property (copy, nonatomic) NSString *his_millet;
@property (copy, nonatomic) NSString *bean_id;
@property (copy, nonatomic) NSString *credit_score;
@property (copy, nonatomic) NSString *download_num_str;
@property (copy, nonatomic) NSString *comment_status;
@property (copy, nonatomic) NSString *pay_total;
@property (copy, nonatomic) NSString *discial_id;
@property (copy, nonatomic) NSString *teenager_model_open;
@property (copy, nonatomic) NSString *relation_id;
@property (copy, nonatomic) NSString *is_promoter;
@property (copy, nonatomic) NSString *fre_millet;
@property (copy, nonatomic) NSString *his_isvirtual_millet;
@property (copy, nonatomic) NSString *live_status;
@property (copy, nonatomic) NSString *voice_sign;
@property (copy, nonatomic) NSString *purview;
@property (copy, nonatomic) NSString *update_v;
@property (copy, nonatomic) NSString *collection_num;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *contact_status;
@property (copy, nonatomic) NSString *isvirtual_millet;
@property (copy, nonatomic) NSString *city_id;
@property (copy, nonatomic) NSString *instance_id;
@property (copy, nonatomic) NSString *film_num;
@property (copy, nonatomic) NSString *fre_bean;
@property (copy, nonatomic) NSString *jd_pid;
@property (copy, nonatomic) NSString *cash;
@property (copy, nonatomic) NSString *bind_weibo;
@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *film_status;
@property (copy, nonatomic) NSString *taoke_money;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *follow_num;
@property (copy, nonatomic) NSString *cache_expired_time;
@property (copy, nonatomic) NSString *points;
@property (copy, nonatomic) NSString *vip_expire;
@property (copy, nonatomic) NSString *province_id;
@property (copy, nonatomic) NSString *isComplete;
@property (copy, nonatomic) NSString *district_id;
@property (copy, nonatomic) NSString *special_id;
@property (copy, nonatomic) NSString *reg_meid;
@property (copy, nonatomic) NSString *height;              //身高
@property (copy, nonatomic) NSString *weight;              //体重
@property (copy, nonatomic) NSArray *photo_wall_image;
@property (copy, nonatomic) NSString *is_live;
@property (copy, nonatomic) NSString *follow_time;
@property (copy, nonatomic) NSString *play_sum_str;
@property (copy, nonatomic) NSString *anchor_level;
@property (copy, nonatomic) NSString *share_sum_str;
@property (copy, nonatomic) NSString *jump;
@property (copy, nonatomic) NSString *anchor_level_progress;
@property (copy, nonatomic) NSString *creation_name;
//手机号
@property (copy, nonatomic) NSString *gender;             //性别 1男,2女,0保密
@property (copy, nonatomic) NSString *vip_status;         //是否是VIP 0未开通,1服务中,2已过期
@property (copy, nonatomic) NSString *vip_expire_str;     //VIP到期时间 (时间字符串)
@property (copy, nonatomic) NSString *is_creation;        //是否是创作号
@property (copy, nonatomic) NSString *verified;           //0未认证，1已认证，2处理中，3验证失败。
@property (copy, nonatomic) NSString * is_official;       // 1 官方 0非官方
@property (copy, nonatomic) NSString *rank_stealth;       //榜单隐身 1隐身,0不隐身
@property (copy, nonatomic) NSString *is_visitor;         //是否是游客
@property (copy, nonatomic) NSString *is_anchor;          //是否是主播
@property (copy, nonatomic) NSString *at_push;            // @我的
@property (copy, nonatomic) NSString *comment_push;       //评论推送开关 0关 1开
@property (copy, nonatomic) NSString *like_push;          //赞推送开关
@property (copy, nonatomic) NSString *follow_push;        //关注推送开关
@property (copy, nonatomic) NSString *follow_new_push;    //关注的人发布新作品开关
@property (copy, nonatomic) NSString *follow_live_push;   //关注的人开播开关
@property (copy, nonatomic) NSString *recommend_push;     //推荐视频开关
@property (copy, nonatomic) NSString *msg_push;           //私信开关
@property (copy, nonatomic) NSString *download_switch;    //下载开关
@property (copy, nonatomic) NSString *autoplay_switch;    //自动播放

@property (copy, nonatomic) NSString *follow_num_str;     //关注人数
@property (copy, nonatomic) NSString *fans_num_str;       //粉丝人数
@property (copy, nonatomic) NSString *film_num_str;       //视频数量/发布数
@property (copy, nonatomic) NSString *like_num_str;
@property (copy, nonatomic) NSString *collection_num_str;
@property (copy, nonatomic) NSString *bean;                           
@property (copy, nonatomic) NSString *total_millet_str;

@property (copy, nonatomic) NSString *loss_bean;

@property (copy, nonatomic) NSString *taoke_money_status;
@property (copy, nonatomic) NSString *pid;

//佣金
@property (copy, nonatomic) NSString *commission_total_price;
@property (copy, nonatomic) NSString *commission_pre_str;
@property (copy, nonatomic) NSString *commission_price;

@property (copy, nonatomic) NSNumber *rank;                           //榜单排名
@property (strong, nonatomic) NSNumber *millet;                       //榜单贡献 或受益
@property (strong, nonatomic) NSNumber *user_millet;                       //榜单贡献 或受益 钻石
 @property (strong, nonatomic) NSString *like_num;//赞数
@property (strong, nonatomic) NSString *video_num;//
@property (strong, nonatomic) NSString *give_coin;
@property (copy, nonatomic) NSString *bind_qq;                        //是否绑定qq
@property (copy, nonatomic) NSString *bind_weixin;                    //是否绑定微信
@property (copy, nonatomic) NSString *isset_pwd;                      //是否设置了密码

@property (copy, nonatomic) NSString *room_id;                        //如果在直播返回room_id  否则返回0
@property (copy, nonatomic) NSString *room_model;                     //如果在直播内容类型

@property (copy, nonatomic) NSString *is_show;                        //榜单隐身

@property (strong, nonatomic) NSNumber *play_sum;                     //视频播放次数
@property (strong, nonatomic) NSNumber *share_sum;                    //视频被分享次数
@property (strong, nonatomic) NSNumber *total_millet;                 //视频总收入

//查询他人资料时 使用
@property (strong, nonatomic) NSNumber *is_follow;                     //是否关注
@property (copy, nonatomic) NSString *is_black;                        //是否拉黑
@property (copy, nonatomic) NSString *is_manage;
//是否场控

@property (nonatomic , copy) NSString * tip;                           //状态(例如:可能认识的人)

@property (nonatomic , copy) NSString * addbook_id;                    //通讯录ID
@property (nonatomic , copy) NSString * friend_id;                     //通讯录好友ID
@property (nonatomic , copy) NSString * addbook_name;                  //通讯录昵称

@property (nonatomic , assign) BOOL isSelect;

@property(nonatomic, assign)CGFloat AccountSignContentHeight;



/// -9：未知错误，用户信息更新失败；-1：申请失败/审核拒绝；1：已开通；2：申请成功，待审核；3 开通失败（审核未通过）6：申请成功，待审核，未付款 ；7：审核通过；待付款
@property (nonatomic, copy)NSNumber *taoke_shop;

@property(nonatomic, copy)NSNumber *shop_id;

@property(nonatomic,copy)NSString *pdd_pid;

+ (BOOL)isLogin;
+ (BXLiveUser *)currentBXLiveUser;
+ (void)setCurrentBXLiveUser:(BXLiveUser *)liveUser;

@end

//
//  BXAppInfo.h
//  BXlive
//
//  Created by bxlive on 2018/4/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXAppInfo : BaseObject
@property (copy, nonatomic) NSString *about;                     //关于我们
@property (copy, nonatomic) NSString *charm_desc;                //榜单说明
@property (copy, nonatomic) NSString *creative;                  //创作号
@property (copy, nonatomic) NSString *flow_desc;
@property (copy, nonatomic) NSString *help;                      //帮助中心
@property (copy, nonatomic) NSString *level;                     //我的等级
@property (copy, nonatomic) NSString *millet_desc;               //收益说明
@property (copy, nonatomic) NSString *distribute;               //佣金说明
@property (copy, nonatomic) NSString *pk_record;                 //对战记录
@property (copy, nonatomic) NSString *pk_explain;                //对战说明
@property (copy, nonatomic) NSString *privacy_protocol;          //隐私协议
@property (copy, nonatomic) NSString *pub_rule;                  //短视频发布管理规则
@property (copy, nonatomic) NSString *rec_protocol;              //充值消费协议
@property(nonatomic,copy)NSString *red_desc;
@property (copy, nonatomic) NSString *reg_protocol;              //用户服务协议
@property (copy, nonatomic) NSString *task_setting;              //任务设置
@property (copy, nonatomic) NSString *task_center;               //任务中心

@property (copy, nonatomic) NSString *team;               //我的团队
@property (copy, nonatomic) NSString *agent;               //家族
@property (copy, nonatomic) NSString *create_agent;               //家族驻地

@property (copy, nonatomic) NSString *service_agree;
@property (copy, nonatomic) NSString *anchor_agree;

@property (copy, nonatomic) NSString *taoke_help;

@property (copy, nonatomic) NSString *goods_share;


@property (copy, nonatomic) NSString *show_redPacket;
@property (copy, nonatomic) NSString *access_token;

//佣金
@property (copy, nonatomic) NSString *distribute_status;
@property (copy, nonatomic) NSString *distribute_name;

//h5



//base_info
@property (nonatomic, copy) NSString *app_account_name;
@property (nonatomic, copy) NSString *app_balance_unit;
@property (nonatomic, copy) NSString *app_millet_unit;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *app_prefix_name;
@property (nonatomic, copy) NSString *app_recharge_unit;
@property (nonatomic, copy) NSString *app_settlement_unit;
@property (nonatomic, copy) NSString *contact_tel;


/*
 {
     "app_account_name" = ID;
     "app_balance_unit" = "";
     "app_millet_unit" = "\U91d1\U5e01";
     "app_name" = "\U79c9\U4fe1\U76f4\U64ad+\U6f14\U793a\U7cfb\U7edf";
     "app_prefix_name" = "\U79c9\U4fe1";
     "app_recharge_unit" = "\U94bb\U77f3";
     "app_settlement_unit" = "\U7ed3\U7b97";
     "contact_tel" = "400-027-0519";
 }
 */

@property (copy, nonatomic) NSString *code;        
@property (copy, nonatomic) NSString *area;
@property (nonatomic, copy) NSString *water_marker;

@property (strong, nonatomic) NSArray *refresh_texts;

@property (copy, nonatomic) NSArray *hot_keywords;
@property (strong, nonatomic) NSNumber *max_level;
@property (strong, nonatomic) NSNumber *charge_rec_duration;
@property (assign, nonatomic) NSInteger unread_total;
@property (copy, nonatomic) NSString *open_anchor_type;  //open_anchor_type 初始化加了这个字段  0那么开启小店和会员中心都不出现申请主播东西  1就是小店的地方出现 2就是会员中心出现

//首次进入 隐私政策和服务协议
@property(nonatomic,copy)NSString *alert_title;
@property(nonatomic,copy)NSString *alert_content;
@property(nonatomic,copy)NSString *login_service_title;
@property(nonatomic,copy)NSString *login_private_title;
@property(nonatomic,copy)NSString *login_private_url;
@property(nonatomic,copy)NSString *login_service_url;
@property(nonatomic,copy)NSString *ios_app_hidden;

@property(nonatomic,copy)NSString *one_key_login;   //1 开启本机号码一键登录
@property(nonatomic,copy)NSString *invite_code; //邀请码 2 必填
@property(nonatomic,copy)NSString *register_type;

@property (nonatomic,copy)NSString *recharge_url;

//青少年模式描述文字
@property (nonatomic,copy)NSString *teenager_desc_url;
@property (nonatomic,copy)NSString *teenager_model_show;
@property (nonatomic,copy)NSString *teenager_model_switch;

//注销账号
@property (nonatomic,copy)NSString *account_desc_url;
+ (BOOL)isGetAppInfo;
+ (BXAppInfo *)appInfo;
+ (void)setAppInfo:(BXAppInfo *)appInfo;

+ (NSString *)getPhoneArea;
+ (NSString *)getPhoneCode;

@end

//
//  BXAppInfo.m
//  BXlive
//
//  Created by bxlive on 2018/4/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXAppInfo.h"
#import "../SLBaseClass/SLBaseClass.h"
#import "../SLUtilities/CacheHelper.h"
#import <MJExtension/MJExtension.h>
#import "../SLCategory/SLCategory.h"
#import <MMKV/MMKV.h>
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"

#define kAppInfoKey               @"AppInfoKey"

@implementation BXAppInfo

MJCodingImplementation


/// 判断 `access_token` 是否存在
+ (BOOL)isGetAppInfo {
    BOOL isGet = YES;
    BXAppInfo *appInfo = [BXAppInfo appInfo];
    if (!appInfo.access_token ||!appInfo.access_token.length) {
        isGet = NO;
    }
    return isGet;
}

/// 获取文件 ` ~/Documents/Storage/AppInfoKey` 的内容
+ (BXAppInfo *)appInfo {
    BXAppInfo * appInfo = (BXAppInfo *)[CacheHelper objectForKey:kAppInfoKey];
    if (!appInfo) {
        appInfo = [[BXAppInfo alloc]init];
        [CacheHelper setObject:appInfo forKey:kAppInfoKey];
    }
    return appInfo;
}

/// 将AppInfo信息归档到文件 `~/Documents/Storage/AppInfoKey`中
/// @param appInfo appInfo
+ (void)setAppInfo:(BXAppInfo *)appInfo {
    [CacheHelper setObject:appInfo forKey:kAppInfoKey];
}

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    self.unread_total = [jsonDic[@"unread_total"] integerValue];
    self.open_anchor_type = [NSString stringWithFormat:@"%@", jsonDic[@"open_anchor_type"]];
    NSDictionary *h5_urlsDic = jsonDic[@"h5_urls"];
    NSDictionary *regist_dic = jsonDic[@"register"];
    self.level = h5_urlsDic[@"level"];
    self.about = h5_urlsDic[@"about"];
    self.help = h5_urlsDic[@"help"];
    self.reg_protocol = h5_urlsDic[@"reg_protocol"];
    self.pub_rule = h5_urlsDic[@"pub_rule"];
    self.creative = h5_urlsDic[@"creative"];
    self.rec_protocol = h5_urlsDic[@"rec_protocol"];
    self.millet_desc = h5_urlsDic[@"millet_desc"];
    self.distribute = h5_urlsDic[@"distribute"];
    self.pk_record = h5_urlsDic[@"pk_record"];
    self.pk_explain = h5_urlsDic[@"pk_explain"];
    self.task_setting = h5_urlsDic[@"task_setting"];
    self.charm_desc = h5_urlsDic[@"charm_desc"];
    self.task_center = h5_urlsDic[@"task_center"];
    self.team = h5_urlsDic[@"team"];
    self.agent = h5_urlsDic[@"agent"];
    self.create_agent = h5_urlsDic[@"create_agent"];
    
    self.flow_desc = h5_urlsDic[@"flow_desc"];
    self.privacy_protocol = h5_urlsDic[@"privacy_protocol"];
    self.recharge_url = h5_urlsDic[@"recharge"];
    
//    新增协议
    self.goods_share = h5_urlsDic[@"goods_share"];
    self.taoke_help = h5_urlsDic[@"taoke_help"];
    
//    @property (copy, nonatomic) NSString *service_agree;
//    @property (copy, nonatomic) NSString *anchor_agree;
    self.service_agree = h5_urlsDic[@"service_agree"];
    self.anchor_agree = h5_urlsDic[@"anchor_agree"];
        
//    青少年模式
    self.teenager_desc_url = h5_urlsDic[@"teenager_desc_url"];
    
//    注销账号
    self.account_desc_url = h5_urlsDic[@"account_desc_url"];
    
    NSDictionary *app_base_info = jsonDic[@"app_base_info"];
    self.app_name = app_base_info[@"app_name"];
    self.app_millet_unit = app_base_info[@"app_millet_unit"];
    self.app_account_name = app_base_info[@"app_account_name"];
    self.app_prefix_name = app_base_info[@"app_prefix_name"];
    self.app_recharge_unit = app_base_info[@"app_recharge_unit"];
    self.app_settlement_unit = app_base_info[@"app_settlement_unit"];
    self.app_balance_unit = app_base_info[@"app_balance_unit"];
    self.contact_tel = app_base_info[@"contact_tel"];
    self.ios_app_hidden = jsonDic[@"ios_app_hidden"];
    self.one_key_login = regist_dic[@"one_key_login"];
    self.invite_code = regist_dic[@"invite_code"];
    self.refresh_texts = [NSArray arrayWithArray:jsonDic[@"refresh_text"]];
    self.register_type = regist_dic[@"register_type"];
    
    NSDictionary *phone_code = jsonDic[@"phone_code"];
    self.area = phone_code[@"area"];
    self.code = phone_code[@"code"];
    self.water_marker = jsonDic[@"water_marker"];
    
//隐私协议 + 服务协议
    NSDictionary *alert_detail = jsonDic[@"alert_detail"];
    if (alert_detail && [alert_detail isDictionary]) {
        self.alert_title = alert_detail[@"alert_title"];
        self.alert_content = alert_detail[@"alert_content"];
        self.login_service_title = alert_detail[@"login_service_title"];
        self.login_private_title = alert_detail[@"login_private_title"];
        self.login_private_url = alert_detail[@"login_private_url"];
        self.login_service_url = alert_detail[@"login_service_url"];
        
    }
    
//    青少年模式
    NSDictionary *teenager = jsonDic[@"teenager"];
    if (teenager && [teenager isDictionary]) {
        self.teenager_model_show = teenager[@"teenager_model_show"];
        self.teenager_model_switch = teenager[@"teenager_model_switch"];
    }
    
    //佣金
    NSDictionary *yongjinDic = jsonDic[@"distribute"];
    if (yongjinDic && [yongjinDic isDictionary]) {
        self.distribute_status = [NSString stringWithFormat:@"%@", yongjinDic[@"distribute_status"]];
        self.distribute_name = yongjinDic[@"distribute_name"];
    }
}
+ (NSString *)getPhoneArea {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSString *phone_area = [mmkv getStringForKey:kDefaultPhoneArea];
    if (IsNilString(phone_area)) {
        phone_area = [BXAppInfo appInfo].area;
    }
    return phone_area;
}
+ (NSString *)getPhoneCode {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSString *phone_code = [mmkv getStringForKey:kDefaultPhoneCode];
    if (IsNilString(phone_code)) {
        phone_code = [BXAppInfo appInfo].code;
    }
    return phone_code;
}

@end

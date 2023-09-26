//
//  HHHttpAnchorRequest.h
//  BXlive
//
//  Created by mac on 2020/6/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHHttpAnchorRequest : NSObject
 DEFINE_SINGLETON_FOR_HEADER(HHHttpAnchorRequest)

/// 申请主播
/// @param agent_id 工会id，申请个人主播可不填
/// @param apply_type 申请类型 个人：person_apply 工会:agent_apply
/// @param type 申请时状态 0表示首次申请 4表示工会拒绝后申请 5表示平台拒绝后申请
/// @param pay_status 0表示会员中心传参 1表示开店主播传参
/// @param success 成功
/// @param failure 失败
+(void)ApplyAnchorWithAgent_id:(NSString *)agent_id
                    apply_type:(NSString *)apply_type
                          type:(NSString *)type
                    pay_status:(NSString *)pay_status
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;


/// 主播申请状态查看
/// @param success 成功
/// @param failure 失败
+(void)GetAhchorApplyStatusWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success Failure:(void(^)(NSError *error))failure;


/// 查找工会
/// @param agent_id 工会id
/// @param success 成功
/// @param failure 失败
+(void)SearchAgentWithAgent_id:(NSString *)agent_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

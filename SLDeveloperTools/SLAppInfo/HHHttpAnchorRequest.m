//
//  HHHttpAnchorRequest.m
//  BXlive
//
//  Created by mac on 2020/6/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "HHHttpAnchorRequest.h"
#import "NewHttpManager.h"
@implementation HHHttpAnchorRequest
DEFINE_SINGLETON_FOR_CLASS(HHHttpAnchorRequest)
+(void)ApplyAnchorWithAgent_id:(NSString *)agent_id
                    apply_type:(NSString *)apply_type
                          type:(NSString *)type
                    pay_status:(NSString *)pay_status
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] DomainNamePOST:@"api/anchor/apply" parameters:@{@"agent_id":agent_id, @"apply_type":apply_type, @"type":type, @"pay_status":pay_status} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
     } failure:^(NSError * _Nonnull error) {
         failure(error);
     }];
    
}


+(void)GetAhchorApplyStatusWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] DomainNamePOST:@"api/anchor/applyStatus" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
     } failure:^(NSError * _Nonnull error) {
         failure(error);
     }];
}

+(void)SearchAgentWithAgent_id:(NSString *)agent_id Success:(void (^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] DomainNamePOST:@"api/anchor/serchAgent" parameters:@{@"agent_id":agent_id} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
     } failure:^(NSError * _Nonnull error) {
         failure(error);
     }];
    
}
@end

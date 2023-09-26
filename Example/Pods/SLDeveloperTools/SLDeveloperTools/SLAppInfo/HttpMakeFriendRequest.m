//
//  HttpMakeFriendRequest.m
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "HttpMakeFriendRequest.h"
#import "NewHttpManager.h"
@implementation HttpMakeFriendRequest
+(void)GetSynDynMsgWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                             type:(NSString *)type
                     is_recommend:(NSString *)is_recommend
                      extend_type:(NSString *)extend_type
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/getMsg" parameters:@{@"page_index":page_index, @"page_size":page_size, @"type":type, @"is_recommend":is_recommend, @"extend_type":extend_type} success:^(id  _Nonnull responseObject) {
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

+(void)MyFollowedDynMsgWithpage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/myfollowed" parameters:@{@"page_index":page_index, @"page_size":page_size} success:^(id  _Nonnull responseObject) {
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

+ (void)GetNearbyMsgWithpage_index:(NSString *)page_index
                         page_size:(NSString *)page_size
                              type:(NSString *)type
                          loaction:(NSString *)loaction
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/nearbyMessage" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size], @"type":[self stringNoNil:type], @"location":[self stringNoNil:loaction]} success:^(id  _Nonnull responseObject) {
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

+(void)SearchDynWithpage_index:(NSString *)page_index
                     page_size:(NSString *)page_size
                       keyword:(NSString *)keyword
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/searchDynamic" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size], @"keyword":[self stringNoNil:keyword]} success:^(id  _Nonnull responseObject) {
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

+(void)SearchComplexNewDynWithpage_index:(NSString *)page_index
                     page_size:(NSString *)page_size
                       keyword:(NSString *)keyword
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"search/complexNew" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size], @"keyword":[self stringNoNil:keyword]} success:^(id  _Nonnull responseObject) {
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

+(void)GetMsgDetailwithmsg_id:(NSString *)msg_id
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/msgDetail" parameters:@{@"msg_id":[self stringNoNil:msg_id]} success:^(id  _Nonnull responseObject) {
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
+(void)MySenderDynWithpage_index:(NSString *)page_index
                       page_size:(NSString *)page_size
                            type:(NSString *)type
                         user_id:(NSString *)user_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/mySender" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size], @"type":[self stringNoNil:type], @"user_id":[self stringNoNil:user_id]} success:^(id  _Nonnull responseObject) {
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
+(void)DelMsgWithmsg_id:(NSString *)msg_id
                Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/delMessage" parameters:@{@"msg_id":[self stringNoNil:msg_id]} success:^(id  _Nonnull responseObject) {
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

+(void)GetConfessionWithpage_index:(NSString *)page_index
                         page_size:(NSString *)page_size
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void (^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/lastProfess" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)ConfessLeaveMsgWithfcmid:(NSString *)fcmid
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                          touid:(NSString *)touid
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void (^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/leaveMsg" parameters:@{@"fcmid":[self stringNoNil:fcmid], @"content":[self stringNoNil:content], @"imgs":[self stringNoNil:imgs],@"touid":[self stringNoNil:touid]} success:^(id  _Nonnull responseObject) {
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

+(void)ConfessListMsgWithfcmid:(NSString *)fcmid
                    page_index:(NSString *)page_index
                     page_size:(NSString *)page_size
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void (^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/confessionlist" parameters:@{@"fcmid":[self stringNoNil:fcmid], @"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)UploadDynamicWithcontent:(NSString *)content
                        picture:(NSString *)picture
                          video:(NSString *)video
                          voice:(NSString *)voice
                     voice_time:(NSString *)voice_time
                       location:(NSString *)location
                           type:(NSString *)type
                       msg_type:(NSString *)msg_type
                          title:(NSString *)title
                    extend_type:(NSString *)extend_type
                      privateid:(NSString *)privateid
                     systemtype:(NSString *)systemtype
                     systemplus:(NSString *)systemplus
                    extend_talk:(NSString *)extend_talk
                  extend_circle:(NSString *)extend_circle
                    render_type:(NSString *)render_type
                      cover_url:(NSString *)cover_url
                  dynamic_title:(NSString *)dynamic_title
                        address:(NSString *)address
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void (^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/subMsg" parameters:@{@"content":[self stringNoNil:content], @"picture":[self stringNoNil:picture],@"video":[self stringNoNil:video],@"voice":[self stringNoNil:voice],@"voice_time":[self stringNoNil:voice_time],@"location":location,@"type":type,@"msg_type":msg_type,@"title":title,@"extend_type":[self stringNoNil:extend_type],@"privateid":[self stringNoNil:privateid],@"systemplus":[self stringNoNil:systemplus],@"systemtype":[self stringNoNil:systemtype],@"extend_talk":[self stringNoNil:extend_talk],@"extend_circle":[self stringNoNil:extend_circle],@"render_type":[self stringNoNil:render_type],@"cover_url":[self stringNoNil:cover_url],@"dynamic_title":[self stringNoNil:dynamic_title],@"address":[self stringNoNil:address]} success:^(id  _Nonnull responseObject) {
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

+(void)ShareLLiveWithContent:(NSString *)content
                   cover_url:(NSString *)cover_url
               dynamic_title:(NSString *)dynamic_title
                    location:(NSString *)location
                      roomId:(NSString *)roomid
                     comfrom:(NSString *)comfrom
                      islive:(NSString *)islive
                         uid:(NSString *)uid
                     Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     Failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[self stringNoNil:roomid] forKey:@"id"];
    [dic setValue:[self stringNoNil:comfrom] forKey:@"comfrom"];
    [dic setValue:[self stringNoNil:islive] forKey:@"islive"];
    [dic setValue:[self stringNoNil:uid] forKey:@"uid"];
    
//    NSString *systemplus = [dic dictionaryToJsonString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * systemplus = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/subMsg" parameters:@{@"content":[self stringNoNil:content],@"location":location,@"type":@"2",@"systemtype":@"3",@"msg_type":@"1",@"extend_type":@"1",@"render_type":@"12",@"address":@"",@"picture":@"",@"voice":@"",@"video":@"",@"privateid":@"",@"extend_talk":@"",@"cover_url":[self stringNoNil:cover_url],@"dynamic_title":[self stringNoNil:dynamic_title], @"id": [self stringNoNil:roomid], @"islive": [self stringNoNil:islive], @"uid": [self stringNoNil:uid],@"comfrom": [self stringNoNil:comfrom],@"systemplus": [self stringNoNil:systemplus]} success:^(id  _Nonnull responseObject) {
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

+(void)AteylConnectWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/atelyConnect" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)MyFocuseWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/myFocuse" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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
+(void)FocuseMeWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/focuseMe" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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


+(void)SearchFriendWithKey_words:(NSString *)key_words
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/searchFriend" parameters:@{@"key_words":[self stringNoNil:key_words]} success:^(id  _Nonnull responseObject) {
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

+(void)CreateCircleWithcircle_name:(NSString *)circle_name
                   circle_describe:(NSString *)circle_describe
                  circle_cover_img:(NSString *)circle_cover_img
             circle_background_img:(NSString *)circle_background_img
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/createCircle" parameters:@{@"circle_name":[self stringNoNil:circle_name],@"circle_describe":[self stringNoNil:circle_describe], @"circle_cover_img":[self stringNoNil:circle_cover_img],@"circle_background_img":[self stringNoNil:circle_background_img]} success:^(id  _Nonnull responseObject) {
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

+(void)ModifyCircleWithcircle_id:(NSString *)circle_id
                     circle_name:(NSString *)circle_name
                 circle_describe:(NSString *)circle_describe
                circle_cover_img:(NSString *)circle_cover_img
           circle_background_img:(NSString *)circle_background_img
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/saveCircle" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"circle_name":[self stringNoNil:circle_name],@"circle_describe":[self stringNoNil:circle_describe], @"circle_cover_img":[self stringNoNil:circle_cover_img],@"circle_background_img":[self stringNoNil:circle_background_img]} success:^(id  _Nonnull responseObject) {
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

+(void)DissolveCircleWithcircle_id:(NSString *)circle_id
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/dismissCircle" parameters:@{@"circle_id":[self stringNoNil:circle_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)GetCircleWithCircle_type:(NSString *)circle_type
                      page_index:(NSString *)page_index
                       page_size:(NSString *)page_size
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/getCircleMsg" parameters:@{@"circle_type":[self stringNoNil:circle_type],@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)GetCircleListWithcircle_id:(NSString *)circle_id
                       page_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                      extend_type:(NSString *)extend_type
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.circle/circleList" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"extend_type":[self stringNoNil:extend_type],@"circle_id":[self stringNoNil:circle_id]} success:^(id  _Nonnull responseObject) {
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
+(void)FollowCircleWithcircle_id:(NSString *)circle_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.circle/followCircle" parameters:@{@"circle_id":[self stringNoNil:circle_id]} success:^(id  _Nonnull responseObject) {
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

+(void)CircleMyFollowedWithpage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/circleMyFollowed" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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
+ (void)SearceCircleWithCircle_type:(NSString *)circle_type
                         page_index:(NSString *)page_index
                          page_size:(NSString *)page_size
                          key_words:(NSString *)key_words
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/searchCircle" parameters:@{@"circle_type":[self stringNoNil:circle_type],@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"key_words":[self stringNoNil:key_words]} success:^(id  _Nonnull responseObject) {
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

+(void)CircleRecomedWithpage_index:(NSString *)page_index
                         page_size:(NSString *)page_size
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void (^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.circle/circleRecomed" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+ (void)DetailCircleWithcircle_id:(NSString *)circle_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/detailCircle" parameters:@{@"circle_id":[self stringNoNil:circle_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)CircleMemeberManagerWithcircle_id:(NSString *)circle_id
                                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/circleMemeberManager" parameters:@{@"circle_id":[self stringNoNil:circle_id]} success:^(id  _Nonnull responseObject) {
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

+(void)GetCommonMemberWithpage_index:(NSString *)page_index
                           page_size:(NSString *)page_size
                           circle_id:(NSString *)circle_id
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/getCommonMember" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"page_index":[self stringNoNil:page_index],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)GetEstoppelMemberWithpage_index:(NSString *)page_index
                             page_size:(NSString *)page_size
                             circle_id:(NSString *)circle_id
                               Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/getEstoppelMember" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"page_index":[self stringNoNil:page_index],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+(void)ActEstoppelWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                         status:(NSString *)status
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/actEstoppel" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"status":[self stringNoNil:status],@"uid":[self stringNoNil:uid]} success:^(id  _Nonnull responseObject) {
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

+(void)ActSetAdminWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                          power:(NSString *)power
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/actSetAdmin" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"power":[self stringNoNil:power],@"uid":[self stringNoNil:uid]} success:^(id  _Nonnull responseObject) {
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

+(void)ActSetExpelWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/actsetexpel" parameters:@{@"circle_id":[self stringNoNil:circle_id],@"uid":[self stringNoNil:uid]} success:^(id  _Nonnull responseObject) {
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


+(void)GetTopicWithpage_index:(NSString *)page_index
                    page_size:(NSString *)page_size
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/getTopic" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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
+(void)GetTopicDetailWithtopic_id:(NSString *)topic_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/getTopdetail" parameters:@{@"topic_id":[self stringNoNil:topic_id]} success:^(id  _Nonnull responseObject) {
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
+(void)GetTopicListWithpage_index:(NSString *)page_index
                    page_size:(NSString *)page_size
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/TopicList" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
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

+ (void)TipTopicListWithpage_index:(NSString *)page_index
                         page_size:(NSString *)page_size
                       extend_type:(NSString *)extend_type
                          topic_id:(NSString *)topic_id
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/tipicList" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"extend_type":[self stringNoNil:extend_type],@"topic_id":[self stringNoNil:topic_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)SearceTopicWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                        keyword:(NSString *)keyword
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Topic/queryTopic" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"keyword":[self stringNoNil:keyword]} success:^(id  _Nonnull responseObject) {
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
+(void)AddTopicWithtopic_name:(NSString *)topic_name
                    Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/addTopic" parameters:@{@"topic_name":[self stringNoNil:topic_name]} success:^(id  _Nonnull responseObject) {
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

+(void)FollowTopicWithtopic_id:(NSString *)topic_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.topic/followTopic" parameters:@{@"topic_id":[self stringNoNil:topic_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)GiveLikeWithfcmid:(NSString *)fcmid
                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/msg_live" parameters:@{@"fcmid":[self stringNoNil:fcmid]} success:^(id  _Nonnull responseObject) {
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
+ (void)GetReportWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Circle/getReportClissfiy" parameters:nil success:^(id  _Nonnull responseObject) {
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

+ (void)ReportWithreport_msg_id:(NSString *)report_msg_id
                     report_img:(NSString *)report_img
                     report_msg:(NSString *)report_msg
                           type:(NSString *)type
                    report_type:(nonnull NSString *)report_type
                     report_uid:(nonnull NSString *)report_uid
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/report" parameters:@{@"report_msg_id":[self stringNoNil:report_msg_id],@"report_img":[self stringNoNil:report_img],@"report_msg":[self stringNoNil:report_msg],@"type":[self stringNoNil:type],@"report_type":[self stringNoNil:report_type],@"report_uid":[self stringNoNil:report_uid]} success:^(id  _Nonnull responseObject) {
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

+ (void)GetSecondMenuWithmenu_id:(NSString *)menu_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.menu/getSecondMenu" parameters:@{@"menu_id":[self stringNoNil:menu_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)setFilterWithfilter_id:(NSString *)filter_id
                       msgType:(NSString *)msgType
                   filter_type:(NSString *)filter_type
                 filter_msg_id:(NSString *)filter_msg_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/setFilter" parameters:@{@"filter_id":[self stringNoNil:filter_id],@"msgTpye":[self stringNoNil:msgType],@"filter_type":[self stringNoNil:filter_type],@"filter_msg_id":[self stringNoNil:filter_msg_id]} success:^(id  _Nonnull responseObject) {
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

+ (void)SendMsgWithto_uid:(NSString *)to_uid
                 messages:(NSString *)messages
                     imgs:(NSString *)imgs
                    video:(NSString *)video
            messages_type:(NSString *)messages_type
                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Chat/sendMsg" parameters:@{@"to_uid":[self stringNoNil:to_uid],@"messages":[self stringNoNil:messages],@"imgs":[self stringNoNil:imgs],@"video":[self stringNoNil:video],@"messages_type":[self stringNoNil:messages_type]} success:^(id  _Nonnull responseObject) {
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

+ (void)GetProfessClassfySuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/getProfessClassfy" parameters:nil success:^(id  _Nonnull responseObject) {
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

+ (void)GetProfessListWithpage_index:(NSString *)page_index
                           page_size:(NSString *)page_size
                             clsssid:(NSString *)classid
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/getProfessClassfyList" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"classid":[self stringNoNil:classid]} success:^(id  _Nonnull responseObject) {
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

+ (void)CommentDynamicWithfcmid:(NSString *)fcmid
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Comment/CommentMsg" parameters:@{@"fcmid":[self stringNoNil:fcmid], @"content":[self stringNoNil:content],@"imgs":[self stringNoNil:imgs]} success:^(id  _Nonnull responseObject) {
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

+(void)DelCommentWithcommentid:(NSString *)commentid
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Comment/commentdel" parameters:@{@"commentid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
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

+(void)DelEvaluateCommentWithcommentid:(NSString *)commentid
                               Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Evaluate/evaluateDel" parameters:@{@"commentmsgid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
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

+(void)DelConfessionCommentWithevalid:(NSString *)evalid
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Profess/delConfessionEvaluate" parameters:@{@"evalid":[self stringNoNil:evalid]} success:^(id  _Nonnull responseObject) {
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

+ (void)CommentListWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                            fcmid:(NSString *)fcmid
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Comment/commentList" parameters:@{@"page_index":[self stringNoNil:page_index], @"page_size":[self stringNoNil:page_size],@"fcmid":[self stringNoNil:fcmid]} success:^(id  _Nonnull responseObject) {
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

+ (void)EvaluateMsgWithcommentid:(NSString *)commentid
                         content:(NSString *)content
                           touid:(NSString *)touid
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Evaluate/evaluateMsg" parameters:@{@"commentid":[self stringNoNil:commentid],@"content":[self stringNoNil:content],@"touid":[self stringNoNil:touid]} success:^(id  _Nonnull responseObject) {
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

+ (void)EvaluateListWithcommentid:(NSString *)commentid
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.Evaluate/evaluateList" parameters:@{@"page_index":@"1", @"page_size":@"10000",@"commentid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
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

+(void)GetMsgGoodsWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/getMsgGoods" parameters:nil success:^(id  _Nonnull responseObject) {
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

+(void)GetLiveRoomMsgWithroom_id:(NSString *)room_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] MakeFriendPOST:@"friend.friend/getLiveRoomMsg" parameters:@{@"room_id":[self stringNoNil:room_id]} success:^(id  _Nonnull responseObject) {
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
+ (NSString *)stringNoNil:(NSString *)str {
    if (str) {
        return str;
    } else {
        return @"";
    }
}
@end

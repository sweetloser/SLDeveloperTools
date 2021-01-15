//
//  SLAppInfoConst.h
//  Pods
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfoConst_h
#define SLAppInfoConst_h

static NSString *const kDefaultPhoneArea = @"DefaultPhoneArea";
static NSString *const kDefaultPhoneCode = @"DefaultPhoneCode";

static NSString *const sl_HttpResponseCodeError = @"sl_HttpResponseCodeError";                        //http请求 code 不为 0
static NSString *const sl_UploadFileResponseCodeError = @"sl_UploadFileResponseCodeError";                        //上传文件请求 code 不为 0
static NSString *const kDidShareNotification = @"DidShareNotification";                               //分享完成


static NSString *const BXDynMsgDetailModel2PersonHome = @"BXDynMsgDetailModel2PersonHome";             //点击昵称跳转个人主页
static NSString *const BXDynMsgDetailModel2TopicCategory = @"BXDynMsgDetailModel2TopicCategory";             //点击话题跳转话题页面

static NSString *const kDidGetLocationNotification = @"DidGetLocationNotification";                   //获取到了定位信息

static NSString *const kDidCollectNotification = @"DidCollectNotification";                           //收藏或取消收藏

static NSString *const kDidCommentNotification = @"DidCommentNotification";                           //评论或删除评论
#endif /* SLAppInfoConst_h */

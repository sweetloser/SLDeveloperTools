//
//  HttpMakeFriendRequest.h
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HttpMakeFriendRequest : NSObject

/// 获取动态
/// @param page_index 页数下标
/// @param page_size 页数
/// @param type 发布信息类型2：话题3，圈子6表白
/// @param is_recommend 是否推荐 1：推荐
/// @param extend_type 扩展类型：1综合2视频3：声音
/// @param success 成功
/// @param failure 失败
+(void)GetSynDynMsgWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                             type:(NSString *)type
                     is_recommend:(NSString *)is_recommend
                      extend_type:(NSString *)extend_type
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

+(void)MySenderDynWithpage_index:(NSString *)page_index
                       page_size:(NSString *)page_size
                            type:(NSString *)type
                    user_id:(NSString *)user_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure;


/// 我关注的人的动态
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)MyFollowedDynMsgWithpage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure;

/// 获取附近动态
/// @param page_index 页数下标
/// @param page_size 页数
/// @param type 发布信息类型2：话题3，圈子6表白
/// @param lacation 位置
/// @param success 成功
/// @param failure 失败
+(void)GetNearbyMsgWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                             type:(NSString *)type
                     loaction:(NSString *)loaction
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 搜索动态
/// @param page_index 页数下标
/// @param page_size 页数
/// @param keyword 关键字
/// @param success 成功
/// @param failure 失败
+(void)SearchDynWithpage_index:(NSString *)page_index
                     page_size:(NSString *)page_size
                       keyword:(NSString *)keyword
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

/// 搜索动态综合
/// @param page_index 页数下标
/// @param page_size 页数
/// @param keyword 关键字
/// @param success 成功
/// @param failure 失败
+(void)SearchComplexNewDynWithpage_index:(NSString *)page_index
                     page_size:(NSString *)page_size
                       keyword:(NSString *)keyword
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

/// 获取动态详情
/// @param msg_id 消息ID
/// @param success 成功
/// @param failure 失败
+(void)GetMsgDetailwithmsg_id:(NSString *)msg_id
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure;


/// 删除动态
/// @param msg_id 信息id
/// @param success 成功
/// @param failure 失败
+(void)DelMsgWithmsg_id:(NSString *)msg_id
                Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                Failure:(void(^)(NSError *error))failure;

/// 表白
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)GetConfessionWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

+(void)UploadDynamicWithcontent:(NSString *)content
                        picture:(NSString*)picture
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
                        Failure:(void(^)(NSError *error))failure;

+(void)ShareLLiveWithContent:(NSString *)content
                   cover_url:(NSString *)cover_url
               dynamic_title:(NSString *)dynamic_title
                    location:(NSString *)location
                      roomId:(NSString *)roomid
                         comfrom:(NSString *)comfrom
                      islive:(NSString *)islive
                         uid:(NSString *)uid
                     Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     Failure:(void(^)(NSError *error))failure;


/// 表白留言
/// @param fcmid 告白id
/// @param content 内容
/// @param touid 回复id
/// @param success 成功
/// @param failure 失败
+(void)ConfessLeaveMsgWithfcmid:(NSString *)fcmid
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                          touid:(NSString *)touid
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;


/// 获取告白留言列表
/// @param fcmid 告白id
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)ConfessListMsgWithfcmid:(NSString *)fcmid
                  page_index:(NSString *)page_index
                    page_size:(NSString *)page_size
                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure;

/// 最近联系  好友
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)AteylConnectWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 我关注的  好友
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)MyFocuseWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 关注我的 好友
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)FocuseMeWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 搜索好友
/// @param key_words 关键字
/// @param success 成功
/// @param failure 失败
+(void)SearchFriendWithKey_words:(NSString *)key_words
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 创建圈子
/// @param circle_name 圈子名字
/// @param circle_describe 圈子描述
/// @param circle_cover_img 圈子封面
/// @param circle_background_img 圈子背景
/// @param success 成功
/// @param failure 失败
+(void)CreateCircleWithcircle_name:(NSString *)circle_name
                   circle_describe:(NSString *)circle_describe
                  circle_cover_img:(NSString *)circle_cover_img
             circle_background_img:(NSString *)circle_background_img
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure;


/// 圈子修改
/// @param circle_id 圈子id
/// @param circle_name 圈子名称
/// @param circle_describe 圈子描述
/// @param circle_cover_img 圈子封面
/// @param circle_background_img 圈子背景
/// @param success 成功
/// @param failure 失败   
+(void)ModifyCircleWithcircle_id:(NSString *)circle_id
                     circle_name:(NSString *)circle_name
                 circle_describe:(NSString *)circle_describe
                circle_cover_img:(NSString *)circle_cover_img
           circle_background_img:(NSString *)circle_background_img
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure;


/// 解散圈子
/// @param circle_id 圈子ID
/// @param success 成功
/// @param failure 失败   
+(void)DissolveCircleWithcircle_id:(NSString *)circle_id
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure;

/// 获取圈子
/// @param circle_type 1所有 2我的
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)GetCircleWithCircle_type:(NSString *)circle_type
                     page_index:(NSString *)page_index
                      page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 获取圈子列表
/// @param circle_id 圈子id
/// @param page_index 页数下标
/// @param page_size 页数
/// @param extend_type 类型 1:综合 2:视频
/// @param success 成功
/// @param failure 失败
+(void)GetCircleListWithcircle_id:(NSString *)circle_id
                       page_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                      extend_type:(NSString *)extend_type
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 关注圈子
/// @param circle_id 圈子id
/// @param success 成功
/// @param failure 失败
+(void)FollowCircleWithcircle_id:(NSString *)circle_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure;


/// 我关注的圈子
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)CircleMyFollowedWithpage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure;

/// 搜索圈子
/// @param circle_type 1所有 2我的
/// @param page_index 页数下标
/// @param page_size 页数
/// @param key_words 关键字
/// @param success 成功
/// @param failure 失败
+(void)SearceCircleWithCircle_type:(NSString *)circle_type
                     page_index:(NSString *)page_index
                      page_size:(NSString *)page_size
                         key_words:(NSString *)key_words
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 圈子推荐
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)CircleRecomedWithpage_index:(NSString *)page_index
                         page_size:(NSString *)page_size
                           Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                           Failure:(void(^)(NSError *error))failure;


/// 圈子详情
/// @param circle_id 圈子id
/// @param success 成功
/// @param failure 失败
+(void)DetailCircleWithcircle_id:(NSString *)circle_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure;



/// 获取圈子管理员
/// @param circle_id 圈子id
/// @param success 成功
/// @param failure 失败
+(void)CircleMemeberManagerWithcircle_id:(NSString *)circle_id
                                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                 Failure:(void(^)(NSError *error))failure;


/// 获取圈子成员
/// @param page_index 页数下标
/// @param page_size 页数
/// @param circle_id 圈子id
/// @param success 成功
/// @param failure 失败
+(void)GetCommonMemberWithpage_index:(NSString *)page_index
                           page_size:(NSString *)page_size
                           circle_id:(NSString *)circle_id
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure;

/// 获取禁言成员
/// @param page_index 页数下标
/// @param page_size 页数
/// @param circle_id 圈子id
/// @param success 成功
/// @param failure 失败
+(void)GetEstoppelMemberWithpage_index:(NSString *)page_index
                           page_size:(NSString *)page_size
                           circle_id:(NSString *)circle_id
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure;


/// 对成员进行禁言/取消禁言
/// @param circle_id 圈子id
/// @param uid 用户id
/// @param status 操作 1:禁言 0:取消禁言
/// @param success 成功
/// @param failure 失败
+(void)ActEstoppelWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                         status:(NSString *)status
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure;



/// 对成员设置管理员
/// @param circle_id 圈子id
/// @param uid 用户id
/// @param power 权限 0:普通成员 2:管理员
/// @param success 成功
/// @param failure 失败
+(void)ActSetAdminWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                          power:(NSString *)power
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure;


/// 对成员进行驱逐
/// @param circle_id 圈子id
/// @param uid 用户id
/// @param success 成功
/// @param failure 失败   
+(void)ActSetExpelWithcircle_id:(NSString *)circle_id
                            uid:(NSString *)uid
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure;

/// 获取话题
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)GetTopicWithpage_index:(NSString *)page_index
                      page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 获取话题详情
/// @param topic_id 话题id
/// @param success 成功
/// @param failure 失败
+(void)GetTopicDetailWithtopic_id:(NSString *)topic_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 获取话题列表（动态首页附近头视图）
/// @param page_index 页数下标
/// @param page_size 页数
/// @param success 成功
/// @param failure 失败
+(void)GetTopicListWithpage_index:(NSString *)page_index
                      page_size:(NSString *)page_size
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 点击话题列表跳转到详情
/// @param page_index 页数下标
/// @param page_size 页数
/// @param extend_type 类型 1综合 2视频
/// @param topic_id 话题id
/// @param success 成功
/// @param failure 失败
+(void)TipTopicListWithpage_index:(NSString *)page_index
                        page_size:(NSString *)page_size
                      extend_type:(NSString *)extend_type
                         topic_id:(NSString *)topic_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 搜索话题
/// @param page_index 页数下标
/// @param page_size 页数
/// @param key_words 关键字
/// @param success 成功
/// @param failure 失败
+(void)SearceTopicWithpage_index:(NSString *)page_index
                      page_size:(NSString *)page_size
                         keyword:(NSString *)keyword
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

/// 添加话题

/// @param topic_name 话题
/// @param success 成功
/// @param failure 失败
+(void)AddTopicWithtopic_name:(NSString *)topic_name
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;


/// 关注话题
/// @param topic_id 话题id
/// @param success 成功
/// @param failure 失败
+(void)FollowTopicWithtopic_id:(NSString *)topic_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

///  点赞动态
/// @param fcmid id
/// @param success 成功
/// @param failure 失败
+(void)GiveLikeWithfcmid:(NSString *)fcmid
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

///  举报分类
/// @param success 成功
/// @param failure 失败
+(void)GetReportWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;



/// 举报
/// @param report_msg_id 信息id
/// @param report_img 截图
/// @param report_msg 举报信息
/// @param type 类型
/// @param report_type 2:动态 3:圈子 6：表白 7:评论 8 ：留言 9:举报人
///  @param report_uid 用户ID
/// @param success 成功
/// @param failure 失败
+(void)ReportWithreport_msg_id:(NSString *)report_msg_id
                    report_img:(NSString *)report_img
                    report_msg:(NSString *)report_msg
                          type:(NSString *)type
                   report_type:(NSString *)report_type
                    report_uid:(NSString *)report_uid
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

///  获取菜单
/// @param menu_id 分类id
/// @param report_img 截图
/// @param report_msg 举报信息
/// @param type 类型
/// @param success 成功
/// @param failure 失败
+(void)GetSecondMenuWithmenu_id:(NSString *)menu_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;


/// 过滤信息
/// @param filter_id 用户id
/// @param msgType 消息类型 2动态 3圈子 6表白
/// @param filter_type 过滤类型 1全部 2单消息
/// @param filter_msg_id 指定单消息id
/// @param success 成功
/// @param failure 失败
+(void)setFilterWithfilter_id:(NSString *)filter_id
                      msgType:(NSString *)msgType
                  filter_type:(NSString *)filter_type
                filter_msg_id:(NSString *)filter_msg_id
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure;


///  悄悄话
/// @param to_uid 接收者id
/// @param messages 文字信息
/// @param imgs 图片
/// @param video 视频
/// @param messages_type 1文章 2图片 3视频
/// @param success 成功
/// @param failure 失败
+(void)SendMsgWithto_uid:(NSString *)to_uid
                messages:(NSString *)messages
                    imgs:(NSString *)imgs
                   video:(NSString *)video
           messages_type:(NSString *)messages_type
                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 Failure:(void(^)(NSError *error))failure;


/// 获取表白推荐标题
/// @param success 成功
/// @param failure 失败
+(void)GetProfessClassfySuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure;


/// 表白推荐词条
/// @param page_index 页数下标
/// @param page_size 页数
/// @param classid 词条分类（与标题对应）
/// @param success 成功
/// @param failure 失败
+(void)GetProfessListWithpage_index:(NSString *)page_index
                          page_size:(NSString *)page_size
                            clsssid:(NSString *)classid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;



/// 对动态评论
/// @param fcmid 信息id
/// @param content 内容
/// @param imgs 图片
/// @param success 成功
/// @param failure 失败
+(void)CommentDynamicWithfcmid:(NSString *)fcmid
                       content:(NSString *)content
                          imgs:(NSString *)imgs
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;


/// 删除评论
/// @param commentid 评论id
/// @param success 成功
/// @param failure 失败
+(void)DelCommentWithcommentid:(NSString *)commentid
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

/// 删除子评论
/// @param commentid 评论id
/// @param success 成功
/// @param failure 失败
+(void)DelEvaluateCommentWithcommentid:(NSString *)commentid
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

/// 删除表白评论评论
/// @param evalid 评论id
/// @param success 成功
/// @param failure 失败
+(void)DelConfessionCommentWithevalid:(NSString *)evalid
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

/// 评论列表
/// @param fcmid 信息id
/// @param success 成功
/// @param failure 失败
+(void)CommentListWithpage_index:(NSString *)page_index
                       page_size:(NSString *)page_size
                           fcmid:(NSString *)fcmid
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;


/// 对动态评论进行评论/回复
/// @param commentid 评论id
/// @param content 内容
/// @param success 成功
/// @param failure 失败
+(void)EvaluateMsgWithcommentid:(NSString *)commentid
                        content:(NSString *)content
                          touid:(NSString *)touid
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure;

/// 对评论的评论列表
/// @param commentid 评论id
/// @param success 成功
/// @param failure 失败
+(void)EvaluateListWithcommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

/// 获取商品信息
/// @param success 成功
/// @param failure 失败
+(void)GetMsgGoodsWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure;


/// 获取直播信息
/// @param room_id 房间id
/// @param success 成功
/// @param failure 失败
+(void)GetLiveRoomMsgWithroom_id:(NSString *)room_id
                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         Failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

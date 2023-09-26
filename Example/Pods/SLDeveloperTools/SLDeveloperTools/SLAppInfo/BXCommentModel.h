//
//  BXCommentModel.h
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXCommentModel : NSObject
/** 评论人id */
@property (nonatomic , copy) NSString * user_id;
/** 该条评论id */
@property (nonatomic , copy) NSString * comment_id;
/** 头像 */
@property (nonatomic , copy) NSString * avatar;
/** 昵称 */
@property (nonatomic , copy) NSString * nickname;
/** 内容 */
@property (nonatomic , copy) NSString * content;
/** 时间 */
@property (nonatomic , copy) NSString * publish_time;
/** 是否是作者 */
@property (nonatomic , copy) NSString * is_anchor;
/** 是否点过赞 */
@property (nonatomic , copy) NSString * is_like;
/** 点赞的数量 */
@property (nonatomic , copy) NSString * like_count;
/** 回复的数量 */
@property (nonatomic , copy) NSString * reply_count;
/** 回复的数量(处理后的) */
@property (nonatomic , copy) NSString * reply_count_str;
/** 子评论 */
@property (nonatomic , strong) NSMutableArray * childCommentArray;
/** 艾特 */
@property (nonatomic , strong) NSMutableArray * friend_group;
/** 是否是回复 */
@property (nonatomic , copy) NSString * is_reply;
/** 回复的人的id */
@property (nonatomic , copy) NSString * reply_uid;
/** 回复的人的昵称 */
@property (nonatomic , copy) NSString * reply_nickname;

@property (nonatomic , copy) NSString * url;

@property (nonatomic, assign) NSInteger showChildCount;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic , strong) NSMutableAttributedString * attatties;

@property (nonatomic, copy) void (^toPersonHome)(NSString *userId);

- (instancetype)initWithDict:(NSDictionary *)dict;

-(void)processAttributedStringWithIsChild:(BOOL)isChild;



//关注界面使用的参数
@property (nonatomic, assign) CGFloat attentionHight;
@property (nonatomic , strong) NSMutableAttributedString * attentionAttatties;
-(void)processAttributedStringWithAttaties;


@end

NS_ASSUME_NONNULL_END

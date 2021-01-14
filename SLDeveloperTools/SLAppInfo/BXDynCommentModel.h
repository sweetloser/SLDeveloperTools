//
//  BXDynCommentModel.h
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynCommentModel : BaseObject
@property(nonatomic, strong)NSString *contentid;
@property(nonatomic, strong)NSString *fcmid;
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *imgs;
@property(nonatomic, strong)NSString *smallimgs;
@property(nonatomic, strong)NSString *create_time;
@property(nonatomic, strong)NSString *like_count;
@property(nonatomic, strong)NSString *evaluate_count;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSDictionary *userdetail;
@property(nonatomic, strong)NSString *user_id;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *userlivecheck;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat ChildheaderHeight;

@property(nonatomic, strong)NSString *commentid;//评论id
@property(nonatomic, strong)NSString *touid;//回复id
@property(nonatomic, strong)NSDictionary *touserdetail;//回复的用户信息
@property(nonatomic, strong)NSString *reply_user_id;
@property(nonatomic, strong)NSString *reply_nickname;
@property(nonatomic, strong)NSString *reply_avatar;

@property(nonatomic, strong)NSString *timediff;
@property (nonatomic, copy) void (^toPersonHome)(NSString *userId);
@property (nonatomic , strong) NSMutableAttributedString * attatties;

@property (nonatomic, assign) BOOL isChildAttatties;
@property (nonatomic , strong) NSMutableAttributedString * DetailChildattatties;
- (void)processAttributedStringWithIsChild:(BOOL)isChild;
@end

NS_ASSUME_NONNULL_END

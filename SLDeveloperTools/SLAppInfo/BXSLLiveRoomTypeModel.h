//
//  BXSLLiveRoomTypeModel.h
//  SLDeveloperTools
//
//  Created by sweetloser on 2021/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXSLLiveRoomTypeModel : NSObject

/// 房间类型
/// 0 - 普通房间（直接进入）
/// 1 - 私密房间（需要验证密码才可以进入）
/// 2 - 收费房间（需扣费进入）
/// 3 - 计费直播 - （按时间收费，可以直接进入，从余额中直接扣，余额不足时会退出直播间）
/// 4 - VIP房间（当前用户不是VIP，因此当type=4时，用户无法进入直播间）
/// 5 - 等级房间（当前用户等级不满足主播设置的最低等级，因此当type=5时，用户无法进入直播间）
@property(nonatomic,copy)NSNumber *type;

/// 直播类型
/// 0 - 直播
/// 1 - 录播
/// 2 - 电影
/// 3 - 游戏
/// 4 - 多人语聊
/// 5 - 电台
@property(nonatomic,copy)NSNumber *mode;

/// 提示语
@property(nonatomic,copy)NSString *tips;
@end

NS_ASSUME_NONNULL_END

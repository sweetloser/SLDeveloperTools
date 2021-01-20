//
//  BXDynMemberModel.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynMemberModel : BaseObject
@property(nonatomic, strong)NSString *user_id;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *gender;

@property(nonatomic, strong)NSString *estoppel;//禁言人数

@property(nonatomic, strong)NSString *circle_id;
@property(nonatomic, strong)NSString *ctime;
@property(nonatomic, strong)NSString *difftime;
@property(nonatomic, strong)NSString *power;//权限 0:普通权限
@property(nonatomic, strong)NSString *is_follow;//是否关注
@property(nonatomic, strong)NSString *status;//0:普通 1:禁言 2:驱逐

@end

NS_ASSUME_NONNULL_END

//
//  BXDaemonListModel.h
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXDaemonListModel : BaseObject

@property (copy, nonatomic) NSString *user_id;//贡献值id
@property (copy, nonatomic) NSString *avatar;//头像
@property (copy, nonatomic) NSString *level;//等级
@property (copy, nonatomic) NSString *nickname;//昵称
@property (copy, nonatomic) NSString *sign;//签名
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *verified;
@property (copy, nonatomic) NSString *vip_status;
@property (copy, nonatomic) NSString *is_creation;
@property (copy, nonatomic) NSString *user_millet;

@property (assign, nonatomic) NSInteger type;

@end

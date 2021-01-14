//
//  DynAiTeFriendModel.h
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynAiTeFriendModel : BaseObject
@property(nonatomic, strong)NSString *uid; //好友id
@property(nonatomic, strong)NSString *ctime;
@property(nonatomic, strong)NSString *timedeiff;//
@property(nonatomic, strong)NSString *day;//
@property(nonatomic, strong)NSString *hour;//
@property(nonatomic, strong)NSString *min;//
@property(nonatomic, strong)NSString *sec;//
@property(nonatomic, strong)NSMutableDictionary *usermsg;//
@property(nonatomic, strong)NSString *user_id;//
@property(nonatomic, strong)NSString *nickname;//
@property(nonatomic, strong)NSString *avatar;//
@property(nonatomic, strong)NSString *create_time;//
@property(nonatomic, strong)NSMutableDictionary *userdetail;//
@property(nonatomic, strong)NSString *is_follow;//
@property(nonatomic, strong)NSString *gender;//
@property(nonatomic, strong)NSString *level;//
@property(nonatomic, strong)NSString *verified;//
@property(nonatomic, strong)NSString *is_creation;//
@property(nonatomic, strong)NSString *sign;//
@property(nonatomic, strong)NSString *vip_status;//
@property(nonatomic, strong)NSString *is_live;//
@property(nonatomic, strong)NSString *is_aite_selected;//
@end

NS_ASSUME_NONNULL_END

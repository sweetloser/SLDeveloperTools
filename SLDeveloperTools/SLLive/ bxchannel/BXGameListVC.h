//
//  GameListVc.h
//  BXlive
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BaseVC.h"

@interface BXGameListVC : BaseVC

@property(nonatomic,copy)void(^selectType)(NSString *name,NSString *channel_id,NSString *game_type);

@end

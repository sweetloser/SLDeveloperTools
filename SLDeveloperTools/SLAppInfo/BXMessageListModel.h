//
//  BXMessageListModel.h
//  BXlive
//
//  Created by bxlive on 2018/4/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXMessageListModel : BaseObject
@property (copy, nonatomic) NSString *cat_type;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *unread;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *last_send_time;
@property (copy, nonatomic) NSString *icon;

/// 聊天置顶标识
@property(nonatomic,copy)NSNumber *session_mark_top;


@end

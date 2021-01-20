//
//  BXdynCircleRecModel.h
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXdynCircleRecModel : BaseObject
@property(nonatomic, strong)NSString *circle_id;
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, strong)NSString *circle_name;
@property(nonatomic, strong)NSString *circle_describe;
@property(nonatomic, strong)NSString *circle_cover_img;
@property(nonatomic, strong)NSString *circle_background_img;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *is_recom;
@property(nonatomic, strong)NSString *ctime;
@property(nonatomic, strong)NSString *dismiss;
@property(nonatomic, strong)NSString *utime;
@property(nonatomic, strong)NSString *dismiss_time;
@property(nonatomic, strong)NSString *follow;


@property(nonatomic, strong)NSString *topic_id;
@property(nonatomic, strong)NSString *topic_name;

@end

NS_ASSUME_NONNULL_END

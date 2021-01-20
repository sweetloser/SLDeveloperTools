//
//  SLAmwayDetailModel.h
//  BXlive
//
//  Created by sweetloser on 2020/11/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLAmwayDetailUserModel : BaseObject

@property(nonatomic,copy)NSNumber *gender;
@property(nonatomic,copy)NSNumber *user_id;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSNumber *create_time;

@end

@interface SLAmwayDetailShowGoodsInfo : BaseObject

@property(nonatomic,copy)NSString *shopname;
@property(nonatomic,copy)NSString *goods_image;
@property(nonatomic,copy)NSString *shoplogo;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *market_price;
@property(nonatomic,copy)NSString *site_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSNumber *goods_id;

@end

@interface SLAmwayDetailImgsDetailInfo : BaseObject

@property(nonatomic,copy)NSString *format;
@property(nonatomic,copy)NSNumber *height;
@property(nonatomic,copy)NSString *badge;
@property(nonatomic,copy)NSString *colorModel;
@property(nonatomic,copy)NSNumber *width;
@property(nonatomic,copy)NSNumber *size;
@property(nonatomic,copy)NSString *orientation;
@property(nonatomic,copy)NSString *smallpicture;
//format : jpeg,
//height : 1562,
//badge : static,
//colorModel : ycbcr,
//width : 879,
//size : 944553,
//orientation : Top-left,
//smallpicture :

@end

@interface SLAmwayDetailModel : BaseObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *privateid;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSArray *title;    //话题
@property(nonatomic,copy)NSNumber *create_time;
@property(nonatomic,copy)NSArray *imgs_detail;
@property(nonatomic,copy)NSArray *picture;
@property(nonatomic,copy)NSNumber *extend_talk;
@property(nonatomic,copy)NSNumber *extend_followed;
@property(nonatomic,copy)NSString *video;
@property(nonatomic,copy)NSArray *systemplus;
@property(nonatomic,copy)NSNumber *render_type;
@property(nonatomic,copy)NSNumber *type;
@property(nonatomic,copy)NSNumber *comment_num;
@property(nonatomic,copy)NSNumber *msg_id;
@property(nonatomic,strong)SLAmwayDetailUserModel *usermsg;
@property(nonatomic,copy)NSArray *showgoods;
@property(nonatomic,copy)NSNumber *uid;
@property(nonatomic,copy)NSArray *privatemsg;
@property(nonatomic,copy)NSNumber *is_recommend;
@property(nonatomic,copy)NSArray *smallpicture;
@property(nonatomic,copy)NSString *difftime;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSNumber *like_num;
@property(nonatomic,copy)NSNumber *mylive;
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)
//@property(nonatomic,copy)

@end

NS_ASSUME_NONNULL_END

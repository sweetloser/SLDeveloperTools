//
//  BXLocation.h
//  BXlive
//
//  Created by bxlive on 2019/2/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXLocation : BaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *location_id;

@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance_str;
@property (nonatomic, copy) NSString *goto_num;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *is_collect;

@property (nonatomic, copy) NSString *street_address;
@property (nonatomic, copy) NSString *city_name;

//POI全局唯一ID
@property (nonatomic, copy) NSString     *uid;
//类型编码
@property (nonatomic, copy) NSString     *typecode;
//电话
@property (nonatomic, copy) NSString *tel;
//邮编
@property (nonatomic, copy) NSString *postcode;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, copy) NSString * region_level;
//类型(1 选中,0 不选中)
@property (assign, nonatomic) NSInteger selectType;
@property (nonatomic, assign) BOOL isGetDetail;

@end



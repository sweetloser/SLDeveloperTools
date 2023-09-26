//
//  BXTopicModel.h
//  BXlive
//
//  Created by bxlive on 2019/2/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"



@interface BXTopicModel : BaseObject
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descr;
@property (nonatomic, copy) NSString *participate_num;
@property (nonatomic, copy) NSString *play_total;
@property (nonatomic, copy) NSString *is_collection;


@property (nonatomic, strong) NSMutableAttributedString *descrAttri;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) CGFloat descrAttriHeight;
@property (nonatomic, assign) CGFloat descrAttriLimitHeight;
@property (nonatomic, assign) CGFloat descrAttriOriginalHeight;


@end



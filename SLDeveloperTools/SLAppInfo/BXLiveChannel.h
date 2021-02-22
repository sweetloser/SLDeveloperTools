//
//  BXLiveChannel.h
//  BXlive
//
//  Created by bxlive on 2018/4/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXLiveChannel : BaseObject

@property (copy, nonatomic) NSString *channelId;
@property (copy, nonatomic) NSString *sub_channel;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *descriptions;


@property (copy, nonatomic) NSString *pk_type;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *height;
@property (copy, nonatomic) NSString *width;
@property (copy, nonatomic) NSString *desc;


@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat cellWidth;


@property (nonatomic ,copy) NSAttributedString *attatties;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *menu_id;


//"red_id": 12,
//"bean": "320.00",
//"create_time": "07-15",
//"type": "normal",

@property (copy, nonatomic) NSString *red_id;
@property (copy, nonatomic) NSString *titleString;
@property (copy, nonatomic) NSString *timeString;
@property (copy, nonatomic) NSString *coinString;





@end

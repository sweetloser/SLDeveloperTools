//
//  BXHeadline.h
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXHeadline : BaseObject

@property (nonatomic, copy) NSString *headlineId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, copy) NSString *imageCount;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *release_time;
@property (nonatomic, copy) NSString *h5_url;

@end



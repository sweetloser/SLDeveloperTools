//
//  BXDynEntryModel.h
//  BXlive
//
//  Created by mac on 2020/7/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynEntryModel : BaseObject
@property(nonatomic, strong)NSString *entryID;
@property(nonatomic, strong)NSString *classid;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *from;
@property(nonatomic, strong)NSString *fromname;
@property(nonatomic, strong)NSString *isdel;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *create_time;
@end

NS_ASSUME_NONNULL_END

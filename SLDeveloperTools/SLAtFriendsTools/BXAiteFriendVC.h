//
//  BXAiteFriendVC.h
//  BXlive
//
//  Created by bxlive on 2019/5/9.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXAiteFriendVC : BaseVC
@property(nonatomic,copy)void (^selectTextArray)(NSMutableArray *array);

@property(nonatomic,strong)NSMutableArray *friendArray;

@end

NS_ASSUME_NONNULL_END

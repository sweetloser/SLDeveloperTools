//
//  BXOPenIssueDyn.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynTopicModel.h"
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXOPenIssueDyn : BaseVC
@property(nonatomic, strong)BXDynTopicModel *topicModel;
@property(nonatomic, strong)BXDynCircleModel *circleModel;
@property(nonatomic,copy)void(^IssueSuccess)();
@end

NS_ASSUME_NONNULL_END

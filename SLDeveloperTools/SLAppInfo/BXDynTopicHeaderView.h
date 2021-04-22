//
//  BXDynTopicHeaderView.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicHeaderView : UIView
@property (nonatomic,copy)void(^DidClickTopic)(BXDynTopicModel *model);

@property (nonatomic,copy)void(^AttentClickTopic)(void);
- (void)scrollViewDidScroll:(CGFloat)offsetY;
@property(nonatomic, strong)BXDynTopicModel *model;
@property(nonatomic, strong)UIImageView *attImageView;
@end

NS_ASSUME_NONNULL_END

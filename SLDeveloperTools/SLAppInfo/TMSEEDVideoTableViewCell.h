//
//  BXDynNewVideoTableViewCell.h
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMSeedingBaseTableviewCell.h"
#import "BXDynamicModel.h"
#import "SLAmwayListModel.h"
@class TMSEEDVideoTableViewCell;
@class BXCommentModel;
NS_ASSUME_NONNULL_BEGIN
@interface TMSEEDVideoTableViewCell : TMSeedingBaseTableviewCell
@property (copy, nonatomic) void (^DidClickPlay)(BXDynamicModel *model, UIButton * _Nullable playbtn, TMSEEDVideoTableViewCell *cell);
@property (copy, nonatomic) void (^DidCover)(TMSEEDVideoTableViewCell *cell);
@property (nonatomic ,strong) UIView *backView;//图片背景
@property (nonatomic ,strong) UIButton *playBtn;//播放文字
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) SLAmwayListModel *slModel;
@end

NS_ASSUME_NONNULL_END

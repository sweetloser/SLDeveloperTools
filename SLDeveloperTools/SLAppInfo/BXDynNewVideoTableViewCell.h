//
//  BXDynNewVideoTableViewCell.h
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynBaseTableviewCell.h"
#import "BXDynamicModel.h"
@class BXDynNewVideoTableViewCell;
@class BXCommentModel;
NS_ASSUME_NONNULL_BEGIN
//- (void)didClickPlayButtonInCell:(BXAttentionVideoCell *)cell playButton:(UIButton *)playButton;
@interface BXDynNewVideoTableViewCell : BXDynBaseTableviewCell
@property (copy, nonatomic) void (^DidClickPlay)(BXDynamicModel *model, UIButton * _Nullable playbtn, BXDynNewVideoTableViewCell *cell);
@property (copy, nonatomic) void (^DidCover)(BXDynNewVideoTableViewCell *cell);
@property (nonatomic ,strong) UIView *backView;//图片背景
@property (nonatomic ,strong) UIButton *playBtn;//播放文字
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END

//
//  BXAttentionVideoCell.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHMovieModel.h"
#import "BXTextScrollView.h"
@class BXCommentModel;
@class BXAttentionVideoCell;

@protocol BXAttentionVideoCelllDelegate <NSObject>
@optional
- (void)didClickLikeButtonInCell:(BXAttentionVideoCell *)cell;
- (void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell type:(NSInteger)type;
- (void)didClickPlayButtonInCell:(BXAttentionVideoCell *)cell playButton:(UIButton *)playButton;
- (void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell model:(BXCommentModel *)model;
- (void)didClickCoverImageInCell:(BXAttentionVideoCell *)cell;
@end

@interface BXAttentionVideoCell : UITableViewCell
@property (nonatomic ,strong) UIView *backView;//图片背景
@property (nonatomic ,strong) UIButton *playBtn;//播放文字
@property (nonatomic, strong) BXTextScrollView *musicName;
@property(nonatomic,strong)BXHMovieModel *model;
@property (nonatomic , strong) UIButton *focusButton; //关注
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype) cellWithTableView :(UITableView *)tableView;

-(void)setDelegate:(id<BXAttentionVideoCelllDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

@end


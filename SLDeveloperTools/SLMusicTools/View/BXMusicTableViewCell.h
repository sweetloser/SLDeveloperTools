//
//  BXMusicTableViewCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXMusicTableViewCell : UITableViewCell

@property(nonatomic,strong)BXMusicModel *model;
/** 音乐图片 */
@property (nonatomic , strong) UIImageView *iconImageView;
/** 播放暂停图标 */
@property (nonatomic , strong) UIImageView *playPauseImageView;
/** 音乐名称 */
@property (nonatomic , strong) UILabel * musicLabel;
/** 昵称 */
@property (nonatomic , strong) UILabel * nameLabel;
/** 使用 */
@property (nonatomic , strong) UIButton * useBtn;
/** 收藏 */
@property (nonatomic , strong) UIButton * collectBtn;

@property(nonatomic,copy)void(^musicCollectBlock)();

@property(nonatomic,copy)void(^musicUseBlock)();

@end

NS_ASSUME_NONNULL_END

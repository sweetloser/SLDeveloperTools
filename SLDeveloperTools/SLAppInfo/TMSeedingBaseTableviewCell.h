//
//  BXDynBaseTableviewCell.h
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DynSharePopViewManager.h"
#import "BXInsetsLable.h"
#import "BXDynamicModel.h"
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN
@class TMSeedingBaseTableviewCell;
@protocol TMSEEDBaseCellDelegate <NSObject>
@optional
-(void)didClickUnfoldInCell:(TMSeedingBaseTableviewCell *)cell;
-(void)didClickMoreCell:(TMSeedingBaseTableviewCell *)cell;
-(void)didClicWhisperCell:(TMSeedingBaseTableviewCell *)cell;
-(void)didClickHeaderCell:(TMSeedingBaseTableviewCell *)cell;
-(void)didClickContentCell:(TMSeedingBaseTableviewCell *)cell type:(NSInteger)type;


/// cell点击时间
/// @param cell cell
/// @param type 类型 1：点击圈子  2:关注圈子  3：点击头像  4：悄悄话   5：喜欢   6:评论  7：分享  8:更多
-(void)didClickOperation:(TMSeedingBaseTableviewCell *)cell model:(BXDynamicModel *)model type:(NSInteger)type;
@end

@interface TMSeedingBaseTableviewCell : UITableViewCell
@property(nonatomic, strong)BXDynamicModel *model;
@property (nonatomic,copy)void(^DidClickItem)(NSInteger index);
@property(nonatomic, weak)id<TMSEEDBaseCellDelegate> delegate;


@property(nonatomic, strong)UIImageView *headerImage;//头像
@property(nonatomic, strong)UIImageView *genderImage;//性别
@property(nonatomic, strong)UILabel *namelable;//名字
@property(nonatomic, strong)UILabel *timelable;//时间
@property(nonatomic, strong)YYLabel *contentlable;//内容
@property(nonatomic, strong)UIView *concenterBackview;//主体内容背景
@property(nonatomic, strong)UIView *unfoldBtnbackview;
@property(nonatomic, strong)UILabel *unfoldBtn;//折叠/展开


@property(nonatomic, strong)UIImageView *addressimage;
@property(nonatomic, strong)UILabel *addressname;//地址


@property(nonatomic, strong)UIView *bottomview;//评论/点赞等
@property(nonatomic, strong)UIImageView *likeImage;
@property(nonatomic, strong)UILabel *likeNumlable;
@property(nonatomic, strong)UILabel *commentNumlable;

@property(nonatomic, assign)CGFloat contentHeight;
@property(nonatomic, assign)CGFloat lineHeight;
@property(nonatomic, assign)CGFloat lineCount;
@property(nonatomic, assign)BOOL unfoldflag;
 




-(void)initView;
-(void)setView;
-(void)updateCenterView;//更改中间视图
-(void)updateDownView;//更改底部view
-(void)UpdateCellLayout;

-(void)guanzhuAct;//关注

-(void)SkipPersonView;//个人主页
-(void)moreAct:(id)sender;//更多
-(void)shareAct:(id)sender;//分享
-(void)comAct:(id)sender;//评论
-(void)likeAct:(id)sender;//喜欢

-(void)imageAct:(id)sender;//图片

@end

NS_ASSUME_NONNULL_END

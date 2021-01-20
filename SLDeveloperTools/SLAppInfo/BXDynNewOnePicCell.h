//
//  BXDynNewOnePicCell.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynBaseTableviewCell.h"
//#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynNewOnePicCell : BXDynBaseTableviewCell
@property (copy, nonatomic) void (^DidPicIndex)(NSInteger index);
//@property(nonatomic, strong)BXDynamicModel *model;
@end

NS_ASSUME_NONNULL_END

//#import <UIKit/UIKit.h>
//#import "DynSharePopViewManager.h"
//#import "BXInsetsLable.h"
//#import "BXDynamicModel.h"
//NS_ASSUME_NONNULL_BEGIN
//@class BXDynNewOnePicCell;
//@protocol BXDynOneCellDelegate <NSObject>
//@optional
//-(void)didClickUnfoldInCell:(BXDynNewOnePicCell *)cell isUnfold:(BOOL)unfold;
//-(void)didClickMoreCell:(BXDynNewOnePicCell *)cell;
//-(void)didClicWhisperCell:(BXDynNewOnePicCell *)cell;
//-(void)didClickHeaderCell:(BXDynNewOnePicCell *)cell;
//-(void)didClickContentCell:(BXDynNewOnePicCell *)cell type:(NSInteger)type;
//
//@end
//
//@interface BXDynNewOnePicCell : UITableViewCell
//@property (nonatomic,copy)void(^DidClickItem)(NSInteger index);
//@property(nonatomic, weak)id<BXDynOneCellDelegate> delegate;
//@property(nonatomic, strong)BXDynamicModel *model;
//@property(nonatomic, strong)UIImageView *topHeaderImage;
//@property(nonatomic, strong)UILabel *topTitlelable;
//@property(nonatomic, strong)UILabel *topConcentlable;
//@property(nonatomic, strong)UIView *topView;
//
//@property(nonatomic, strong)UIImageView *headerImage;//头像
//@property(nonatomic, strong)UIImageView *whispersImage;//悄悄话
//@property(nonatomic, strong)UIImageView *genderImage;//性别
//@property(nonatomic, strong)UILabel *namelable;//名字
//@property(nonatomic, strong)UILabel *timelable;//时间
//@property(nonatomic, strong)BXInsetsLable *contentlable;//内容
//@property(nonatomic, strong)UIView *concenterBackview;//主体内容背景
//@property(nonatomic, strong)UIView *unfoldBtnbackview;
//@property(nonatomic, strong)UILabel *unfoldBtn;//折叠/展开
//
//
//@property(nonatomic, strong)UIImageView *addressimage;
//@property(nonatomic, strong)UILabel *addressname;//地址
//
//@property(nonatomic, strong)UIView *quanzibackview;//圈子
//@property(nonatomic, strong)UIImageView *quanziimage;
//@property(nonatomic, strong)UILabel *quanzititle;
//@property(nonatomic, strong)UILabel *quanzigaunzhu;
//
//@property(nonatomic, strong)UIView *bottomview;//评论/点赞等
//@property(nonatomic, strong)UIImageView *likeImage;
//@property(nonatomic, strong)UILabel *likeNumlable;
//@property(nonatomic, strong)UILabel *commentNumlable;
//
//@property(nonatomic, assign)CGFloat contentHeight;
//@property(nonatomic, assign)CGFloat lineHeight;
//@property(nonatomic, assign)CGFloat lineCount;
//@property(nonatomic, assign)BOOL unfoldflag;
//
//
//
//
//
//-(void)initView;
//-(void)setView;
//-(void)updateHeaderView;//更改头部视图
//-(void)updateCenterView;//更改中间视图
//-(void)updateDownView;//更改底部view
//-(void)UpdateCellLayout;
//
//-(void)guanzhuAct;//关注
//-(void)SkipPersonView;//个人主页
//-(void)moreAct:(id)sender;//更多
//-(void)shareAct:(id)sender;//分享
//-(void)comAct:(id)sender;//评论
//-(void)likeAct:(id)sender;//喜欢
//-(void)whispersAct:(id)sender;//悄悄话
//-(void)imageAct:(id)sender;//图片
//
//@end
//
//NS_ASSUME_NONNULL_END

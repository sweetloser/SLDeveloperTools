//
//  DetailBaseheaderView.h
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXInsetsLable.h"
#import "BXDynamicModel.h"
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HeaderDelegate <NSObject>
@optional
-(void)DidClickType:(NSInteger)type;
-(void)Didfold:(BXDynamicModel *)model;
@end

@interface DetailBaseheaderView : UIView
@property (copy, nonatomic) void (^Didfold)(BXDynamicModel *model);
@property(nonatomic, weak)id<HeaderDelegate> delegate;
@property(nonatomic, strong)UIImageView *topHeaderImage;
@property(nonatomic, strong)UILabel *topTitlelable;
@property(nonatomic, strong)UILabel *topConcentlable;
@property(nonatomic, strong)UIView *topView;

@property(nonatomic, strong)UILabel *NotCommentLable;
@property(nonatomic, strong)UILabel *allcommentLabel;

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

@property(nonatomic, strong)UIView *quanzibackview;//圈子
@property(nonatomic, strong)UIImageView *quanziimage;
@property(nonatomic, strong)UILabel *quanzititle;
@property(nonatomic, strong)UILabel *quanzigaunzhu;

@property(nonatomic, strong)UIView *bottomview;//评论/点赞等
@property(nonatomic, strong)UIImageView *likeImage;
@property(nonatomic, strong)UILabel *likeNumlable;
@property(nonatomic, strong)UILabel *commentNumlable;


@property(nonatomic, assign)CGFloat contentHeight;
@property(nonatomic, assign)CGFloat lineHeight;
@property(nonatomic, assign)CGFloat lineCount;
@property(nonatomic, assign)CGFloat headerheight;
@property(nonatomic, assign)BOOL unfoldflag;

@property(nonatomic, strong)BXDynamicModel *model;
-(void)initView;
-(void)updateCenterView;
@end

NS_ASSUME_NONNULL_END

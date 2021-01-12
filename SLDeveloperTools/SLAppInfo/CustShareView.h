//
//  CustShareView.h
//  BXlive
//
//  Created by bxlive on 2018/3/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustShareView;

@protocol CustomShareViewDelegate <NSObject>

- (void)easyCustomShareViewButtonAction:(CustShareView *)shareView title:(NSString *)title index:(NSInteger)index;
-(void)tapcancel;

@end

@interface CustShareView : UIView

@property (nonatomic,weak) id<CustomShareViewDelegate> delegate;
// 背景View
@property (nonatomic,strong) UIView *backView;
// 头部分享标题
@property (nonatomic,strong) UIView *headerView;
// 中间View,主要放分享
@property (nonatomic,strong) UIView *boderView;
// 中间分隔线
@property (nonatomic,strong) UILabel *middleLineLabel;
// 第一行分享媒介数量,分享媒介最多显示2行,如果第一行显示了全部则不显示第二行
@property (nonatomic,assign) NSInteger firstCount;
// 尾部其他自定义View
@property (nonatomic,strong) UIView *footerView;
// 取消
@property (nonatomic,strong) UIButton *cancleButton;
// 是否显示滚动条
@property (nonatomic,assign) BOOL showsHorizontalScrollIndicator;

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate;

- (float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count;

@end

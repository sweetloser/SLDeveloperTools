//
//  UIScrollView+Refresh.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "BXFooterView.h"

#define kFooterRefreshSpace 120

@interface UIScrollView (Refresh)

@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) BOOL isRefresh;
@property (assign, nonatomic) BOOL isNoMoreData;
@property (assign, nonatomic) BOOL isNoNetwork;

@property (strong, nonatomic) BXFooterView *hh_footerView;

/** 下拉刷新控件 */
@property (strong, nonatomic) MJRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) MJRefreshFooter *footer;
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;
/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)endRefreshingWithNoMoreData;

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

@end

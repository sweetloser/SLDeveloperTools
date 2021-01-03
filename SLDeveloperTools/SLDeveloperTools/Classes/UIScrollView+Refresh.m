//
//  UIScrollView+Refresh.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "BXRefreshHeader.h"
#import "BXRefreshFooter.h"

@interface UIScrollView ()

@end

@implementation UIScrollView (Refresh)

- (void)setHh_footerView:(UIView *)hh_footerView {
    objc_setAssociatedObject(self, @selector(hh_footerView), hh_footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hh_footerView {
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
//        WS(ws);
        __weak typeof(self) ws = self;
        BXFooterView *footerView = [[BXFooterView alloc]initWithScrollView:self];
        footerView.ignoredScrollViewContentInsetBottom = 0;
        footerView.contentSizeDidChange = ^{
            ws.isNoMoreData = ws.isNoMoreData;
        };
        footerView.hidden = YES;
        [self addSubview:footerView];
        self.hh_footerView = footerView;
        view = footerView;
    }
    return view;
}

- (void)setSection:(NSInteger)section {
    objc_setAssociatedObject(self, @selector(section), @(section), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)section {
    id objc = objc_getAssociatedObject(self, _cmd);
    if (objc) {
        return [objc integerValue];
    } else {
        self.section = -1;
        return self.section;
    }
}

- (void)setIsRefresh:(BOOL)isRefresh {
    objc_setAssociatedObject(self, @selector(isRefresh), @(isRefresh), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isRefresh {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsNoMoreData:(BOOL)isNoMoreData {
    objc_setAssociatedObject(self, @selector(isNoMoreData), @(isNoMoreData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSInteger totalCount = 0;
    if (self.section == -1) {
        totalCount = [self mj_totalDataCount];
    } else {
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            if (self.section < tableView.numberOfSections ) {
                totalCount = [tableView numberOfRowsInSection:self.section];
            }
            
        } else if ([self isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self;
            if (self.section < collectionView.numberOfSections ) {
                totalCount = [collectionView numberOfItemsInSection:self.section];
            }
        }
    }
    
    self.hh_footerView.hidden = !isNoMoreData || !totalCount;
    CGFloat contentHeight = self.mj_contentH + self.hh_footerView.ignoredScrollViewContentInsetBottom;
    CGFloat scrollHeight = self.mj_h  -  self.hh_footerView.scrollViewOriginalInset.bottom + self.hh_footerView.ignoredScrollViewContentInsetBottom;
//    NSLog(@"=============:%@",NSStringFromUIEdgeInsets(self.hh_footerView.scrollViewOriginalInset));
//    self.hh_footerView.scrollViewOriginalInset.top
    
    self.hh_footerView.frame = CGRectMake(0, MAX(contentHeight, scrollHeight), self.mj_w, 44);
}

- (BOOL)isNoMoreData {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsNoNetwork:(BOOL)isNoNetwork {
    objc_setAssociatedObject(self, @selector(isNoNetwork), @(isNoNetwork), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNoNetwork {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (MJRefreshHeader *)header
{
    return self.mj_header;
}

- (MJRefreshFooter *)footer
{
    return self.mj_footer;
}

- (void)addHeaderWithTarget:(id)target action:(SEL)action
{

    self.header = [BXRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    self.footer = [BXRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
    self.footer.ignoredScrollViewContentInsetBottom = 0;
}

- (void)headerBeginRefreshing
{

    [self.header beginRefreshing];
}

- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

- (void)endRefreshingWithNoMoreData
{

    [self.footer endRefreshingWithNoMoreData];
}


/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData
{
    [self.footer resetNoMoreData];
}

@end

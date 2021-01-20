//
//  BXRewardListView.m
//  BXlive
//
//  Created by bxlive on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXRewardListView.h"
#import "BXRewardListCell.h"
//#import "BXPersonHomeVC.h"
#import "UIApplication+ActivityViewController.h"
#import "NSObject+Tag.h"
#import "UIGestureRecognizer+Time.h"
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/Masonry.h>
#import "NewHttpManager.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"

@interface BXRewardListView () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation BXRewardListView

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithVideoId:(NSString *)videoId {
    if ([super init]) {
        _video_id = videoId;
        self.frame = CGRectMake(0, 0, __kWidth, __kHeight);
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [self addSubview:maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
        [maskView addGestureRecognizer:tap];
        
        CGFloat h = __ScaleWidth(629-34) + __kBottomAddHeight;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mj_h, self.mj_w, h)];
        [self addSubview:_contentView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [_contentView addGestureRecognizer:pan];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapeLayer;

        UIImageView *bgIv = [[UIImageView alloc]init];
        bgIv.image = CImage(@"rewardList_bg");
        [_contentView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(629));
        }];
        
        UIView *subContentView = [[UIView alloc]initWithFrame:CGRectMake(__ScaleWidth(15), __ScaleWidth(141), _contentView.mj_w - __ScaleWidth(30), __ScaleWidth(488)-__kBottomAddHeight)];
        subContentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:subContentView];
        
        UIBezierPath *subBezierPath = [UIBezierPath bezierPathWithRoundedRect:subContentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer* subShapeLayer = [[CAShapeLayer alloc] init];
        subShapeLayer.path = subBezierPath.CGPath;
        subContentView.layer.mask = subShapeLayer;
        
//        for (NSInteger i = 0; i < 2; i++) {
//            UIImageView *imageView = [[UIImageView alloc]init];
//            [_contentView addSubview:imageView];
//
//            if (i) {
//                imageView.image = CImage(@"rewardList_icon1");
//                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(215);
//                    make.height.mas_equalTo(168);
//                    make.top.mas_equalTo(7);
//                    make.left.mas_equalTo(19);
//                }];
//            } else {
//                imageView.image = CImage(@"rewardList_icon2");
//                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(148);
//                    make.height.mas_equalTo(66);
//                    make.top.mas_equalTo(34);
//                    make.right.mas_equalTo(-16);
//                }];
//            }
//        }
        
//        UIView *panIconView = [[UIView alloc] init];
//        panIconView.backgroundColor = [UIColor whiteColor];
//        panIconView.layer.cornerRadius = 2;
//        [_contentView addSubview:panIconView];
//        [panIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(44);
//            make.height.mas_equalTo(4);
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(8);
//        }];
        
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, subContentView.mj_w, __ScaleWidth(0))];
        _tableView = [[UITableView alloc]init];
        _tableView.tableHeaderView = headerView;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        [subContentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(__ScaleWidth(70));
        }];
        
        _offset = 0;
        [self loadData];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    if (_tableView.contentOffset.y > 0) {
        [sender setTranslation:CGPointZero inView:sender.view];
        return;
    } else {
        if (sender.state == UIGestureRecognizerStateBegan) {
            if (!CGRectContainsPoint(_tableView.frame, [sender locationInView:_contentView]) ) {
                sender.ds_Tag = 1;
            }
            sender.beginTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            if (sender.ds_Tag == 1) {
                [self action:sender];
            } else {
                if (_tableView.contentOffset.y <= 0) {
                    [self action:sender];
                }
            }
        } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
            if (sender.ds_Tag == 1) {
                sender.ds_Tag = 0;
            }
            _tableView.scrollEnabled = YES;
            double timeSp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            if (timeSp - sender.beginTime < 1.0 && _contentView.mj_y - self.mj_h + self.contentView.mj_h > 70) {
                [self closeAction];
            } else {
                [self adjustmentContentViewFrame];
            }
        }
        
    }
    [sender setTranslation:CGPointZero inView:sender.view];
}

- (void)action:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view];
    CGFloat y = _contentView.frame.origin.y + point.y;
    if (y < self.mj_h - self.contentView.mj_h) {
        y = self.mj_h - self.contentView.mj_h;
    }
    _contentView.mj_y = y;
}

- (void)adjustmentContentViewFrame {
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.mj_y = self.mj_h - self.contentView.mj_h;
    }];
}

-(void)loadData{
    [NewHttpManager videoGetRewardRank:_video_id offset:[NSString stringWithFormat:@"%ld",_offset] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            if (!self.offset) {
                [self.dataArray removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *dataArray = jsonDic[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    BXLiveUser *liveUser = [[BXLiveUser alloc]init];
                    [liveUser updateWithJsonDic:dic];
                    [self.dataArray addObject:liveUser];
                }
            } else {
                self.tableView.isNoMoreData = YES;
            }
            [self.tableView reloadData];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } failure:^(NSError *error) {
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

- (void)closeAction {
    [self removeFromSuperview];
}

- (void)show {
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.contentView.frame = CGRectMake(0, self.mj_h - self.contentView.mj_h, self.mj_w, self.contentView.mj_h);
    }];
}

#pragma - mark UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return __ScaleWidth(88);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXRewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BXRewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
   
    cell.liveUser = self.dataArray[indexPath.row];
    cell.num = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BXLiveUser *liveUser = self.dataArray[indexPath.row];
    if ([BXLiveUser isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":liveUser.user_id,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
        
//        [BXPersonHomeVC toPersonHomeWithUserId:liveUser.user_id isShow:nil nav:[[UIApplication sharedApplication] activityViewController].navigationController handle:nil];
    } else {
//        [BXCodeLoginVC toLoginViewControllerWithNav:[[UIApplication sharedApplication] activityViewController].navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":[UIApplication sharedApplication].activityViewController.navigationController}];
    }
    [self closeAction];
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.scrollEnabled && scrollView.contentOffset.y <= 0) {
        scrollView.scrollEnabled = NO;
    }
    
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
    if (point.y > 0 ) {
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height + kFooterRefreshSpace > scrollView.contentSize.height) {
        if (scrollView.isNoMoreData || scrollView.isNoNetwork) {
            return;
        }
        if (!scrollView.isRefresh) {
            scrollView.isRefresh = YES;
            _offset = self.dataArray.count;
            [self loadData];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = YES;
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            [ws loadData];
        };
        return noNetworkView;
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"这里还没有内容哦~";
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:MinorColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end

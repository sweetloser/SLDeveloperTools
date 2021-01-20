//
//  BXDynCircleVideoVC.m
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleVideoVC.h"
#import "BXDynTopicVideoCell.h"
#import "BXDynamicModel.h"
//#import "BXVideoPlayVC.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import "BXDynTopicCircleVideoVC.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "SLAppInfoMacro.h"
#import "NewHttpManager.h"
#import <Masonry/Masonry.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BXDynCircleVideoVC ()<UICollectionViewDataSource, UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger offset;
@property (nonatomic , assign) NSInteger page;

@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);

@end

@implementation BXDynCircleVideoVC

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewDidScroll = callback;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewDidScroll ? : self.listScrollViewDidScroll(scrollView);
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    NSLog(@"%f",point.y);
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
            [self loadMoreData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.collectionView.autoresizingMask = (0x1<<6) - 1;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.collectionView endRefreshingWithNoMoreData];
    [self.collectionView headerBeginRefreshing];
//    [self TableDragWithDown];
    
    [self.collectionView registerClass:[BXDynTopicVideoCell class] forCellWithReuseIdentifier:@"BXPersonVideoListCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(0));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-__ScaleWidth(0));
    }];
    
//    [self TableDragWithDown];
    
    
    self.scrollView = self.collectionView;
}

#pragma mark - 下拉刷新
- (void)TableDragWithDown {

    self.page = 0;
    [self createData];
   
}


#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.dataArray.ds_Tag;
    [self createData];
}


-(void)createData{
    [HttpMakeFriendRequest GetCircleListWithcircle_id:self.model.circle_id page_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"100" extend_type:@"2" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        NSLog(@"%@", jsonDic);
        if (flag) {
            if (!self.page) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.collectionView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.collectionView.isNoMoreData = NO;
            }
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && [dataArray1 isArray] && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynamicModel *model = [[BXDynamicModel alloc]init];
                    [model updateWithJsonDic:dic];
                    model.isHiddenCircle = YES;
                    [self.dataArray addObject:model];
                    
                }
                self.dataArray.ds_Tag++;
            }
            else {
                self.collectionView.isNoMoreData = YES;
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        
        
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = NO;
        [self.collectionView reloadData];
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXDynTopicVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXPersonVideoListCell" forIndexPath:indexPath];
    cell.dynModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//    vc.videos = self.dataArray;
//    vc.index = indexPath.row;
//    [self.nav pushViewController:vc animated:YES];

    BXDynTopicCircleVideoVC *vc = [[BXDynTopicCircleVideoVC alloc]init];
    vc.videos = self.dataArray;
    vc.index = indexPath.row;
    [self pushVc:vc];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-30 - __ScaleWidth(24))/3, (SCREEN_WIDTH-30 - __ScaleWidth(24))/3*287/181.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (void)didLogin{
    [self TableDragWithDown];
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            [ws TableDragWithDown];
        };
        return noNetworkView;
    }
}

#pragma - mark DZNEmptyDataSetSource
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

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

#pragma - mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}


@end

//
//  TMSeedingTopicVideoVC.m
//  BXlive
//
//  Created by mac on 2020/11/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMSeedingTopicVideoVC.h"
#import "BXDynTopicVideoCell.h"
#import "BXDynamicModel.h"
#import "BXHMovieModel.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
//#import "SLAmwayVideoShowVC.h"
#import "SLAmwayListModel.h"
#import <CTMediatorSLAmway/CTMediator+SLAmway.h>

@interface TMSeedingTopicVideoVC ()<UICollectionViewDataSource, UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property(nonatomic, strong)NSMutableArray *SLDataArray;
@property (assign, nonatomic) NSInteger offset;
@property (nonatomic , assign) NSInteger page;

@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);

@end

@implementation TMSeedingTopicVideoVC
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
    _SLDataArray = [NSMutableArray array];
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
    
    [self TableDragWithDown];
    
    
    self.scrollView = self.collectionView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undeleteChange:) name:kDeleteNotification object:nil];
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
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/topic/topicgoList" parameters:@{@"topic_id":_topic_id,@"render_type":@"7", @"page_index":[NSString stringWithFormat:@"%ld",(long)_page+1],@"page_size":@20} success:^(id  _Nonnull responseObject) {
        [BGProgressHUD hidden];
        if ([responseObject[@"code"] integerValue] == 0) {

            if (!self.page) {
                [self.dataArray removeAllObjects];
                [weakSelf.SLDataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.collectionView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.collectionView.isNoMoreData = NO;
            }
            NSArray *dataArray1 = responseObject[@"data"][@"list"];
            if (dataArray1 && [dataArray1 isArray] && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
                    [addDic setValue:dic forKey:@"msgdetail"];
                    BXDynamicModel *model = [[BXDynamicModel alloc]init];
                    [model updateWithJsonDic:addDic];
                    model.isHiddenCircle = YES;
                    [self.dataArray addObject:model];
                    
                    SLAmwayListModel *slmodel = [SLAmwayListModel mj_objectWithKeyValues:dic];
                    [weakSelf.SLDataArray addObject:slmodel];
                    
                }
                self.dataArray.ds_Tag++;
            }
            else {
                self.collectionView.isNoMoreData = YES;
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
        }
        
        
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = NO;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
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
    BXDynamicModel *model = _dataArray[indexPath.row];
    SLAmwayListModel *m = self.SLDataArray[indexPath.row];
    if ([model.msgdetailmodel.render_type intValue] == 7) {
        //        视频
        NSNumber *currentIndex = @0;
        NSMutableArray *modelList = [NSMutableArray new];
        for (SLAmwayListModel *model in self.SLDataArray) {
            if ([model.render_type integerValue] == 7) {
                [modelList addObject:model];
                if ([m isEqual:model]) {
                    currentIndex = @(modelList.count -1);
                }
            }
        }
        UIViewController *svc = [[CTMediator sharedInstance] SLAmwayVideoShowVC_ViewControllerWithModelList:modelList CurrentIndex:currentIndex];
        
        
        [self.navigationController pushViewController:svc animated:YES];
        return;
    }
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
-(void)undeleteChange:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *movieId = [NSString stringWithFormat:@"%@",info[@"movieId"]];
    for (BXDynamicModel *video in self.dataArray) {
        NSString *list_Id = [NSString stringWithFormat:@"%@",video.fcmid];
        if (IsEquallString(movieId, list_Id)) {
            [self.dataArray removeObject:video];
            [_collectionView reloadData];
            break;
        }
    }
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

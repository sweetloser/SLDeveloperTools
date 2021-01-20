//
//  BXSLSearchVideoVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchVideoVC.h"
#import "BXSLSearchVideoCell.h"
//#import "BXVideoPlayVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/Masonry.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "NewHttpManager.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "SLAppInfoConst.h"

@interface BXSLSearchVideoVC () <UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic , assign) NSInteger offset;

@end

@implementation BXSLSearchVideoVC

- (void)getVideos {
    [NewHttpManager globalSearchWithType:@"film" keyword:_searchResultVC.searchText offset:[NSString stringWithFormat:@"%ld",_offset] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [self.collectionView.mj_header endRefreshing];
        if(flag) {
            if (!self.offset){
                [self.videos removeAllObjects];
                self.collectionView.isNoMoreData = NO;
            }
            NSArray *dataArray = jsonDic[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    BXHMovieModel *video = [[BXHMovieModel alloc]init];
                    [video updateWithJsonDic:dic];
                    [self.videos addObject:video];
                }
            } else {
                self.collectionView.isNoMoreData = YES;
            }
            [self.collectionView reloadData];
        }
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = NO;
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    
}

- (void)listDidDisappear {
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _videos = [NSMutableArray array];
    
    [self initViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSearchAction) name:kNeedSearchNotification object:nil];
}

- (void)initViews {
    self.view.backgroundColor = PageBackgroundColor;;
    CGFloat itemW = (__kWidth - 12) / 2;
    CGFloat itemH = itemW * 287 / 181;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    layout.sectionInset = UIEdgeInsetsMake(8, 4 , 8, 4);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [_collectionView registerClass:[BXSLSearchVideoCell class] forCellWithReuseIdentifier:@"Cell"];
    
    WS(ws);
    BXRefreshHeader *header = [BXRefreshHeader headerWithRefreshingBlock:^{
        ws.offset = 0;
        [ws getVideos];
    }];
    _collectionView.mj_header = header;
    [_collectionView.mj_header beginRefreshing];
    
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXSLSearchVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.video = _videos[indexPath.row];
    return cell;
}

#pragma - mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BXHMovieModel *video = _videos[indexPath.row];
//    BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//    vc.videos = @[video];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2BXVideoPlayVC object:nil userInfo:@{@"vc":self,@"movie_models":@[video],@"index":@(0)}];
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
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
            _offset = _videos.count;
            [self getVideos];
        }
    }
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            ws.offset = 0;
            [ws getVideos];
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

#pragma - mark Notification
- (void)needSearchAction {
    [_collectionView.mj_header beginRefreshing];
}


@end

//
//  BXDynFindCircleMyVC.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynFindCircleMyVC.h"
#import "AddCirCleCell.h"
#import "BXDynCircleModel.h"
#import "BXDynRollCircleCategory.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"
#import <ZFPlayer/ZFPlayer.h>
#import <Masonry/Masonry.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface BXDynFindCircleMyVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , assign) BOOL isResh;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;

@end

@implementation BXDynFindCircleMyVC
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    [self createData];

}


#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.dataArray.ds_Tag;
    self.isResh = NO;
    [self createData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
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
            [self loadMoreData];
        }
    }
}
-(void)createData{
    [HttpMakeFriendRequest GetCircleWithCircle_type:@"2" page_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"20" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
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
                   if (dataArray1 && dataArray1.count) {
                       for (NSDictionary *dic in dataArray1) {
                           BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                           [model updateWithJsonDic:dic];
                           [self.dataArray addObject:model];
                           
                       }
                        self.dataArray.ds_Tag++;
                   }
               }else{
                   [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
               }
              
               [self.collectionView headerEndRefreshing];
               self.collectionView.isRefresh = NO;
               self.collectionView.isNoNetwork = NO;

               [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    [self setcollectionView];
    [self createData];
}
-(void)setcollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[AddCirCleCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
//    self.collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.collectionView endRefreshingWithNoMoreData];
    [self TableDragWithDown];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(74+__kTopAddHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset( - __kBottomAddHeight);
    }];


}

#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddCirCleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
    vc.isOwn = YES;
    BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
    model = self.dataArray[indexPath.row];
    model.isHiddenTop = YES;
    vc.model = model;
    [self pushVc:vc];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake( ( __ScaleWidth(375)  - 48 ) / 3, __ScaleWidth(153));

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 12;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 0;

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(12, 12, 12, 12);
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"还没有圈子哦";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
-(void)listDidAppear{
    [self createData];
}
@end

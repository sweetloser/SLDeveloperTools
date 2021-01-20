//
//  BXDynNearHeaderView.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNearHeaderView.h"
#import <Masonry/Masonry.h>
#import "BXDynNearHeaderCell.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynTopicModel.h"
#import "GHPageControl.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#define CollectionViewTag 111
static NSTimer *mv_timer;
@interface BXDynNearHeaderView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , assign) float viewWidth;
@property (nonatomic , assign) float viewHeight;

@property(nonatomic, strong)UIImageView *boyImage;
@property(nonatomic, strong)UIImageView *boy_genderImage;
@property(nonatomic, strong)UIImageView *girlImage;
@property(nonatomic, strong)UIImageView *girl_genderImage;
@property(nonatomic, strong)UIImageView *backImage;
@property(nonatomic, strong)UIImageView *coverImage;
@property(nonatomic, strong)UIImageView *dian_zanImage;

@property(nonatomic, strong)UILabel *girlnamelable;
@property(nonatomic, strong)UILabel *boylnamelable;
@property(nonatomic, strong)UILabel *dian_zanlable;
@property(nonatomic, strong)UILabel *contentlable;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic,strong)GHPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation BXDynNearHeaderView
- (id)initWithFrame:(CGRect)frame DataArray:(nonnull NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height - 20;
        _huatiArray = array;
//        MMKV *mmkv = [MMKV defaultMMKV];
//        _dataArray =  [mmkv getObjectOfClass:[NSMutableArray class] forKey:DynamicHomeHeaderPageNear];
//        if (!_dataArray) {
            _dataArray = [NSMutableArray array];
//        }
        BXDynTopicModel *model = [BXDynTopicModel new];
        model.topic_name = @"话题广场";
        model.dynamic = @"搜索更多话题";
        model.is_local_img = @"1";
        [_dataArray addObject:model];
        [self createCollectionView];
        [self getData];
    }
    return self;
}
-(void)getData{
    [HttpMakeFriendRequest GetTopicListWithpage_index:@"1" page_size:@"17" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            [self.dataArray removeAllObjects];
            BXDynTopicModel *model = [BXDynTopicModel new];
            model.topic_name = @"话题广场";
            model.dynamic = @"搜索更多话题";
            model.is_local_img = @"1";
            [self.dataArray addObject:model];
            NSArray *array = jsonDic[@"data"][@"data"];
            if (array.count) {
                for (NSDictionary *dic in array) {
                    BXDynTopicModel *model = [[BXDynTopicModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [self.dataArray addObject:model];
                    if (self.isHeaderData) {
                        self.isHeaderData();
                    }
                }
            }
            
            else{
                [self.collectionView reloadData];
                [self reloadPageData];
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"获取话题列表失败"];
    }];
}
-(void)createScrollView{
    [self addSubview:self.scrollView];
}
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 6, self.frame.size.width, self.frame.size.height - 40) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[BXDynNearHeaderCell class] forCellWithReuseIdentifier:@"BXDynNearCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    UILabel *downlinelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 8, self.frame.size.width, 8)];
    downlinelabel.backgroundColor = sl_subBGColors;
    [self addSubview:downlinelabel];
    
    self.pageControl = [[GHPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 10)];
    [self addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.currentPageIndicatorTintColor = UIColorHex(#FF2D52);
    self.pageControl.pageIndicatorTintColor = UIColorHex(#D8D8D8);
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}
-(void)pageChange:(GHPageControl *)page{
    
    
//    NSInteger index = _pageControl.currentPage;
//    [self.carousel scrollToItemAtIndex:index animated:YES];
//

//    [self stopScroll];
//
//    if (self.dataArray.count / 3 > 1) {
//        if (!_timer) {
//
//            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatePage) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//
//        }
//    }
}
-(void)updatePage{
    
//    NSInteger index = _carousel.currentItemIndex;
//    if (index<self.dataArray.count / 3 -1) {
//        index++;
//    }else
//    {
//        index=0;
//    }
//    [_carousel scrollToItemAtIndex:index animated:YES];
}
-(void)reloadPageData{
//    self.carousel.currentItemIndex = 1;
    self.pageControl.numberOfPages = self.dataArray.count / 6 ;
    self.pageControl.currentPage = 0;
//    if (!_timer) {
//        if (self.dataArray.count / 3>1) {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatePage) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        }
//    }
}
- (void)stopScroll {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count == 1) {
        return 0;
    }
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXDynNearHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXDynNearCell" forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        cell.indextype = @"1";
//    }else{
//        cell.indextype = @"0";
//    }
    cell.model = self.dataArray[indexPath.row];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(DidIndexClick:topicModel:)]) {
        [self.delegate DidIndexClick:indexPath.row topicModel:self.dataArray[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake( self.frame.size.width / 2.0, 50);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(5, 0, 0, 0);
    
}



-(void)setNewsArray:(NSMutableArray *)newsArray
{
    self.scrollView.contentSize = CGSizeMake(_viewWidth * newsArray.count, _viewHeight);
}

-(UIScrollView *)scrollView
{
    //设置scrollview
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [_scrollView setContentOffset:CGPointMake(0, _viewHeight)];
        [self addSubview:_scrollView];
        
        UIButton *scrollViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        scrollViewBtn.backgroundColor = [UIColor clearColor];
        [scrollViewBtn addTarget:self action:@selector(scrollViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:scrollViewBtn];
    }
    return _scrollView;
}

- (void)scrollViewBtnClick{

}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart)  //开启自动翻页
    {
        if (!mv_timer) {
            mv_timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFUNC:) userInfo:nil repeats:YES];
        }
    }
    else   //关闭自动翻页
    {
        if (mv_timer.isValid) {
            [mv_timer invalidate];
            mv_timer = nil;
        }
    }
}
#pragma mark 展示下一页
-(void)timerFUNC:(NSTimer *)timer
{
    float offset_Y = self.scrollView.contentOffset.y;
    offset_Y += _viewHeight;
    //正常的最终偏移量
    CGPoint resultPoint = CGPointMake(0, offset_Y);
    if (offset_Y == _viewHeight*(_huatiArray.count-1)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, offset_Y);
        } completion:^(BOOL finished) {
            self.scrollView.contentOffset = CGPointMake(0, self->_viewHeight);
        }];
    } else {//其他情况正常滑动
        [self.scrollView setContentOffset:resultPoint animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

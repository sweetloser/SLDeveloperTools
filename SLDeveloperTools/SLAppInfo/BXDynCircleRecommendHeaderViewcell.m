//
//  BXDynCircleHeaderView.m
//  BXlive
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleRecommendHeaderViewcell.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynFindCirlceVC.h"
#import "BXDynRollCircleCategory.h"
#import "BXDynCircleHeaderCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>
#import "../SLMaskTools/SLMaskTools.h"

@interface BXDynCircleRecommendHeaderViewcell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end
@implementation BXDynCircleRecommendHeaderViewcell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)initView{
    UILabel *recommendlabel = [[UILabel alloc]init];
    recommendlabel.text = @"推荐圈子";
    recommendlabel.font = [UIFont systemFontOfSize:16];
    recommendlabel.textAlignment = 0;
    recommendlabel.textColor = sl_textSubColors;
    
    UILabel *changeLabel = [[UILabel alloc]init];
    changeLabel.text = @"换一批";
    changeLabel.font = [UIFont systemFontOfSize:12];
    changeLabel.textColor = sl_textSubColors;
    UITapGestureRecognizer *changetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAct)];
    [changeLabel addGestureRecognizer:changetap];
    changeLabel.userInteractionEnabled = YES;

    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = sl_divideLineColor;

    UILabel *alllabel = [[UILabel alloc]init];
    alllabel.text = @"全部";
    alllabel.font = [UIFont systemFontOfSize:12];
    alllabel.textColor = sl_textSubColors;
    UITapGestureRecognizer *alltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AllAct)];
    [alllabel addGestureRecognizer:alltap];
    alllabel.userInteractionEnabled = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 6, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[BXDynCircleHeaderCell class] forCellWithReuseIdentifier:@"BXDynNearCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.contentView sd_addSubviews:@[recommendlabel, changeLabel,lineLabel,alllabel,self.collectionView]];
    recommendlabel.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 15).widthIs(80).heightIs(22);
    changeLabel.sd_layout.rightSpaceToView(self.contentView, 12).topEqualToView(recommendlabel).widthIs(42).heightIs(20);
    lineLabel.sd_layout.rightSpaceToView(changeLabel, 12).topEqualToView(changeLabel).widthIs(1).heightIs(20);
    alllabel.sd_layout.rightSpaceToView(lineLabel, 12).topEqualToView(changeLabel).widthIs(30).heightIs(20);
    self.collectionView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(alllabel, 10).rightSpaceToView(self.contentView, 0).heightIs(( __kWidth - 48 ) / 3  + 20 + 5 + 17 + 12);
    
    UILabel *downlinelabel = [[UILabel alloc]init];
     downlinelabel.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:0.99 alpha:1.00];
     [self.contentView sd_addSubviews:@[downlinelabel]];
    downlinelabel.sd_layout.topSpaceToView(self.collectionView, 10).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(8);
    [self setupAutoHeightWithBottomView:downlinelabel bottomMargin:8];
//__kWidth / 3 - 48 + 12 + 9 + 20 + 5 + 17 + 12

}
-(void)setArray:(NSArray *)array{
    _array = array;
    [self.dataArray removeAllObjects];
    if (_array.count) {
        for (int i = 0 ; i < _array.count; i++) {
            BXDynCircleModel *model = [BXDynCircleModel new];
            model = _array[i];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
    }
    _page = 0;
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count > 3) {
        return 3;
    }
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXDynCircleHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXDynNearCell" forIndexPath:indexPath];
    cell.backgroundColor = sl_subBGColors;
    cell.model = self.dataArray[indexPath.row];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.delegate respondsToSelector:@selector(DidIndexClick:topicModel:)]) {
//        [self.delegate DidIndexClick:indexPath.row topicModel:self.dataArray[indexPath.row]];
//    }
//        if (self.array.count >= 3) {

        BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
//        vc.isOwn = YES;
        BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
    //    [model updateWithJsonDic:self.array[2]];

        model.isHiddenTop = YES;
    vc.model = self.dataArray[indexPath.row];
        [self.viewController.navigationController pushViewController:vc animated:YES];
//        }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(( __kWidth - 48 ) / 3 ,  ( __kWidth - 48 ) / 3 + 20 + 5 + 17 + 12);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 12, 0, 12);
    
}

-(void)setModel:(BXDynCircleModel *)model{
    _model = model;
}

-(void)AllAct{
    BXDynFindCirlceVC *vc = [[BXDynFindCirlceVC alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
-(void)changeAct{
    _page++;
    [self getData];
}
-(void)getData{
    [HttpMakeFriendRequest CircleRecomedWithpage_index:[NSString stringWithFormat:@"%ld", (long)_page] page_size:@"3" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            NSArray *array = jsonDic[@"data"][@"data"];
            if (array && [array isArray] && array.count) {
                [self.dataArray removeAllObjects];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *dic = array[i];
                    if (dic && [dic isDictionary]) {
                        BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                        [model updateWithJsonDic:array[i]];
                        [self.dataArray addObject:model];
                    }
                    [self.collectionView reloadData];
                }
            }else{
                [BGProgressHUD showInfoWithMessage:@"没有更多数据了"];
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}


@end

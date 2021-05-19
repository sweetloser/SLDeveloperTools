//
//  SLNearByHeaderView.m
//  BXlive
//
//  Created by mac on 2020/9/26.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLNearByHeaderView.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
@interface SLNearByHeaderView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@interface SLNearByHeaderViewCell : UICollectionViewCell
@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *rowImage;
@property(nonatomic, strong)NSString *titleString;
@end

@implementation SLNearByHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    _dataArray = [NSMutableArray arrayWithObjects:@"位置",@"性别不限",@"年龄不限", nil];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.cellType = AlignWithLeft;
    //    layout.betweenOfCell = 25;
    //    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor cyanColor];
    self.collectionView.autoresizingMask = (0x1<<6) - 1;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[SLNearByHeaderViewCell class] forCellWithReuseIdentifier:@"SLNearByHeaderViewCell"];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.bottom.mas_equalTo(0);
//    }];
}

#pragma - mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SLNearByHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLNearByHeaderViewCell" forIndexPath:indexPath];
    cell.titleString = _dataArray[indexPath.row];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//sl_normalColors
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

        return CGSizeMake((__kWidth - 70) / 3, __ScaleWidth(50));

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return __ScaleWidth(20);
}
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, __ScaleWidth(15), 0, __ScaleWidth(15));
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation SLNearByHeaderViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = __ScaleWidth(15);
        self.backgroundColor = sl_subBGColors;
        [self createView];
    }
    return self;
}
-(void)setTitleString:(NSString *)titleString{
    [_btn setTitle:titleString forState:BtnNormal];
    _titleLabel.text = titleString;
}
-(void)createView{
//    /?s=Common.getRegionTree
//    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:_btn];
//    _btn.layer.masksToBounds = YES;
//    _btn.layer.cornerRadius = __ScaleWidth(15);
//    [_btn setBackgroundColor:sl_subBGColors];
//    [_btn setTitleColor:sl_normalColors forState:BtnSelected];
//    [_btn setTitleColor:sl_textSubColors forState:BtnNormal];
//    [_btn setImage:CImage(@"near_triangle_normal") forState:BtnNormal];
//    [_btn setImage:CImage(@"near_triangle_selected_down") forState:BtnSelected];
//    _btn.titleLabel.font = SLPFFont(__ScaleWidth(14));
//    [_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
//    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(__ScaleWidth(10));
//        make.bottom.mas_equalTo(__ScaleWidth(-10));
//    }];
    

    
    _rowImage = [[UIImageView alloc]init];
    _rowImage.image = CImage(@"near_triangle_normal");
    [self.contentView addSubview:_rowImage];
    [_rowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-5));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(__ScaleWidth(5));
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = sl_textSubColors;
    _titleLabel.font = SLPFFont(14);
    _titleLabel.textAlignment = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(5));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.rowImage.mas_left).offset(__ScaleWidth(-5));
    }];
    
}
@end

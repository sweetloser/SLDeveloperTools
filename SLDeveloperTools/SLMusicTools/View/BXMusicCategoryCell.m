//
//  BXMusicCategoryCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicCategoryCell.h"
#import "BXMusicCategoryModel.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYWebImage/YYWebImage.h>
#import <Lottie/Lottie.h>
//#import "HHMoviePlayVC.h"

@interface BXMusicCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger allNum;
@end

@interface DSMusicCategoryScrollViewCell : UICollectionViewCell
/** 图片 */
@property (nonatomic , strong) UIImageView * iconImageView;
/** 名称 */
@property (nonatomic , strong) UILabel * titleLabel;

@property (nonatomic,strong) BXMusicCategoryModel *models;
@end

@implementation BXMusicCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        [self.collectionView registerClass:[DSMusicCategoryScrollViewCell class] forCellWithReuseIdentifier:@"DSMusicCategoryScrollViewCell"];
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSMusicCategoryScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSMusicCategoryScrollViewCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        BXMusicCategoryModel *model = self.dataArray[indexPath.item];
        cell.models = model;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BXMusicCategoryModel *model = self.dataArray[indexPath.row];
    if ([_delegate respondsToSelector:@selector(pushCategoryDetailWithCategoryID:Title:)]) {
        [_delegate pushCategoryDetailWithCategoryID:[NSString stringWithFormat:@"%@",model.category_id] Title:model.title];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2.0, 48);
}

- (void)reloadData
{
    
    [self.collectionView reloadData];
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

@end

@implementation DSMusicCategoryScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
    }
    return self;
}

-(void)createView{
    _iconImageView = [[UIImageView alloc]init];
    _titleLabel = [UILabel initWithFrame:CGRectZero size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1];
    [self.contentView sd_addSubviews:@[_iconImageView,_titleLabel]];
    _iconImageView.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).widthIs(28).heightIs(28);
    _titleLabel.sd_layout.leftSpaceToView(_iconImageView, 12).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(SCREEN_WIDTH/2.0-56-16);
}

-(void)collectionBtnClick:(UIButton *)btn{
    
}

-(void)setModels:(BXMusicCategoryModel*)models{
    _models = models;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:models.icon] placeholder:[UIImage imageNamed:@""]];
    self.titleLabel.text = models.title;
}
@end

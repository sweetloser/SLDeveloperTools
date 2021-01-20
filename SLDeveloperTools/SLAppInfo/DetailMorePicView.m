//
//  DetailMorePicView.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailMorePicView.h"
#import "GongGeView.h"

#import "BXInsetsLable.h"
#import <Masonry.h>
#import "MorePicCollectionViewCell.h"
#import "HZPhotoBrowser.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>
#define ImageTag 111
@interface DetailMorePicView()<UICollectionViewDelegate,UICollectionViewDataSource, HZPhotoBrowserDelegate>
@property(nonatomic, strong)GongGeView *ggImageView;
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)HZPhotoBrowser *browser;
@end
@implementation DetailMorePicView
- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{

    _ggImageView = [[GongGeView alloc]init];
    [_ggImageView begainLayImage];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[MorePicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.concenterBackview addSubview:self.collectionView];
//1 2  2 0  3 3  4 0   5 0  6 0  7 0  8 3  9 9  10 6  11 2  13 0  14 3  15 0  16 0  17 0  18 0  19 3  20 9  21 6

}
-(void)updateCenterView{
    [self layoutIfNeeded];
    
    
    if ([self.model.msgdetailmodel.picture count] <= 3) {
        
        self.concenterBackview.sd_layout.heightIs((__ScaleWidth(375) - 48) / 3 );
    }else if ( [self.model.msgdetailmodel.picture count] <= 6){
        
        self.concenterBackview.sd_layout.heightIs((__ScaleWidth(375) - 48) / 3 * 2 + 12);
    }else{
        
        self.concenterBackview.sd_layout.heightIs((__ScaleWidth(375) - 48) + 24 );
    }
    
    
    if ([self.model.msgdetailmodel.picture count] == 4) {
        
        self.collectionView.frame = CGRectMake(0, 0, ( __ScaleWidth(375)  - 48 ) / 3 * 2 + 12, self.concenterBackview.frame.size.height);
        
    }else{
//        self.collectionView.frame = CGRectMake(0, 0, self.concenterBackview.frame.size.width, self.concenterBackview.frame.size.height);
        self.collectionView.sd_layout.topSpaceToView(self.concenterBackview, 0).leftSpaceToView(self.concenterBackview, 0).bottomSpaceToView(self.concenterBackview, 0).rightSpaceToView(self.concenterBackview, 0);
    }
    [self updateLayout];
    [self.collectionView reloadData];

}


#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return [self.model.msgdetailmodel.picture count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MorePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *picstr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",self.model.msgdetailmodel.picture[indexPath.row]];
    [cell.CoverimageView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:CImage(@"video-placeholder") options:SDWebImageProgressiveLoad];
    if (self.model.msgdetailmodel.imgs_detail.count) {
        if ([[self.model.msgdetailmodel.imgs_detail[indexPath.row] objectForKey:@"badge"] isEqualToString:@"gif"]) {
            cell.identificationImage.hidden = NO;
            cell.identificationImage.image = CImage(@"Image_type_gif");
        }
        else if ([[self.model.msgdetailmodel.imgs_detail[indexPath.row] objectForKey:@"badge"] isEqualToString:@"long"]) {
            cell.identificationImage.hidden = NO;
            cell.identificationImage.image = CImage(@"Image_type_long");
        }else{
            cell.identificationImage.hidden = YES;
        }
    }else{
        cell.identificationImage.hidden = YES;
     }

    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     _browser = [[HZPhotoBrowser alloc] init];
     _browser.isFullWidthForLandScape = YES;
     _browser.isNeedLandscape = NO;
    _browser.hiddenbottom = YES;
    _browser.delegate = self;
    _browser.fcmid = self.model.msgdetailmodel.fcmid;
    _browser.currentImageIndex = (int)indexPath.row;
    _browser.imageArray = self.model.msgdetailmodel.picture;
     [_browser show];
}
-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    MorePicCollectionViewCell *cell = (MorePicCollectionViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.CoverimageView.image;
}
-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
     if ([self.model.msgdetailmodel.picture[index] isKindOfClass:[UIImage class]]) {
         return nil;

    }else{
        NSString *img_url = self.model.msgdetailmodel.picture[index];
        return [NSURL URLWithString:img_url];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake( ( __ScaleWidth(375)  - 48 ) / 3, ( __ScaleWidth(375)  - 48 ) / 3);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 12;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 0;

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
@end

//
//  BXDynNewMorePicCell.m
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNewMorePicCell.h"
#import "GongGeView.h"

#import "BXInsetsLable.h"
#import <Masonry.h>
#import "MorePicCollectionViewCell.h"
#import "HZPhotoBrowser.h"
#import "BXDynamicDetailsVC.h"
#import "SDPhotoBrowser.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>

#define ImageTag 111
@interface BXDynNewMorePicCell()<UICollectionViewDelegate,UICollectionViewDataSource, HZPhotoBrowserDelegate>
@property(nonatomic, strong)GongGeView *ggImageView;
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)HZPhotoBrowser *browser;
@property(nonatomic, strong)NSString *MiniImage;
@end
@implementation BXDynNewMorePicCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{

//    _ggImageView = [[GongGeView alloc]init];
//    [_ggImageView begainLayImage];
    
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

}
-(void)updateCenterView{
    [self layoutIfNeeded];
    CGFloat width = __ScaleWidth(375);
//    CGFloat width = self.frame.size.width;
        if ([self.model.msgdetailmodel.picture count] <= 3) {

            self.concenterBackview.sd_layout.heightIs((width - 48) / 3 );
        }else if ( [self.model.msgdetailmodel.picture count] <= 6){

            self.concenterBackview.sd_layout.heightIs((width - 48) / 3 * 2 + 12);
        }else{

            self.concenterBackview.sd_layout.heightIs((width - 48) + 24);
        }


     if ([self.model.msgdetailmodel.picture count] == 4) {

         
              [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.top.bottom.mas_equalTo(0);
                  make.width.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3 * 2 + 12);
              }];

    }
     else{

         
         [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.right.top.bottom.mas_equalTo(0);
    
         }];
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
    if ([self.model.msgdetailmodel.picture count]) {
        if (self.model.msgdetailmodel.picture[indexPath.row] && ![self.model.msgdetailmodel.picture[indexPath.row] isEqualToString:@""]) {
            
            
            NSString *picstr = @"";
            //        picstr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",self.model.msgdetailmodel.picture[indexPath.row]];
            picstr = [NSString stringWithFormat:@"%@",self.model.msgdetailmodel.smallpicture[indexPath.row]];
            [cell.CoverimageView sd_setImageWithURL:[NSURL URLWithString:picstr]];
            
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
        }
    }
    


    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     _browser = [[HZPhotoBrowser alloc] init];
     _browser.isFullWidthForLandScape = YES;
     _browser.isNeedLandscape = NO;
    _browser.delegate = self;
    WS(weakSelf);
    _browser.DidClick = ^(NSInteger type) {
            NSInteger render_type = [weakSelf.model.msgdetailmodel.render_type integerValue];
        if (render_type == 0 || render_type == 10 ||render_type == 11 ||render_type == 1 ||render_type == 2 ||render_type == 3 ||render_type == 4 ||render_type == 6) {
            BXDynamicDetailsVC *vc = [[BXDynamicDetailsVC alloc]initWithType:weakSelf.model.msgdetailmodel.render_type model:weakSelf.model];
            vc.model = weakSelf.model;
            [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
        }
    };
    _browser.fcmid = self.model.msgdetailmodel.fcmid;
//    _browser.model = self.model;
    
    [_browser updateCommentNumlableText:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.comment_num]];
    [_browser updateLikeNumlableText:[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.like_num]];
   if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
       [_browser updateLikeImage:CImage(@"dyn_issue_liked")];
   }else{
       [_browser updateLikeImage:CImage(@"dyn_issue_like_whiteBack")];
   }
    
    _browser.currentImageIndex = (int)indexPath.row;
    _browser.imageArray = self.model.msgdetailmodel.picture;
    _browser.SmallImageArray = self.model.msgdetailmodel.smallpicture;
     [_browser show];
    
//    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
//    photoBrowser.delegate = self;
//    photoBrowser.browserStyle = SDPhotoBrowserStyleAll;
//    photoBrowser.currentImageIndex = indexPath.item;
//    photoBrowser.imageCount = self.model.msgdetailmodel.picture.count;
//    photoBrowser.sourceImagesContainerView = self.collectionView;
//    [photoBrowser show];
    
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

//-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    return [NSURL URLWithString:self.model.msgdetailmodel.smallpicture[index]];
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake( ( self.frame.size.width  - 48 ) / 3, ( self.frame.size.width  - 48 ) / 3);

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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

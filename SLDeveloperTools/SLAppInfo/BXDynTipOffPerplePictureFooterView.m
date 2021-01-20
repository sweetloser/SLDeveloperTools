//
//  BXDynTipOffPerplePictureFooterView.m
//  BXlive
//
//  Created by mac on 2020/9/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffPerplePictureFooterView.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import <Masonry/Masonry.h>
#import "AddPictureCell.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"

@interface BXDynTipOffPerplePictureFooterView()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate>
@property(nonatomic, strong)UILabel *textlabel;

@property(nonatomic, strong)UICollectionView *collectionView;
@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@end
@implementation BXDynTipOffPerplePictureFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSMutableArray array];
        [self initTextView];
        _AddPicArray = [[NSMutableArray alloc]init];
         [self.AddPicArray addObject:[UIImage imageNamed:@"dyn_issue_AddPic_tianJia_big"]];
    }
    return self;
}
-(void)initTextView{


        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[AddPictureCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3  + 24);
        }];
    
}


#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _AddPicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_AddPicArray.count) {
        if (indexPath.row == _AddPicArray.count - 1) {
            cell.type = @"1";
        }else{
            cell.type = @"0";
        }
    }
    WS(weakSelf);
    cell.picImage.image = _AddPicArray[indexPath.row];
    cell.DelPicture = ^{
        [weakSelf.AddPicArray removeObjectAtIndex:indexPath.row];
        if (weakSelf.AddPicArray.count == 1) {
//            [weakSelf.AddPicArray removeAllObjects];
        }
        [weakSelf.collectionView reloadData];
    };
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.AddPicArray.count - 1) {
//        [self ClickBtn:1];
        if (_AddPicArray.count > 1) {
            self.manager.type = HXPhotoManagerSelectedTypePhoto;
        }else{
            self.manager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
        }
        if (self.AddPicArray.count >= 4) {
            [BGProgressHUD showInfoWithMessage:@"超出照片最大选择数"];
            return;
        }
        
        [self.manager clearSelectedList];
        _manager.configuration.photoMaxNum = 4 - self.AddPicArray.count;
        self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
//        [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
//        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
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
    
    return UIEdgeInsetsMake(12, 12, 12, 12);
}
#pragma mark - 懒加载HXPhoto
//- (HXDatePhotoToolManager *)toolManager {
//    if (!_toolManager) {
//        _toolManager = [[HXDatePhotoToolManager alloc] init];
//    }
//    return _toolManager;
//}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.lookGifPhoto = YES;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.photoMaxNum = 3;
        _manager.configuration.singleSelected = NO;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = NO;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(500, 500);
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.themeColor = [UIColor colorWithHex:0xF92C56];
//        _manager.configuration.restoreNavigationBar = YES;
    }
    return _manager;
}
#pragma mark - 图片选择 代理方法
/**
 点击完成

 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
-(void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    NSLog(@"%@",allList);
    NSLog(@"%@",photoList);
    NSLog(@"%@",videoList);
    WS(ws);
    
    if (photoList.count) {

        [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            for (int i = 0; i < imageArray.count; i++) {
                UIImage *image = imageArray[i];
    //            [ws.AddPicArray addObject:image];
                [ws.AddPicArray insertObject:image atIndex:0];


            }

            [self.collectionView reloadData];
        }];
//    [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//
//        for (int i = 0; i < imageList.count; i++) {
//            UIImage *image = imageList[i];
////            [ws.AddPicArray addObject:image];
//            [ws.AddPicArray insertObject:image atIndex:0];
//
//
//        }
//
//        [self.collectionView reloadData];
//    } failed:^{
//
//    }];
    }
}
@end

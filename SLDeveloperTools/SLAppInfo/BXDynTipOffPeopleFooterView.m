//
//  BXDynTipOffPeopleFooterView.m
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffPeopleFooterView.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import "AddPictureCell.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXDynTipOffPeopleFooterView()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate>
@property(nonatomic, strong)UILabel *textlabel;

@property(nonatomic, strong)UICollectionView *collectionView;
@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@end
@implementation BXDynTipOffPeopleFooterView
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

    
     _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 335, 200)];
        _textView.layer.cornerRadius = 5;
//        [_textView becomeFirstResponder];
        _textView.layer.masksToBounds = YES;
    self.textView.backgroundColor =  UIColorHex(#F5F9FC);
        
        //文本
        _textView.text = @" 陈述理由(字数最多140个字)";
        //字体
//    _textView.placeholder = @" 陈述理由(字数最多140个字)";
        _textView.font = [UIFont systemFontOfSize:14];
        //对齐
        _textView.textAlignment = 0;
        //字体颜色
        _textView.textColor = [UIColor grayColor];
        //允许编辑
        _textView.editable = YES;
        //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
        _textView.userInteractionEnabled = YES; ///
        //自定义键盘
        //textView.inputView = view;//自定义输入区域
        //textView.inputAccessoryView = view;//键盘上加view
        _textView.delegate = self;
        [self addSubview:_textView];
        
        _textView.scrollEnabled = YES;//滑动
        _textView.returnKeyType = UIReturnKeyDone;//返回键类型
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    //    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;//数据类型连接模式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错方式
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大写方式
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.height.mas_equalTo(150);
    }];
    
    _textlabel = [[UILabel alloc]init];
    _textlabel.textAlignment = 2;
    _textlabel.textColor = UIColorHex(#FF2D52);
    _textlabel.text = @"0/140";
    _textlabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_textlabel];
    [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-22);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(-25);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
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
            make.top.mas_equalTo(self.textlabel.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3  + 24);
        }];
    
}
-(void)setIsText:(BOOL)isText{
    if (isText) {
        _textlabel.hidden = NO;
//        _textView.hidden = NO;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.right.mas_equalTo(self.mas_right).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(5);
            make.height.mas_equalTo(150);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textlabel.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3  + 24);
        }];
    }else{
        _textlabel.hidden = YES;
//        _textView.hidden = YES;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.right.mas_equalTo(self.mas_right).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(5);
            make.height.mas_equalTo(0);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textlabel.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3  + 24);
        }];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
\

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  

    if ([text isEqualToString:@"\n"]){
        //禁止输入换行
        return NO;
    }
    
    return YES;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @" 陈述理由(字数最多140个字)";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@" 陈述理由(字数最多140个字)"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    if ([self.delegate respondsToSelector:@selector(GetTipOffText: picArray:)]) {
        [self.delegate GetTipOffText:textView.text picArray:self.picArray];
    }
    _textlabel.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)textView.text.length];
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

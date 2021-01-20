//
//  BXDynCircleManagerVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleManagerVC.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import "BXDynChangeCircleNameVC.h"
#import "BXDynChangeCircleDesVC.h"
#import "BXDynCircleDisAlert.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynCircleChangeAlert.h"
#import "FilePathHelper.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
#import "SLUpLoadAndDownloadTools.h"

@interface BXDynCircleManagerVC ()<HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate>
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property(nonatomic, strong)UILabel *circleNameLabel;
@property(nonatomic, strong)UILabel *circleDesLabel;
@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UILabel *circleCreateTimeLabel;

@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (assign, nonatomic) NSInteger viewFlag;
@end

@implementation BXDynCircleManagerVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self setNavView];
    [self initItemView];
    [self initbottomView];

}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"圈子管理";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    
    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.width.mas_equalTo(__ScaleWidth(72/4*6));
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_navView.mas_bottom).offset(-22);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];


}
-(void)initItemView{

    
    UIView *circleNameView = [[UIView alloc]init];
    UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNameAct)];
    [circleNameView addGestureRecognizer:nametap];
    circleNameView.userInteractionEnabled = YES;
    [self.view addSubview:circleNameView];
    [circleNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(5);
    }];
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"圈子名称";
    nameLabel.textColor = UIColorHex(#8C8C8C);
    nameLabel.font = [UIFont systemFontOfSize:14];
    [circleNameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleNameView.mas_centerY);
        make.left.mas_equalTo(circleNameView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    UIImageView *rowNameImageView = [[UIImageView alloc]init];
    rowNameImageView.image = CImage(@"箭头下一步");
    [circleNameView addSubview:rowNameImageView];
    [rowNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(circleNameView.mas_right).offset(-12);
        make.centerY.mas_equalTo(circleNameView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _circleNameLabel = [[UILabel alloc]init];
    _circleNameLabel.text = self.model.circle_name;
    _circleNameLabel.textAlignment = 2;
    _circleNameLabel.textColor = UIColorHex(#282828);
    _circleNameLabel.font = [UIFont systemFontOfSize:14];
    [circleNameView addSubview:_circleNameLabel];
    [_circleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleNameView.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).offset(12);
        make.right.mas_equalTo(rowNameImageView.mas_left).offset(-12);
        make.height.mas_equalTo(20);
    }];
    
    UIView *circleDesView = [[UIView alloc]init];
    UITapGestureRecognizer *destap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeDesAct)];
    [circleDesView addGestureRecognizer:destap];
    circleDesView.userInteractionEnabled = YES;
    [self.view addSubview:circleDesView];
    [circleDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(circleNameView.mas_bottom).offset(15);
    }];
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = @"圈子描述";
    desLabel.textColor = UIColorHex(#8C8C8C);
    desLabel.font = [UIFont systemFontOfSize:14];
    [circleDesView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleDesView.mas_centerY);
        make.left.mas_equalTo(circleDesView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    UIImageView *rowDelImageView = [[UIImageView alloc]init];
    rowDelImageView.image = CImage(@"箭头下一步");
    [circleDesView addSubview:rowDelImageView];
    [rowDelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(circleDesView.mas_right).offset(-12);
        make.centerY.mas_equalTo(circleDesView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _circleDesLabel = [[UILabel alloc]init];
    _circleDesLabel.text = self.model.circle_describe;
    _circleDesLabel.textAlignment = 2;
    _circleDesLabel.textColor = UIColorHex(#282828);
    _circleDesLabel.font = [UIFont systemFontOfSize:14];
    [circleDesView addSubview:_circleDesLabel];
    [_circleDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleDesView.mas_centerY);
        make.left.mas_equalTo(desLabel.mas_right).offset(50);
        make.right.mas_equalTo(rowDelImageView.mas_left).offset(-12);
        make.height.mas_equalTo(20);
    }];
    
    
    
    UIView *coverView = [[UIView alloc]init];
    UITapGestureRecognizer *covertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverAct)];
    [coverView addGestureRecognizer:covertap];
    coverView.userInteractionEnabled = YES;
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(circleDesView.mas_bottom).offset(15);
    }];
    
    UILabel *upCoverLabel = [[UILabel alloc]init];
    upCoverLabel.text = @"圈子封面";
    upCoverLabel.textColor = UIColorHex(#8C8C8C);
    upCoverLabel.font = [UIFont systemFontOfSize:14];
    [coverView addSubview:upCoverLabel];
    [upCoverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(coverView.mas_centerY);
        make.left.mas_equalTo(coverView.mas_left).offset(12);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *rowCoverImageView = [[UIImageView alloc]init];
    rowCoverImageView.image = CImage(@"箭头下一步");
    [coverView addSubview:rowCoverImageView];
    [rowCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(coverView.mas_right).offset(-12);
        make.centerY.mas_equalTo(coverView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _coverImageView = [[UIImageView alloc]init];
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.contentMode=UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds=YES;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:self.model.circle_cover_img] placeholderImage:CImage(@"video-placeholder")];
    [coverView addSubview:_coverImageView];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rowCoverImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(coverView.mas_centerY);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    
    UIView *backgroundView = [[UIView alloc]init];
    UITapGestureRecognizer *backtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewAct)];
    [backgroundView addGestureRecognizer:backtap];
    backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(coverView.mas_bottom).offset(15);
    }];
    
    UILabel *upBackgroundLabel = [[UILabel alloc]init];
    upBackgroundLabel.text = @"背景背景图";
    upBackgroundLabel.textColor = UIColorHex(#8C8C8C);
    upBackgroundLabel.font = [UIFont systemFontOfSize:14];
    [backgroundView addSubview:upBackgroundLabel];
    [upBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.left.mas_equalTo(backgroundView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *rowbackImageView = [[UIImageView alloc]init];
    rowbackImageView.image = CImage(@"箭头下一步");
    [backgroundView addSubview:rowbackImageView];
    [rowbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backgroundView.mas_right).offset(-12);
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _backImageView = [[UIImageView alloc]init];
    _backImageView.layer.cornerRadius = 5;
    _backImageView.layer.masksToBounds = YES;
    _backImageView.contentMode=UIViewContentModeScaleAspectFill;
    _backImageView.clipsToBounds=YES;
     [_backImageView sd_setImageWithURL:[NSURL URLWithString:self.model.circle_background_img] placeholderImage:CImage(@"video-placeholder")];
    [backgroundView addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rowbackImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    UIView *circleTimeView = [[UIView alloc]init];
    [self.view addSubview:circleTimeView];
    [circleTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(backgroundView.mas_bottom).offset(15);
    }];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"创建时间";
    timeLabel.textColor = UIColorHex(#8C8C8C);
    timeLabel.font = [UIFont systemFontOfSize:14];
    [circleTimeView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleTimeView.mas_centerY);
        make.left.mas_equalTo(circleTimeView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    UIImageView *rowTimeImageView = [[UIImageView alloc]init];
    rowTimeImageView.image = CImage(@"箭头下一步");
    [circleTimeView addSubview:rowTimeImageView];
    [rowTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(circleTimeView.mas_right).offset(-12);
        make.centerY.mas_equalTo(circleTimeView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _circleCreateTimeLabel = [[UILabel alloc]init];
    _circleCreateTimeLabel.text = self.model.ctime;
    _circleCreateTimeLabel.textAlignment = 2;
    _circleCreateTimeLabel.textColor = UIColorHex(#8C8C8C);
    _circleCreateTimeLabel.font = [UIFont systemFontOfSize:14];
    [circleTimeView addSubview:_circleCreateTimeLabel];
    [_circleCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(circleTimeView.mas_centerY);
        make.left.mas_equalTo(timeLabel.mas_right).offset(50);
        make.right.mas_equalTo(rowTimeImageView.mas_left).offset(-12);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *HintLabel = [[UILabel alloc]init];
    HintLabel.text = @"提示:30天内仅能修改一次街区信息";
    HintLabel.textColor = UIColorHex(#B2B2B2);
    HintLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:HintLabel];
    [HintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(240);
        make.top.mas_equalTo(circleTimeView.mas_bottom).offset(100);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *DisBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    DisBtn.backgroundColor = UIColorHex(#F5F9FC);
    DisBtn.layer.masksToBounds = YES;
    DisBtn.layer.cornerRadius = 22;
    [DisBtn setTitle:@"解散圈子" forState:UIControlStateNormal];
    [DisBtn addTarget:self action:@selector(DisCircleAct) forControlEvents:UIControlEventTouchUpInside];
    [DisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    DisBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:DisBtn];
    [DisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HintLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(48);
    }];
    
    
}
-(void)initbottomView{
    
}
-(void)backClick{
    if (self.ChangeModel) {
        self.ChangeModel(self.model);
        [self pop];
    }
    else{
        [self pop];
    }
}
-(void)coverAct{
    
    _viewFlag = 0;
    [self.manager clearSelectedList];
    BXDynCircleChangeAlert *alert = [[BXDynCircleChangeAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alert.DidClickBlock = ^{
        [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
    };
    [alert showWithView:self.view];
}
-(void)backgroundViewAct{
    _viewFlag = 1;
    [self.manager clearSelectedList];
    BXDynCircleChangeAlert *alert = [[BXDynCircleChangeAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alert.DidClickBlock = ^{
        [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
    };
    [alert showWithView:self.view];
}
-(void)UpdataImage:(UIImage *)image{

    NSData *data = UIImageJPEGRepresentation(image, .8);
    NSString *path = [self getImageFilePath:data];
    [BGProgressHUD showLoadingAnimation];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            [self ChangeImage:jsonDic[@"filePath"] Image:image];
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"图片上传失败"];
    }];
}
-(void)ChangeImage:(NSString *)imagepath Image:(UIImage *)image{
    [BGProgressHUD showLoadingAnimation];
    WS(weakSelf);
    NSString *describe = self.model.circle_describe;
    NSString *coverimg = self.model.circle_cover_img;
    NSString *backimg = self.model.circle_background_img;
    if (_viewFlag == 0) {
        coverimg = imagepath;
    }
    if (_viewFlag == 1) {
        backimg = imagepath;
    }

    [HttpMakeFriendRequest ModifyCircleWithcircle_id:self.model.circle_id circle_name:self.model.circle_name circle_describe:describe circle_cover_img:coverimg circle_background_img:backimg Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            if (weakSelf.viewFlag == 0) {
                weakSelf.coverImageView.image = image;
            }
            if (weakSelf.viewFlag == 1) {
                weakSelf.backImageView.image = image;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCircleChangeModelNotification object:nil userInfo:nil];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
-(void)changeNameAct{
    WS(weakSelf);
    BXDynChangeCircleNameVC *vc = [[BXDynChangeCircleNameVC alloc]init];
    vc.model = self.model;
    vc.ChangeName = ^(NSString * _Nonnull circle_name) {
        weakSelf.circleNameLabel.text = circle_name;
        weakSelf.model.circle_name = circle_name;
    };
    [self pushVc:vc];
}
-(void)changeDesAct{
    WS(weakSelf);
    BXDynChangeCircleDesVC *vc = [[BXDynChangeCircleDesVC alloc]init];
    vc.model = self.model;
    vc.ChangeDes = ^(NSString * _Nonnull circle_describe) {
        weakSelf.circleDesLabel.text = circle_describe;
        weakSelf.model.circle_describe = circle_describe;
    };
    [self pushVc:vc];
}
-(void)DisCircleAct{
    BXDynCircleDisAlert *alert = [[BXDynCircleDisAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight) title:self.model.circle_name];
    alert.DidClickBlock = ^{
        [HttpMakeFriendRequest DissolveCircleWithcircle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                [self pop];
                if (self.DissolveCircle) {
                    self.DissolveCircle();
                }
            }else{
            }
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD showInfoWithMessage:@"操作失败"];
        }];
    };
    [alert showWithView:self.view];
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
        _manager.configuration.lookGifPhoto = NO;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.singleSelected = YES;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = NO;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(500, 200);
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.themeColor = [UIColor sl_colorWithHex:0xF92C56];
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
    [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        if (ws.viewFlag == 0) {
            ws.coverImageView.image = [imageArray lastObject];
            [ws UpdataImage:[imageArray lastObject]];
        }else{
             ws.backImageView.image = [imageArray lastObject];
            [ws UpdataImage:[imageArray lastObject]];
        }
    }];
//    [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//
//            //        NSData *data = UIImageJPEGRepresentation(image, .8);
//            //        NSString *filePath = [self getImageFilePath:data];
//        if (ws.viewFlag == 0) {
//            ws.coverImageView.image = [imageList lastObject];
//            [ws UpdataImage:[imageList lastObject]];
//        }else{
//             ws.backImageView.image = [imageList lastObject];
//            [ws UpdataImage:[imageList lastObject]];
//        }
//    } failed:^{
//
//    }];
}
//获取暂时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData {
    NSString *path = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"addPicture_cover.jpg"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

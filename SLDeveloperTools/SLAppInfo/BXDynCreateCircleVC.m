//
//  BXDynCreateCircleVC.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//
//    icon_dyn_cirlce_add_detail
#import "BXDynCreateCircleVC.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HPGrowingTextView.h"
#import "BXDynCheckCircleVC.h"
#import "FilePathHelper.h"
#import "HttpMakeFriendRequest.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "SLUpLoadAndDownloadTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
@interface BXDynCreateCircleVC ()<UITextFieldDelegate,HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate,HPGrowingTextViewDelegate, UITextViewDelegate>
@property (nonatomic , strong) UIView * navView;
@property(nonatomic, strong)UITextField *Nametextfield;
//@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property(nonatomic, strong)UITextView *textView;

@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)UIImageView *bigCoverImageView;
@property(nonatomic, strong)UIImageView *backImageView;

@property(nonatomic, strong)NSString *coverurlString;
@property(nonatomic, strong)NSString *backurlString;

@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (assign, nonatomic) NSInteger viewFlag;
@end

@implementation BXDynCreateCircleVC
- (void)viewDidAppear:(BOOL)animated {
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
//    icon_dyn_cirlce_add_detail
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    [self setTopBackView];
    [self setNavView];
    [self setcontentView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"确认创建" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = UIColorHex(#FF2D52);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 25;
    [button addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(44);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)setTopBackView{
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 280)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorHex(#FC579A).CGColor, (__bridge id)UIColorHex(#FF887B).CGColor];
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = topBackView.bounds;
    [topBackView.layer insertSublayer:gradientLayer atIndex:0];
    [self.view addSubview:topBackView];

    _bigCoverImageView = [[UIImageView alloc]init];
    _bigCoverImageView.image = CImage(@"icon_dyn_cirlce_add_detail");
    _bigCoverImageView.layer.masksToBounds = YES;
    _bigCoverImageView.layer.cornerRadius = 12;
    UITapGestureRecognizer *covertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverAct)];
    [_bigCoverImageView addGestureRecognizer:covertap];
    _bigCoverImageView.userInteractionEnabled = YES;
    [topBackView addSubview:_bigCoverImageView];
    [_bigCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.view.mas_top).offset(97);
        make.width.height.mas_equalTo(86);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"街区名称";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    titleLabel.textColor = [UIColor whiteColor];
    [topBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bigCoverImageView.mas_right).offset(20);
        make.top.mas_equalTo(topBackView.mas_top).offset(117);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = @"一句话描述你的街区";
    desLabel.textColor = UIColorHex(#F8F8F8);
    desLabel.font = [UIFont systemFontOfSize:14];
    [topBackView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(3);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(20);
    }];
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"创建圈子";
    _viewTitlelabel.textColor =[UIColor whiteColor];
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_white") forState:BtnNormal];
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
-(void)setcontentView{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 12;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(211);
        make.bottom.left.right.mas_equalTo(0);
    }];
    
    UILabel *streetNameLabel = [[UILabel alloc]init];
    streetNameLabel.text = @"街区名称";
    streetNameLabel.font = [UIFont systemFontOfSize:14];
    streetNameLabel.textColor = [UIColor blackColor];
    [backView addSubview:streetNameLabel];
    [streetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(backView.mas_top).offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    _Nametextfield = [[UITextField alloc]init];
    _Nametextfield.delegate = self;
    _Nametextfield.layer.masksToBounds = YES;
    _Nametextfield.layer.cornerRadius = 5;
    _Nametextfield.placeholder = @"给街区取个名字吧(最多12个字)";
    _Nametextfield.font = [UIFont systemFontOfSize:14];
    _Nametextfield.backgroundColor = UIColorHex(#F5F9FC);
    _Nametextfield.textColor = [UIColor blackColor];
//    [self.Nametextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:_Nametextfield];
    [_Nametextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(streetNameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(-12);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *streetDesLabel = [[UILabel alloc]init];
    streetDesLabel.text = @"街区描述";
    streetDesLabel.font = [UIFont systemFontOfSize:14];
    streetDesLabel.textColor = [UIColor blackColor];
    [backView addSubview:streetDesLabel];
    [streetDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(_Nametextfield.mas_bottom).offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
//    self.growingTextView = [[HPGrowingTextView alloc]init];
//    self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
//    self.growingTextView.minHeight = 48;
//    self.growingTextView.delegate = self;
//    self.growingTextView.backgroundColor = UIColorHex(#F5F9FC);
//    self.growingTextView.textColor = [UIColor blackColor];
//    self.growingTextView.font = CFont(14);
//    self.growingTextView.minNumberOfLines = 1;
//    self.growingTextView.maxNumberOfLines = 10;
//    self.growingTextView.animateHeightChange = YES;
//    self.growingTextView.placeholder = @"给街区取个名字吧(最多60个字)";
//    self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
//    self.growingTextView.returnKeyType = UIReturnKeySend;
//    self.growingTextView.enablesReturnKeyAutomatically = YES;
//    [backView addSubview:self.growingTextView];
//    [self.growingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(backView.mas_left).offset(12);
//        make.top.mas_equalTo(streetDesLabel.mas_bottom).offset(5);
//        make.right.mas_equalTo(backView.mas_right).offset(-12);
//        make.height.mas_equalTo(48);
//    }];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 335, 200)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    self.textView.backgroundColor =  UIColorHex(#F5F9FC);
    
    _textView.text = @" 描述一下你的街区吧(最多60个字)";
    _textView.font = [UIFont systemFontOfSize:14];
    
    _textView.textAlignment = 0;
    _textView.textColor = [UIColor grayColor];
    _textView.editable = YES;
    _textView.userInteractionEnabled = YES; ///
    _textView.delegate = self;
    [backView addSubview:_textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(streetDesLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(-12);
        make.height.mas_equalTo(48);
    }];

    
    UILabel *OtherLabel = [[UILabel alloc]init];
    OtherLabel.text = @"其他设置";
    OtherLabel.font = [UIFont systemFontOfSize:14];
    OtherLabel.textColor = [UIColor blackColor];
    [backView addSubview:OtherLabel];
    [OtherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(12);
        make.top.mas_equalTo(_textView.mas_bottom).offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    UIView *coverView = [[UIView alloc]init];
    UITapGestureRecognizer *covertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverAct)];
    [coverView addGestureRecognizer:covertap];
    coverView.userInteractionEnabled = YES;
    [backView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(OtherLabel.mas_bottom).offset(15);
    }];
    
    UILabel *upCoverLabel = [[UILabel alloc]init];
    upCoverLabel.text = @"上传封面";
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
    [backView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(coverView.mas_bottom).offset(15);
    }];
    
    UILabel *upBackgroundLabel = [[UILabel alloc]init];
    upBackgroundLabel.text = @"上传背景";
    upBackgroundLabel.textColor = UIColorHex(#8C8C8C);
    upBackgroundLabel.font = [UIFont systemFontOfSize:14];
    [backgroundView addSubview:upBackgroundLabel];
    [upBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.left.mas_equalTo(backgroundView.mas_left).offset(12);
        make.width.mas_equalTo(60);
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
    [backgroundView addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rowbackImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    
}
-(void)coverAct{
    
    _viewFlag = 0;
    [self.manager clearSelectedList];
    //    self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
    //    [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    WS(ws);
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        [photoList hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            ws.coverImageView.image = [imageArray lastObject];
            ws.bigCoverImageView.image = [imageArray lastObject];
        }];
//        [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//            ws.coverImageView.image = [imageList lastObject];
//            ws.bigCoverImageView.image = [imageList lastObject];
//        } failed:^{
//            
//        }];
        
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        
    }];
}
-(void)backgroundViewAct{
    _viewFlag = 1;
    [self.manager clearSelectedList];
//    self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
//    [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    WS(ws);
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            ws.backImageView.image = [imageArray lastObject];
        }];
//        [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//            ws.backImageView.image = [imageList lastObject];
//        } failed:^{
//
//        }];
        
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        
    }];
}
-(void)createClick{
    if ([self.Nametextfield.text isEqualToString:@""]) {
        [BGProgressHUD showInfoWithMessage:@"请给街区起个名字"];
        return;
    }
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:@" 描述一下你的街区吧(最多60个字)"]) {
        [BGProgressHUD showInfoWithMessage:@"请描述一下你的街区"];
        return;
    }
    if (!self.coverImageView.image) {
        [BGProgressHUD showInfoWithMessage:@"请上传封面"];
        return;
    }
    if (!self.backImageView.image) {
        [BGProgressHUD showInfoWithMessage:@"请上传背景"];
        return;
    }
    UIImage *img = self.coverImageView.image;
    NSData *data = UIImageJPEGRepresentation(img, .8);
    NSString *path = [self getImageFilePath:data fileName:@"cover.jpg"];
    [BGProgressHUD showLoadingAnimation];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            self.coverurlString = jsonDic[@"filePath"];
            [self uploadingImage];
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"服务异常，创建失败"];
    }];
}
-(void)uploadingImage{
    UIImage *img = self.backImageView.image;
    NSData *data = UIImageJPEGRepresentation(img, .8);
    NSString *path = [self getImageFilePath:data fileName:@"back.jpg"];
    [BGProgressHUD showLoadingAnimation];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            self.backurlString = jsonDic[@"filePath"];
            [self createCircle];
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"服务异常，创建失败"];
    }];
}
-(void)createCircle{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest CreateCircleWithcircle_name:self.Nametextfield.text circle_describe:self.textView.text circle_cover_img:self.coverurlString circle_background_img:self.backurlString Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
//            BXDynCheckCircleVC *vc = [[BXDynCheckCircleVC alloc]init];
//            BXDynCircleModel *model = [BXDynCircleModel new];
//            model.circle_cover_img = self.coverurlString;
//            model.circle_background_img = self.backurlString;
//            model.circle_name = self.Nametextfield.text;
//            model.circle_describe = self.textView.text;
//            model.nickname = [BXLiveUser currentBXLiveUser].nickname;
//            model.avatar = [ BXLiveUser currentBXLiveUser].avatar;
//            model.user_id = [BXLiveUser currentBXLiveUser].user_id;
//            model.circilenums = @"0";
//            vc.model = model;
//            [self pushVc:vc];
            [self pop];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"创建失败"];
    }];
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_Nametextfield resignFirstResponder];
    [_textView resignFirstResponder];
}
-(void)backClick{
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[BXLCPswLoginVC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//            break;
//        }
//    }
    [self pop];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @" 描述一下你的街区吧(最多60个字)";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@" 描述一下你的街区吧(最多60个字)"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length >= 60) {
        textView.text = [textView.text substringToIndex:60];
    }

}
//#pragma - mark UITextViewDelegate
//- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
//    if (height < 48) {
//        height = 48;
//    } else if (height > 80) {
//        height = 80;
//    }
//
//    [_growingTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//
//
//
//}
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//    [self.growingTextView resignFirstResponder];
//    return YES;
//}
//- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//
//
//    //判断是回车键就发送出去
//    if ([text isEqualToString:@"\n"])
//    {
//        return NO;
//    }
////    if (self.growingTextView.text.length >= 60) {
////        self.growingTextView.text = [growingTextView.text substringToIndex:60];
////        return NO;
////    }
//
//    return YES;
//}
//
//-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
//
//
//        if (self.growingTextView.text.length >= 60) {
//            NSString *str = growingTextView.text;
//            NSString *MaxStr = [str substringToIndex:60];
//            growingTextView.text = MaxStr;
//        }
//
//
//}
//
//- (void)textFieldDidChange:(UITextField *)textField {
//    NSString *toBeString = textField.text;
//    // 获取高亮部分
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if (!position) {
//        if (toBeString.length > 12) {
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:12];
//            if (rangeIndex.length == 1) {
//                textField.text = [toBeString substringToIndex:12];
//            } else {
//                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 12)];
//                textField.text = [toBeString substringWithRange:rangeRange];
//            }
//        }
//    }
//}

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
//        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(500, 200);
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.themeColor = [UIColor sl_colorWithHex:0xF92C56];
        _manager.configuration.restoreNavigationBar = YES;
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
            ws.bigCoverImageView.image = [imageArray lastObject];
        }else{
             ws.backImageView.image = [imageArray lastObject];
        }
    }];
//    [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//
//            //        NSData *data = UIImageJPEGRepresentation(image, .8);
//            //        NSString *filePath = [self getImageFilePath:data];
//        if (ws.viewFlag == 0) {
//
//            ws.coverImageView.image = [imageList lastObject];
//            ws.bigCoverImageView.image = [imageList lastObject];
//        }else{
//             ws.backImageView.image = [imageList lastObject];
//        }
//    } failed:^{
//
//    }];
}

#pragma - mark NSNotification
- (void)keyboardWillHide:(NSNotification *)noti {

    self.view.frame = CGRectMake(0, 0, __kWidth, __kHeight);
}
- (void)keyboardWillShow:(NSNotification *)noti {
//    NSDictionary *userInfo=noti.userInfo;
//    NSValue *keyBoardEndBounds=userInfo[UIKeyboardFrameEndUserInfoKey];
//    CGRect  endRect=[keyBoardEndBounds CGRectValue];
//    CGFloat keyboardhight=endRect.size.height;
    self.view.frame = CGRectMake(0, -50, __kWidth, __kHeight);
}
#pragma mark - 获取临时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData fileName:(NSString *)fileName {
    NSString *dirPath =[[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"manual"];
    BOOL isdir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath isDirectory:&isdir]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [dirPath stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

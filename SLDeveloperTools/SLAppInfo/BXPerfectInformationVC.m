//
//  BXPerfectInformationVC.h
//  BXlive
//
//  Created by bxlive on 2019/3/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXPerfectInformationVC.h"
#import "HHSelectCountryVC.h"
#import "BXCountryCodeButton.h"
#import "BXGradientButton.h"
#import "HHLoginManager.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface BXPerfectInformationVC ()

@property (strong, nonatomic) BXCountryCodeButton *countryCodeBtn;
@property (strong, nonatomic) UITextField *phoneTf;
@property (strong, nonatomic) UITextField *codeTf;
@property (strong, nonatomic) UIButton *codeBtn;
@property(nonatomic,strong)UIView *navigationView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *contentView1;    //显示已经绑定的手机号
@property(nonatomic,strong)UIView *contentView2;    //更改、绑定手机号
@property(nonatomic,strong)UILabel *phoneNumLable;  //显示已经绑定的手机号

@property (assign,nonatomic) NSInteger time;//倒计时
@property (strong,nonatomic) NSTimer *timer;//NSTimer对象
@property (copy, nonatomic) NSString *phone_code;

@end

@implementation BXPerfectInformationVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_time > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:sl_BGColors];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
//    self.title = @"绑定手机号";
//    if (_type == 2) {
//        self.title = @"更改手机号";
//    }
   
    [self setupNavigationView];
    
    [self initView];
}
-(void)setupNavigationView{
    _navigationView = [UIView new];
    [self.view addSubview:_navigationView];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(__kTopAddHeight+64);
    }];
    [_navigationView setBackgroundColor:[UIColor sl_colorWithHex:0xFFFFFF]];
    WS(weakSelf);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [_navigationView addSubview:backBtn];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"绑定手机号" Font:SLBFont(__ScaleWidth(18)) TextColor:sl_textColors];
    if (_type == 2) {
        [label setText:@"我的手机号"];
    }
    label.textAlignment = 1;
    [_navigationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-44);
        make.centerY.equalTo(weakSelf.navigationView.mas_bottom).offset(-22);
        make.height.mas_equalTo(25);
    }];
    self.titleLabel = label;
}



- (void)initView {
    
    _contentView2 = [UIView new];
    [self.view addSubview:_contentView2];
    WS(weakSelf);
    [_contentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navigationView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    _phone_code = [BXAppInfo getPhoneCode];
//    UIView *phoneLineView = [[UIView alloc]init];
//    phoneLineView.backgroundColor = LineNormalColor;
//    [_contentView2 addSubview:phoneLineView];
//    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.right.mas_equalTo(-16);
//        make.height.mas_equalTo(1);
//        make.top.mas_equalTo(78);
//    }];
    
//    UIImageView *phoneIv = [[UIImageView alloc]init];
//    phoneIv.image = CImage(@"icon_ipone");
//    phoneIv.contentMode = UIViewContentModeScaleAspectFit;
//    [_contentView2 addSubview:phoneIv];
//    [phoneIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(phoneLineView.mas_left).offset(12);
//        make.bottom.mas_equalTo(phoneLineView.mas_top).offset(-20);
//        make.width.height.mas_equalTo(23);
//    }];
    
//    _countryCodeBtn = [[BXCountryCodeButton alloc]init];
//    _countryCodeBtn.countryCode = _phone_code;
//    [_countryCodeBtn addTarget:self action:@selector(selectPhoneCode) forControlEvents:BtnTouchUpInside];
//    [_contentView2 addSubview:_countryCodeBtn];
//    [_countryCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(phoneIv.mas_right).offset(10);
//        make.top.bottom.mas_equalTo(phoneIv);
//    }];
    
    UIView *phoneView = [UIView new];
    [_contentView2 addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(12));
        make.right.mas_equalTo(__ScaleWidth(-12));
        make.height.mas_equalTo(__ScaleWidth(48));
        make.top.mas_equalTo(__ScaleWidth(15));
    }];
    [phoneView setBackgroundColor:sl_subBGColors];
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.cornerRadius = __ScaleWidth(24);
    
    
    _codeBtn = [[UIButton alloc]init];
    [_codeBtn setTitleColor:sl_textColors forState:BtnNormal];
    [_codeBtn setTitle:@"获取验证码" forState:BtnNormal];
    _codeBtn.titleLabel.font = SLPFFont(__ScaleWidth(14));
    [_codeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:BtnTouchUpInside];
    [phoneView addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-15));
        make.width.mas_equalTo(__ScaleWidth(75));
        make.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    
    _phoneTf = [[UITextField alloc]init];
    _phoneTf.font = CFont(16);
    _phoneTf.textColor =sl_textColors;
    _phoneTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:sl_textSubColors}];
    _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneView addSubview:_phoneTf];
    UIButton *phoneTfBtn =[_phoneTf valueForKey:@"_clearButton"];
    [phoneTfBtn setImage:CImage(@"login_clear") forState:BtnNormal];
    [_phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.codeBtn.mas_left).offset(-__ScaleWidth(12));
        make.left.mas_equalTo(__ScaleWidth(20));
        make.height.mas_equalTo(__ScaleWidth(25));
        make.centerY.mas_equalTo(0);
    }];
    
//    UIView *codeLineView = [[UIView alloc]init];
//    codeLineView.backgroundColor = LineNormalColor;
//    [_contentView2 addSubview:codeLineView];
//    [codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.height.mas_equalTo(phoneLineView);
//        make.top.mas_equalTo(phoneLineView.mas_bottom).offset(63);
//    }];
//
//    UIImageView *codeIv = [[UIImageView alloc]init];
//    codeIv.image = CImage(@"icon_yanzhenma");
//    codeIv.contentMode = UIViewContentModeScaleAspectFit;
//    [_contentView2 addSubview:codeIv];
//    [codeIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.height.mas_equalTo(phoneIv);
//        make.bottom.mas_equalTo(codeLineView.mas_top).offset(-20);
//    }];
    
    UIView *codeView = [UIView new];
    [_contentView2 addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(phoneView);
        make.top.equalTo(phoneView.mas_bottom).offset(__ScaleWidth(15));
    }];
    codeView.layer.masksToBounds = YES;
    codeView.layer.cornerRadius = __ScaleWidth(24);
    codeView.backgroundColor = sl_subBGColors;
    
    _codeTf = [[UITextField alloc]init];
    _codeTf.placeholder = @"请输入验证码";
    _codeTf.font = CFont(16);
    _codeTf.textColor =sl_textColors;
    _codeTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:sl_textSubColors}];
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [codeView addSubview:_codeTf];
    UIButton *codeTfBtn =[_codeTf valueForKey:@"_clearButton"];
    [codeTfBtn setImage:CImage(@"login_clear") forState:BtnNormal];
    [_codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(__ScaleWidth(25));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(__ScaleWidth(20));
        make.right.mas_equalTo(__ScaleWidth(-20));
    }];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"完成" forState:BtnNormal];
    [nextButton sl_setTitleColor:sl_textColors];
    nextButton.layer.cornerRadius = __ScaleWidth(22);
    nextButton.layer.masksToBounds = YES;
    [nextButton setBackgroundColor:sl_subBGColors];
    nextButton.titleLabel.font = SLBFont(__ScaleWidth(16));
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:BtnTouchUpInside];
    [_contentView2 addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(codeView);
        make.top.mas_equalTo(codeView.mas_bottom).offset(__ScaleWidth(50));
        make.height.mas_equalTo(__ScaleWidth(44));
    }];
    
//    如果已经绑定了手机号。则先显示绑定的手机号
    _contentView1 = [UIView new];
    [self.view addSubview:_contentView1];
    [_contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(weakSelf.contentView2);
    }];
    UIImageView *bindingPhoneImgV = [UIImageView new];
    [_contentView1 addSubview:bindingPhoneImgV];
    [bindingPhoneImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(__ScaleWidth(90));
        make.height.width.mas_equalTo(__ScaleWidth(62));
    }];
    [bindingPhoneImgV setImage:CImage(@"binding_phone")];
    
    UILabel *label1 = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"已绑定的手机号" Font:SLPFFont(14) TextColor:sl_textSubColors];
    [_contentView1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(bindingPhoneImgV.mas_bottom).offset(__ScaleWidth(25));
        make.height.mas_equalTo(__ScaleWidth(20));
    }];
    label1.textAlignment =  1;
    
    _phoneNumLable = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:[BXLiveUser currentBXLiveUser].phone Font:SLBFont(__ScaleWidth(16)) TextColor:sl_textColors];
    [_contentView1 addSubview:_phoneNumLable];
    [_phoneNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(__ScaleWidth(20));
        make.top.equalTo(label1.mas_bottom).offset(__ScaleWidth(20));
    }];
    _phoneNumLable.textAlignment = 1;
    
    
    UIButton *changeNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeNumBtn setTitle:@"更换手机号码" forState:BtnNormal];
    [changeNumBtn setTitleColor:sl_whiteTextColors forState:BtnNormal];
    changeNumBtn.backgroundColor = sl_normalColors;
    changeNumBtn.layer.cornerRadius = __ScaleWidth(22);
    changeNumBtn.layer.masksToBounds = YES;
    changeNumBtn.titleLabel.font = SLBFont(__ScaleWidth(16));
    [changeNumBtn addTarget:self action:@selector(changePhoneNum:) forControlEvents:BtnTouchUpInside];
    [_contentView1 addSubview:changeNumBtn];
    [changeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-12));
        make.left.mas_equalTo(__ScaleWidth(12));
        make.top.mas_equalTo(weakSelf.phoneNumLable.mas_bottom).offset(__ScaleWidth(50));
        make.height.mas_equalTo(__ScaleWidth(44));
    }];
    
    if (_type == 2) {
        self.contentView1.hidden = NO;
        self.contentView2.hidden = YES;
        
    }else{
        self.contentView2.hidden = NO;
        self.contentView1.hidden = YES;
        [_phoneTf becomeFirstResponder];
    }
    
    
}

-(void)changePhoneNum:(UIButton *)btn{
    self.titleLabel.text = @"更改手机号";
    self.contentView1.hidden = YES;
    self.contentView2.hidden = NO;
    [_phoneTf becomeFirstResponder];
}

- (void)selectPhoneCode {
    [self.view endEditing:YES];
    WS(ws);
    HHSelectCountryVC *vc = [[HHSelectCountryVC alloc]init];
    vc.didSelectCountry = ^(NSString *country, NSString *code) {
        ws.phone_code = code;
        ws.countryCodeBtn.countryCode = code;
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCodeAction:(UIButton *)sender {
    if (!_phoneTf.text.length) {
        [_phoneTf becomeFirstResponder];
        [BGProgressHUD showInfoWithMessage:@"请输入手机号"];
    } else {
        [_codeTf becomeFirstResponder];
        [self changecodeBtnStateWithIsEnabled:NO];
        [NewHttpManager sendSmsCodeWithPhone:_phoneTf.text scene:@"bind" phoneCode:_phone_code success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (!code || code == 1007) {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                NSDictionary *dataDic = jsonDic[@"data"];
                [self didGetLimit:[dataDic[@"limit"] integerValue]];
            } else {
                [self changecodeBtnStateWithIsEnabled:YES];
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            [self changecodeBtnStateWithIsEnabled:YES];
            [BGProgressHUD showInfoWithMessage:@"获取验证码失败"];
        }];
    }
}

- (void)didGetLimit:(NSInteger)limit {
    _time = limit;
    [self stopTimer];
    [self countDown];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)countDown {
    _time--;
    if (_time <= 0) {
        [self stopTimer];
        [self changecodeBtnStateWithIsEnabled:YES];
    } else {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lds",_time] forState:UIControlStateNormal];
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)changecodeBtnStateWithIsEnabled:(BOOL)enabled {
    if (enabled) {
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:sl_textColors forState:BtnNormal];
        _codeBtn.backgroundColor = [UIColor clearColor];
    } else {
        [_codeBtn setTitleColor:MinorColor forState:BtnNormal];
//        _codeBtn.backgroundColor = PageSubBackgroundColor;
        [_codeBtn setTitle:@"60s" forState:UIControlStateNormal];
    }
    _codeBtn.userInteractionEnabled = enabled;
}

- (void)nextAction:(UIButton *)sender {
    if (IsNilString(_phoneTf.text)) {
        [BGProgressHUD showInfoWithMessage:@"请输入手机号"];
        return;
    }
    
    if (IsNilString(_codeTf.text)) {
        [BGProgressHUD showInfoWithMessage:@"请输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    
    [BGProgressHUD showLoadingWithMessage:nil];
    [NewHttpManager bindPhoneNumWithPhone:_phoneTf.text code:_codeTf.text phoneCode:_phone_code success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            BXLiveUser *liveUser = [BXLiveUser currentBXLiveUser];
            liveUser.phone = self.phoneTf.text;
            [BXLiveUser setCurrentBXLiveUser:liveUser];
            
            [BGProgressHUD showInfoWithMessage:@"绑定成功"];
            [self backToFunctionVC];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"绑定失败"];
    }];
}

- (void)backToFunctionVC {
    if (_type) {
//        [self.navigationController popViewControllerAnimated:YES];
//        [SLProgressHUD slShowInfoWithMessage:@""]
        self.contentView2.hidden = YES;
        self.contentView1.hidden = NO;
        self.titleLabel.text = @"我的手机号";
        self.phoneNumLable.text = [BXLiveUser currentBXLiveUser].phone;
    } else {//跳过登录页面 直接返回
        UIViewController *originController = [HHLoginManager shareLoginManager].originController;
        if (originController && [self.navigationController.childViewControllers containsObject:originController]) {
            [self.navigationController popToViewController:originController animated:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  BXDynChangeCircleNameVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynChangeCircleNameVC.h"
#import "BXDynCircleChangeAlert.h"
#import "HttpMakeFriendRequest.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoMacro.h"
#import "../SLMaskTools/SLMaskTools.h"


@interface BXDynChangeCircleNameVC ()<UITextFieldDelegate>
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;
@property(nonatomic, strong)UITextField *Nametextfield;
@property(nonatomic, strong)UILabel *numberLabel;
@end

@implementation BXDynChangeCircleNameVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
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
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavView];
    
    _Nametextfield = [[UITextField alloc]init];
    _Nametextfield.delegate = self;
    _Nametextfield.layer.masksToBounds = YES;
    _Nametextfield.layer.cornerRadius = 5;
    _Nametextfield.font = [UIFont systemFontOfSize:14];
    _Nametextfield.backgroundColor = UIColorHex(#F5F9FC);
    _Nametextfield.textColor = [UIColor blackColor];
    [self.Nametextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_Nametextfield];
    [_Nametextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.height.mas_equalTo(48);
    }];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.textColor = UIColorHex(#8C8C8C);
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.text = @"0/12";
    [self.view addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(self.Nametextfield.mas_bottom).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];

}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"圈子名称";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
    [_issueBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    _issueBtn.backgroundColor = DynUnSendButtonBackColor;
    _issueBtn.titleLabel.font = SLPFFont(14);
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
    _issueBtn.userInteractionEnabled = NO;
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];

}
- (void)textFieldDidChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
    // 获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        _numberLabel.text = [NSString stringWithFormat:@"%lu/12", (unsigned long)toBeString.length];
        if (toBeString.length > 12) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:12];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:12];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 12)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    if (textField.text.length) {
        [_issueBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynSendButtonBackColor;
        _issueBtn.userInteractionEnabled = YES;
    }
    else{
        [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynUnSendButtonBackColor;
        _issueBtn.userInteractionEnabled = NO;
    }
  
}
-(void)AddClick{
    if ([_Nametextfield.text isEqualToString:@""]) {
        [BGProgressHUD showInfoWithMessage:@"请输入修改的名称"];
        return;
    }
    WS(weakSelf);
    BXDynCircleChangeAlert *alert = [[BXDynCircleChangeAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alert.DidClickBlock = ^{
        [HttpMakeFriendRequest ModifyCircleWithcircle_id:self.model.circle_id circle_name:self.Nametextfield.text circle_describe:self.model.circle_describe circle_cover_img:self.model.circle_cover_img circle_background_img:self.model.circle_background_img Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                if (weakSelf.ChangeName) {
                    weakSelf.ChangeName(weakSelf.Nametextfield.text);
                }
            }else{
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD showInfoWithMessage:@"操作失败"];
        }];
    };
    [alert showWithView:self.view];
}
-(void)backClick{

    [self pop];
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

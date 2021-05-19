//
//  BXDynChangeCircleDesVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynChangeCircleDesVC.h"
#import "BXDynCircleChangeAlert.h"
#import "HttpMakeFriendRequest.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoMacro.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXDynChangeCircleDesVC ()<UITextViewDelegate>
@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)UILabel *textlabel;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;
@end

@implementation BXDynChangeCircleDesVC
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
    [self setTextView];

}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"圈子描述";
    _viewTitlelabel.textColor = sl_blackBGColors;
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
    _issueBtn.backgroundColor = sl_subBGColors;
    _issueBtn.titleLabel.font = SLPFFont(14);
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
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
-(void)setTextView{
    _textView = [[UITextView alloc] init];
    _textView.layer.cornerRadius = 5;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.backgroundColor = sl_subBGColors;
    _textView.textColor = [UIColor blackColor];
    
    //字体
    _textView.font = [UIFont systemFontOfSize:17];
    //对齐
    _textView.textAlignment = 0;
    //字体颜色
    _textView.textColor = [UIColor blackColor];
    //允许编辑
    _textView.editable = YES;
    //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
    _textView.userInteractionEnabled = YES; ///
    //自定义键盘
    //textView.inputView = view;//自定义输入区域
    //textView.inputAccessoryView = view;//键盘上加view
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    _textView.scrollEnabled = YES;//滑动
    _textView.returnKeyType = UIReturnKeyDone;//返回键类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    //    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应
    _textView.dataDetectorTypes = UIDataDetectorTypeAll;//数据类型连接模式
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错方式
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大写方式
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(10);
        make.height.mas_equalTo(80);
    }];
    
    
    _textlabel = [[UILabel alloc]init];
    _textlabel.textColor = sl_textSubColors;
    _textlabel.font = [UIFont systemFontOfSize:12];
    _textlabel.textAlignment = 2;
    _textlabel.text = @"0/60";
    [self.view addSubview:_textlabel];
    [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}
/////////事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //判断类型，如果不是UITextView类型，收起键盘
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            UITextView* tv = (UITextView*)view;
            [tv resignFirstResponder];
        }
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  
    if ([text isEqualToString:@"\n"]){
        //禁止输入换行
        return NO;
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        [_issueBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynSendButtonBackColor;
        _issueBtn.userInteractionEnabled = YES;
    }
    else{
        [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = sl_subBGColors;
        _issueBtn.userInteractionEnabled = NO;
    }
    if (textView.text.length >= 60) {
        textView.text = [textView.text substringToIndex:60];
    }
    
    _textlabel.text = [NSString stringWithFormat:@"%lu/60", (unsigned long)textView.text.length];
}
-(void)AddClick{
    if ([_textView.text isEqualToString:@""]) {
        [BGProgressHUD showInfoWithMessage:@"请输入修改的描述"];
        return;
    }
    WS(weakSelf);
    BXDynCircleChangeAlert *alert = [[BXDynCircleChangeAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alert.DidClickBlock = ^{
        [HttpMakeFriendRequest ModifyCircleWithcircle_id:self.model.circle_id circle_name:self.textView.text circle_describe:self.model.circle_describe circle_cover_img:self.model.circle_cover_img circle_background_img:self.model.circle_background_img Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                if (weakSelf.ChangeDes) {
                    weakSelf.ChangeDes(weakSelf.textView.text);
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

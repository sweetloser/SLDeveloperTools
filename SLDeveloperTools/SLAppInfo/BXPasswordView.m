//
//  BXPasswordView.m
//  BXlive
//
//  Created by bxlive on 2019/6/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXPasswordView.h"
#import "BXGradientButton.h"
#import "SLDeveloperTools/SLMacro.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@interface BXPasswordView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *inputTf;
@property (nonatomic, strong) NSMutableArray *passwordTFs;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation BXPasswordView

- (instancetype)initWithTitle:(NSString *)title {
    if ([super init]) {
        self.frame = CGRectMake(0, 0, __kWidth, __kHeight);
        _secureTextEntry = YES;
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [self addSubview:maskView];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((self.mj_w - __ScaleWidth(321)) / 2, (self.mj_h - __ScaleWidth(184)) / 2, __ScaleWidth(321), __ScaleWidth(184))];
        _contentView.backgroundColor = sl_BGColors;
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UILabel *textLb = [[UILabel alloc]init];
        textLb.text = title;
        textLb.font = SLBFont(__ScaleWidth(16));
        textLb.textColor = sl_textColors;
        [_contentView addSubview:textLb];
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(__ScaleWidth(20));
            make.height.mas_equalTo(__ScaleWidth(22));
        }];
        
        UIView *inputView = [[UIView alloc]init];
//        inputView.layer.cornerRadius = 4;
//        inputView.layer.borderColor = CHHCOLOR_D(0xCBD6D6).CGColor;
        inputView.layer.borderColor = [UIColor clearColor].CGColor;
//        inputView.layer.borderWidth = 1;
        inputView.layer.masksToBounds = YES;
        inputView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(22));
            make.right.mas_equalTo(-__ScaleWidth(21));
            make.top.mas_equalTo(textLb.mas_bottom).offset(__ScaleWidth(20));
            make.height.mas_equalTo(__ScaleWidth(38));
        }];
        
        _passwordTFs=[NSMutableArray array];
        UIView *lastView = nil;
        for (int i=0; i < 6; i++) {
            UITextField *passwordTf = [[UITextField alloc]init];
            passwordTf.textColor = sl_textColors;
            passwordTf.textAlignment = NSTextAlignmentCenter;
            passwordTf.font = SLBFont(__ScaleWidth(20));
            passwordTf.userInteractionEnabled = NO;
            passwordTf.secureTextEntry = YES;
            passwordTf.backgroundColor = sl_BGColors;
//            [inputView insertSubview:passwordTf atIndex:0];
            [inputView addSubview:passwordTf];
            passwordTf.layer.borderColor = sl_divideLineColor.CGColor;
            passwordTf.layer.borderWidth = __ScaleWidth(1.5);
            passwordTf.layer.cornerRadius = 5.0;
            [_passwordTFs addObject:passwordTf];
            [passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
//                make.width.mas_equalTo(inputView.mas_width).multipliedBy(1.0 / 6);
                make.width.mas_equalTo(__ScaleWidth(38));
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(__ScaleWidth(10));
                } else {
                    make.left.mas_equalTo(0);
                }
            }];
            lastView = passwordTf;
            
//            if (i < 5) {
//                UIView *lineView = [[UIView alloc]init];
//                lineView.backgroundColor = CHHCOLOR_D(0xCBD6D6);
//                [inputView addSubview:lineView];
//                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.bottom.mas_equalTo(0);
//                    make.width.mas_equalTo(1);
//                    make.centerX.mas_equalTo(passwordTf.mas_right);
//                }];
//            }
        }
        UITextField *temText = [_passwordTFs objectAtIndex:0];
        
        _inputTf = [[UITextField alloc]init];
        _inputTf.keyboardType=UIKeyboardTypeNumberPad;
        [_inputTf addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [_contentView insertSubview:_inputTf atIndex:0];
        [_inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(temText);
            make.width.height.mas_equalTo(10);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitleColor:sl_textColors forState:BtnNormal];
        [cancelBtn setTitle:@"取消" forState:BtnNormal];
        cancelBtn.titleLabel.font = SLBFont(__ScaleWidth(14));
        cancelBtn.layer.cornerRadius = __ScaleWidth(22);
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = sl_subBGColors;
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
        [_contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(inputView.mas_left);
            make.top.mas_equalTo(inputView.mas_bottom).offset(__ScaleWidth(20));
            make.height.mas_equalTo(__ScaleWidth(44));
            make.width.mas_equalTo(__ScaleWidth(122));
        }];
        
        UIButton *sureBtn = [[UIButton alloc]init];
        [sureBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.6] forState:BtnNormal];
        [sureBtn setTitle:@"确定" forState:BtnNormal];
        sureBtn.titleLabel.font = SLBFont(__ScaleWidth(14));
        sureBtn.layer.cornerRadius = __ScaleWidth(22);
        [sureBtn setBackgroundColor:sl_normalColors];
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:BtnTouchUpInside];
        [_contentView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.width.mas_equalTo(cancelBtn);
            make.right.mas_equalTo(__ScaleWidth(-20));
        }];
        _sureBtn = sureBtn;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [_inputTf becomeFirstResponder];
        
        UITapGestureRecognizer *inputViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTapAction:)];
        [inputView addGestureRecognizer:inputViewTap];
    }
    return self;
}
-(void)inputViewTapAction:(UITapGestureRecognizer *)tap{
    if ([_inputTf isFirstResponder]) {
        [_inputTf resignFirstResponder];
    }else{
        [_inputTf becomeFirstResponder];
    }
}

- (void)setInitialPassword:(NSString *)initialPassword {
    _initialPassword = initialPassword;
    
    _inputTf.text = initialPassword;
    [self textChange:_inputTf];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    for (UITextField *passwordTf in _passwordTFs) {
        passwordTf.secureTextEntry = secureTextEntry;
    }
}

- (void)sureAction {
    if (_inputTf.text.length == 6) {
        if (_didInputPassword) {
            _didInputPassword(_inputTf.text);
        }
        [self removeFromSuperview];
    }
}

- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

- (void)textChange:(UITextField*)textFiled {
    if (textFiled.text.length > 6) {
        textFiled.text = [textFiled.text substringToIndex:6];
    }

    for (int i=0; i < 6; i++) {
        UITextField *passwordTF = _passwordTFs[i];
        if (i < textFiled.text.length) {
            passwordTF.text=[textFiled.text substringWithRange:NSMakeRange(i, 1)];
        }else{
            passwordTF.text = @"";
        }
//        [_inputTf mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(passwordTF);
//        }];
    }
    
    if (textFiled.text.length == 6) {
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
        if (_secureTextEntry) {
            [self sureAction];
        }
    } else {
        [_sureBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.6] forState:BtnNormal];
    }
}

- (void)showWithSuperView:(UIView *)superView {
    [superView addSubview:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo=noti.userInfo;
    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve =[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView setAnimationCurve:animationCurve];
    [UIView animateWithDuration:duration animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}



@end

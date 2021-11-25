//
//  QuickRechargeFootView.m
//  BXlive
//
//  Created by 刘超 on 2020/6/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "QuickRechargeFootView.h"
#import "UIColor+HexColor.h"
#import "UILabel+Kit.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "SLDeveloperTools.h"

@interface QuickRechargeFootView()


@property(nonatomic,strong)UIButton *zfbBtn;
@property(nonatomic,strong)UIButton *wxBtn;
@property(nonatomic,strong)UIButton *payBtn;



@end

@implementation QuickRechargeFootView





- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorHex(ffffff);
        self.chargeLabel = [UILabel initWithFrame:CGRectZero size:14 color:[UIColor blackColor] alignment:0 lines:1];
        self.zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zfbBtn addTarget:self action:@selector(paytypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.zfbBtn setImage:[UIImage imageNamed:@"quick_recharge_ali"] forState:UIControlStateNormal];
        self.zfbBtn.tag = 0;
        [self.zfbBtn setTitle:@" 支付宝" forState:UIControlStateNormal];
        [self.zfbBtn setTitleColor:[UIColor colorWithHexString:@"#06B4FD"] forState:UIControlStateNormal];
        [self.zfbBtn setTitleColor:[UIColor colorWithHexString:@"#F8F8F8"] forState:UIControlStateSelected];
        self.zfbBtn.titleLabel.font = SLPFFont(16);
        self.zfbBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        self.zfbBtn.selected = YES;
        self.zfbBtn.layer.cornerRadius = 21.0;
        self.zfbBtn.layer.masksToBounds  = YES;
        
        
        self.wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.wxBtn addTarget:self action:@selector(paytypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.wxBtn setImage:[UIImage imageNamed:@"quick_recharge_wx"] forState:UIControlStateNormal];
        self.wxBtn.tag = 1;
        [self.wxBtn setTitle:@" 微信" forState:UIControlStateNormal];
        [self.wxBtn setTitleColor:[UIColor colorWithHexString:@"#00C801"] forState:UIControlStateNormal];
        [self.wxBtn setTitleColor:[UIColor colorWithHexString:@"#F8F8F8"] forState:UIControlStateSelected];
        self.wxBtn.titleLabel.font = SLPFFont(16);
        self.wxBtn.selected = NO;
        self.wxBtn.layer.cornerRadius = 21.0;
        self.wxBtn.layer.masksToBounds  = YES;
        self.wxBtn.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
        
        self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.payBtn addTarget:self action:@selector(payBtnClicked) forControlEvents:BtnTouchUpInside];
        self.payBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        self.payBtn.layer.cornerRadius = 21.0;
        self.payBtn.layer.masksToBounds  = YES;
        [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [self.payBtn setTitleColor:[UIColor colorWithHexString:@"#EDF2F4"] forState:UIControlStateNormal];
        self.payBtn.titleLabel.font = SLBFont(16);
        
        
        [self sd_addSubviews:@[self.chargeLabel,self.zfbBtn,self.wxBtn,self.payBtn]];
        self.chargeLabel.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 10).rightSpaceToView(self, 16).heightIs(20);
        self.zfbBtn.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self.chargeLabel, 20).widthIs(109).heightIs(42);
        self.wxBtn.sd_layout.leftSpaceToView(self.zfbBtn, 15).topSpaceToView(self.chargeLabel, 20).widthIs(109).heightIs(42);
        self.payBtn.sd_layout.centerXEqualToView(self).topSpaceToView(self.zfbBtn, 20).widthIs(351).heightIs(42);
        
//        self.typeblocl(0);
        if ([[BXAppInfo appInfo].ios_app_hidden integerValue] == 1) {
            self.zfbBtn.hidden = YES;
            self.wxBtn.hidden = YES;
            
        }
    }
    
    return  self;
    
}

-(void)paytypeBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        self.zfbBtn.selected = YES;
        self.zfbBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        self.wxBtn.selected = NO;
        self.wxBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F9FC"];
        
    }else{
        self.wxBtn.selected = YES;
        self.wxBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        self.zfbBtn.selected = NO;
        self.zfbBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F9FC"];
    }
    self.typeblocl(btn.tag);
}

-(void)payBtnClicked{
    self.payblock();
}

@end

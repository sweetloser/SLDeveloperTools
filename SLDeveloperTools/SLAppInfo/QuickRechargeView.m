//
//  QuickRechargeView.m
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "QuickRechargeView.h"
#import "UIColor+HexColor.h"
#import "UILabel+Kit.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIColor+HexColor.h"
#import "UILabel+Kit.h"
#import <SDAutoLayout/SDAutoLayout.h>
@interface QuickRechargeView()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *closeBtn;



@end

@implementation QuickRechargeView


//初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorHex(ffffff);
        self.nameLabel = [UILabel initWithFrame:CGRectZero size:16 color:[UIColor blackColor] alignment:1 lines:1];
        self.nameLabel.text = @"充值";
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        self.chargeLabel = [UILabel initWithFrame:CGRectZero size:14 color:[UIColor blackColor] alignment:0 lines:1];
        [self sd_addSubviews:@[self.nameLabel,self.closeBtn,self.chargeLabel]];
        
         self.nameLabel.sd_layout.leftSpaceToView(self, 50).heightIs(22).rightSpaceToView(self, 50).topSpaceToView(self, 15);
        
        self.closeBtn.sd_layout.rightSpaceToView(self, 15).widthIs(20).heightIs(20).centerYEqualToView(self.nameLabel);
        
        self.closeBtn.imageView.sd_layout.centerYEqualToView(self.closeBtn).centerXEqualToView(self.closeBtn).widthIs(20).heightIs(20);
        
        
        
        self.chargeLabel.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 52).rightSpaceToView(self, 16).heightIs(20);
        
    
        
    }
    return self;
}
-(void)closeBtnClick{
    
    if (self.closeView) {
        self.closeView();
    }
    
}


@end

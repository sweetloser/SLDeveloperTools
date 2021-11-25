//
//  QuickRechargeCell.m
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "QuickRechargeCell.h"
#import "UIColor+HexColor.h"
#import "UILabel+Kit.h"
#import <SDAutoLayout/SDAutoLayout.h>


@interface QuickRechargeCell()

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *coinLabel;

@property(nonatomic,strong)UILabel *moneyLabel;
@end

@implementation QuickRechargeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F5F9FC"];
        self.coinLabel = [UILabel initWithFrame:CGRectZero size:14 color:UIColorHex(373737) alignment:1 lines:1];
        self.moneyLabel = [UILabel initWithFrame:CGRectZero size:12 color:UIColorHex(b0b0b0) alignment:1 lines:1];
        [self.contentView sd_addSubviews:@[self.backView]];
        [self.backView sd_addSubviews:@[self.coinLabel,self.moneyLabel]];
        
        self.backView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(50).topSpaceToView(self.contentView, 0);
        self.backView.sd_cornerRadius = @(25);
        
       
        self.coinLabel.sd_layout.leftSpaceToView(self.backView, 5).rightSpaceToView(self.backView, 5).topSpaceToView(self.backView, 5).heightIs(20);
        self.moneyLabel.sd_layout.leftSpaceToView(self.backView, 5).rightSpaceToView(self.backView, 5).topSpaceToView(self.coinLabel, 0).heightIs(20);
        
    }
    return self;
}

-(void)setModel:(MybgCodeModel *)model{
    self.coinLabel.text = [NSString stringWithFormat:@"%@%@",model.bean_num,model.name];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];

}


-(void)setSelect:(BOOL)select{
    if (select) {
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        self.coinLabel.textColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F5F9FC"];
        self.coinLabel.textColor = UIColorHex(373737);
        self.moneyLabel.textColor = UIColorHex(b0b0b0);
    }
    
}

@end

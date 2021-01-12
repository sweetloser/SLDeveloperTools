//
//  TiUISubMenuOneViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/4.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUISubMenuOneViewCell.h"
#import "TIButton.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

@interface TiUISubMenuOneViewCell ()

@property(nonatomic ,strong)TIButton *cellButton;

@end

@implementation TiUISubMenuOneViewCell
-(TIButton *)cellButton{
    if (_cellButton==nil) {
        _cellButton = [[TIButton alloc]initWithScaling:0.9];
        _cellButton.userInteractionEnabled = NO;
    }
    return _cellButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cellButton];
        [self.cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(6);
            make.right.equalTo(self.mas_right).offset(-6);
        }];
                
        
    }
    return self;
}

- (void)setSubMod:(TIMenuMode *)subMod{
    if (subMod) {
        _subMod = subMod;
        
[self.cellButton setTitle:[NSString stringWithFormat:@"%@",subMod.name]
                        withImage:[UIImage imageNamed:subMod.normalThumb]
                    withTextColor:TI_Color_Default_Text_Black
                         forState:UIControlStateNormal];
        
[self.cellButton setTitle:[NSString stringWithFormat:@"%@",subMod.name]
                withImage:[UIImage imageNamed:subMod.selectedThumb]
            withTextColor:[UIColor colorWithHexString:@"#FF2D52"]
                 forState:UIControlStateSelected];

    [self.cellButton setSelected:subMod.selected]; 
    }
}

@end

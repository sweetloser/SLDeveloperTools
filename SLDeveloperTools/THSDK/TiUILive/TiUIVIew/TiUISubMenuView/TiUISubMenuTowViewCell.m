//
//  TiUISubMenuTowViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUISubMenuTowViewCell.h"
#import "TIButton.h"
#import <YYCategories/YYCategories.h>

@interface TiUISubMenuTowViewCell ()

@property(nonatomic ,strong)TIButton *cellButton;

@end

@implementation TiUISubMenuTowViewCell

-(TIButton *)cellButton{
    if (_cellButton==nil) {
        _cellButton = [[TIButton alloc]initWithScaling:0.95];
        _cellButton.userInteractionEnabled = NO;
    }
    return _cellButton;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cellButton];
    }
    return self;
}


- (void)setSubMod:(TIMenuMode *)subMod{
    if (subMod) {
    _subMod = subMod;
        
        NSString *normalThumb = subMod.normalThumb?subMod.normalThumb:subMod.thumb;
        
        NSString *selectedThumb = subMod.selectedThumb?subMod.selectedThumb:subMod.thumb;

        [self.cellButton setTitle:[NSString stringWithFormat:@"%@",subMod.name]
                        withImage:[UIImage imageNamed:normalThumb]
                    withTextColor:TI_Color_Default_Text_Black
                         forState:UIControlStateNormal];

        [self.cellButton setTitle:[NSString stringWithFormat:@"%@",subMod.name]
                withImage:[UIImage imageNamed:selectedThumb]
            withTextColor:TI_Color_Default_Background_Pink
                 forState:UIControlStateSelected];
    [self.cellButton setSelected:subMod.selected];
    }
}

-(void)setCellType:(TiUISubMenuTowViewCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case TI_UI_TOWSUBCELL_TYPE_ONE:
        {
            [self.cellButton setBorderWidth:0.0 BorderColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.cellButton setBorderWidth:2.0 BorderColor:TI_Color_Default_Background_Pink forState:UIControlStateSelected];
            
            [self.cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self);
            }];
        }
            break;
            
        case TI_UI_TOWSUBCELL_TYPE_TWO:
        {
            [self.cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(8);
                make.right.equalTo(self.mas_right).offset(-8);
             }];
        }
           break;
        default:
            break;
    }
}

@end

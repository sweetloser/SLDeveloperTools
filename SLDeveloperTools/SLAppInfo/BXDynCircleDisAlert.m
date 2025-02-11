//
//  BXDynCircleDisAlert.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleDisAlert.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
@interface BXDynCircleDisAlert()

@property(nonatomic,strong)UIView *contentView;

@end

@implementation BXDynCircleDisAlert

-(instancetype)initWithFrame:(CGRect)frame title:(nonnull NSString *)titleString{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.height.mas_equalTo(166);
            make.left.offset(__ScaleWidth(27));
        }];
        self.contentView.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        _contentView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _contentView.alpha = 0;
        [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self->_contentView.alpha = 1.0;
        } completion:nil];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = [NSString stringWithFormat:@"是否解散【%@】圈子？", titleString];
        titleLabel.textAlignment = 1;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = sl_textSubColors;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
            make.height.mas_equalTo(42);
        }];
    
        UIButton *DelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [DelButton setTitle:@"确定" forState:UIControlStateNormal];
        [DelButton setTitleColor:sl_blackBGColors forState:UIControlStateNormal];
        DelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [DelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        DelButton.backgroundColor = UIColorHex(#FF2D52);
        DelButton.layer.cornerRadius = 22;
        DelButton.tag = 101;
        DelButton.layer.masksToBounds = YES;
        [DelButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:DelButton];
        [DelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.width.mas_equalTo(122);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(44);
        }];
        
        
        UIButton *CancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [CancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [CancleButton setTitleColor:sl_blackBGColors forState:UIControlStateNormal];
        CancleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        CancleButton.tag = 100;
        CancleButton.layer.cornerRadius = 22;
        CancleButton.layer.masksToBounds = YES;
        CancleButton.backgroundColor = sl_subBGColors;
        [CancleButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:CancleButton];
        [CancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.width.mas_equalTo(122);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(44);
        }];
        
        
        
    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        NSLog(@"范围内");
        return;
    }
    [self hiddenView];
}

-(void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        
    }else{
        if (self.DidClickBlock) {
            self.DidClickBlock();
        }
    }
    [self hiddenView];
}

-(void)showWithView:(UIView *)superView{
    self.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

-(void)hiddenView{
    self.hidden = YES;
    [self.contentView removeAllSubViews];
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self removeFromSuperview];
}

@end

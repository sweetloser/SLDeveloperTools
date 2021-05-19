//
//  SLAlertView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLAlertView.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"

@interface SLAlertView()

@property(nonatomic,strong)UIView *maskView;

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UILabel *descLabel;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *determineBtn;

@end


@implementation SLAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.6];
        [self addSubview:_maskView];
        _maskView.frame = self.bounds;
        UITapGestureRecognizer *hiddenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTapAction:)];
        [_maskView addGestureRecognizer:hiddenTap];
        
        _contentView = [UIView new];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.backgroundColor = sl_BGColors;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(27));
            make.right.mas_equalTo(-__ScaleWidth(27));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(168));
        }];
        WS(weakSelf);
        _descLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLBFont(16) TextColor:sl_textSubColors];
        _descLabel.textAlignment = 1;
        _descLabel.numberOfLines = 0;
        [_contentView addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.right.mas_equalTo(__ScaleWidth(-12));
            make.height.mas_equalTo(__ScaleWidth(22));
            make.top.mas_equalTo(__ScaleWidth(40));
        }];
        
        _cancelBtn = [UIButton buttonWithFrame:CGRectZero Title:@"取消" Font:SLBFont(14) Color:sl_textColors Image:nil Target:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
        _cancelBtn.backgroundColor = sl_subBGColors;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = __ScaleWidth(22);
        [_contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(20));
            make.top.equalTo(weakSelf.descLabel.mas_bottom).offset(__ScaleWidth(30));
            make.width.mas_equalTo(__ScaleWidth(122));
            make.height.mas_equalTo(__ScaleWidth(44));
        }];
        
        _determineBtn = [UIButton buttonWithFrame:CGRectZero Title:@"确定" Font:SLBFont(14) Color:sl_whiteTextColors Image:nil Target:self action:@selector(determineAction) forControlEvents:BtnTouchUpInside];
        _determineBtn.backgroundColor = sl_normalColors;
        _determineBtn.layer.masksToBounds = YES;
        _determineBtn.layer.cornerRadius = __ScaleWidth(22);
        [_contentView addSubview:_determineBtn];
        [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(__ScaleWidth(-20));
            make.top.equalTo(weakSelf.descLabel.mas_bottom).offset(__ScaleWidth(30));
            make.width.mas_equalTo(__ScaleWidth(122));
            make.height.mas_equalTo(__ScaleWidth(44));
        }];
        
    }
    return self;;
}

-(void)cancelAction{
    [self hiddenView];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
-(void)determineAction{
    [self hiddenView];
    if (self.determineBlock) {
        self.determineBlock();
    }
}

-(void)setDescString:(NSString *)descString{
    _descString = descString;
    CGFloat h = [UILabel getHeightByWidth:__kWidth-__ScaleWidth(27*2+12*2) title:descString font:SLBFont(16)];
    self.descLabel.text = _descString;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(__ScaleWidth(146) + h);
    }];
    [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
    
}

-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    [self.cancelBtn setTitle:cancelTitle forState:BtnNormal];
}

-(void)setDetermineTitle:(NSString *)determineTitle{
    _determineTitle = determineTitle;
    [self.determineBtn setTitle:determineTitle forState:BtnNormal];
}

-(void)hiddenTapAction:(UITapGestureRecognizer *)tap{
    [self hiddenView];
}

-(void)hiddenView{
    [self removeAllSubViews];
    [self removeFromSuperview];
    
}

-(void)showInView:(UIView *)view{
    [view addSubview:self];
    [view bringSubviewToFront:self];
}


@end

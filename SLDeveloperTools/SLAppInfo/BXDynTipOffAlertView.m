//
//  BXDynTipOffAlertView.m
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffAlertView.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

@interface BXDynTipOffAlertView()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic ,strong)NSString *agent_name;
@property(nonatomic ,strong)NSString *user_id;
@end

@implementation BXDynTipOffAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame user_id:(nonnull NSString *)user_id{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.3];
        self.user_id = user_id;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.height.mas_equalTo(257);
            make.left.offset(__ScaleWidth(27));
        }];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        _contentView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _contentView.alpha = 0;
        [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self->_contentView.alpha = 1.0;
        } completion:nil];
        
    
        UIButton *NoWatchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [NoWatchButton setTitle:@"不看TA的动态" forState:UIControlStateNormal];
        NoWatchButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [NoWatchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NoWatchButton.backgroundColor = sl_subBGColors;
        NoWatchButton.layer.cornerRadius = 22;
        NoWatchButton.tag = 100;
        NoWatchButton.layer.masksToBounds = YES;
        [NoWatchButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:NoWatchButton];
        [NoWatchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
            make.top.mas_equalTo(self.contentView.mas_top).offset(25);
            make.height.mas_equalTo(44);
        }];
        UIButton *CancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [CancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [CancleButton setTitleColor:UIColorHex(#FF2D52) forState:UIControlStateNormal];
        CancleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        CancleButton.tag = 101;
        CancleButton.layer.masksToBounds = YES;
        [CancleButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:CancleButton];
        [CancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
            make.top.mas_equalTo(NoWatchButton.mas_bottom).offset(15);
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

        if (self.determineBlock) {
            self.determineBlock(_user_id, btn.tag - 100);
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

//
//  BXDynCircelOperAlert.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircelOperAlert.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface BXDynCircelOperAlert()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic ,strong)NSString *agent_name;
@property(nonatomic ,strong)NSString *user_id;
@property(nonatomic, strong)NSArray *itemArray;
@end

@implementation BXDynCircelOperAlert

-(instancetype)initWithItemArray:(nonnull NSArray *)ItemArray{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        self.backgroundColor = [UIColor sl_colorWithHex:0x000000 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.height.mas_equalTo(60 * ItemArray.count + 25);
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
        
        for (int i = 0; i < ItemArray.count; i++) {
            UIButton *NoWatchButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [NoWatchButton setTitle:ItemArray[i] forState:UIControlStateNormal];
            NoWatchButton.layer.cornerRadius = 22;
            NoWatchButton.tag = 100 + i;
            NoWatchButton.layer.masksToBounds = YES;
            [NoWatchButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
            [self.contentView addSubview:NoWatchButton];
            if (i == ItemArray.count - 1) {
                [NoWatchButton setTitleColor:[UIColor sl_colorWithHex:0xFF2D52] forState:UIControlStateNormal];
                NoWatchButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            }else{
                NoWatchButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
                [NoWatchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                NoWatchButton.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
            }
            if (i == 0) {
                [NoWatchButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
                    make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
                    make.top.mas_equalTo(self.contentView.mas_top).offset(25);
                    make.height.mas_equalTo(44);
                }];
                
            }else{
                [NoWatchButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
                    make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
                    make.top.mas_equalTo(self.contentView.mas_top).offset(i * 45 + 25 + i * 15);
                    make.height.mas_equalTo(45);
                }];
            }
            
            
            
            
        }
        
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
    
    if (self.DidOpeClick) {
        self.DidOpeClick(btn.tag - 100);
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

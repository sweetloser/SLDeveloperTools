//
//  BXDynMoreAlertView.m
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynMoreAlertView.h"
#import "HttpMakeFriendRequest.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXDynMoreAlertView()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic ,strong)NSString *agent_name;
@property(nonatomic ,strong)NSString *user_id;
@end

@implementation BXDynMoreAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame model:(id)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.3];
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
        
        UIButton *NoWatchDynButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [NoWatchDynButton setTitle:@"不看这条动态" forState:UIControlStateNormal];
        NoWatchDynButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [NoWatchDynButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NoWatchDynButton.backgroundColor = sl_subBGColors;
        NoWatchDynButton.layer.cornerRadius = 22;
        NoWatchDynButton.tag = 101;
        NoWatchDynButton.layer.masksToBounds = YES;
        [NoWatchDynButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:NoWatchDynButton];
        [NoWatchDynButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
            make.top.mas_equalTo(NoWatchButton.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *ReportButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [ReportButton setTitle:@"举报" forState:UIControlStateNormal];
        ReportButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [ReportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        ReportButton.backgroundColor = sl_subBGColors;
        ReportButton.layer.cornerRadius = 22;
        ReportButton.tag = 102;
        ReportButton.layer.masksToBounds = YES;
        [ReportButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:ReportButton];
        [ReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
            make.top.mas_equalTo(NoWatchDynButton.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *CancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [CancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [CancleButton setTitleColor:UIColorHex(#FF2D52) forState:UIControlStateNormal];
        CancleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        CancleButton.tag = 103;
        CancleButton.layer.masksToBounds = YES;
        [CancleButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:CancleButton];
        [CancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-30));
            make.top.mas_equalTo(ReportButton.mas_bottom).offset(15);
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
    NSString *filter_type = @"";
//    if ((btn.tag - 100) == 0) {
//        filter_type = @"1";
//        [self ReturnResultAct:filter_type];
//    }
//    if ((btn.tag - 100) == 1) {
//        filter_type = @"2";
//        [self ReturnResultAct:filter_type];
//    }
//    else{
        if (self.determineBlock) {
            self.determineBlock(_user_id, btn.tag - 100);
        }
//    }
    [self hiddenView];
}
-(void)ReturnResultAct:(NSString *)filter_type{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest setFilterWithfilter_id:self.model.msgdetailmodel.user_id msgType:@"2" filter_type:filter_type filter_msg_id:self.model.fcmid Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            
        }
        
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
        [BGProgressHUD hidden];
        
    }];
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

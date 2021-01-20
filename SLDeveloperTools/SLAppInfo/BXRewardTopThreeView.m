//
//  BXRewardTopThreeView.m
//  BXlive
//
//  Created by bxlive on 2019/4/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXRewardTopThreeView.h"
#import "UIApplication+ActivityViewController.h"
//#import "BXPersonHomeVC.h"
#import "BXRewardListView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>
#import "BXLiveUser.h"

@interface BXRewardTopThreeView ()

@property (nonatomic, strong) UIImageView *bgIv;

@property (nonatomic, strong) NSMutableArray *userViews;
@property (nonatomic, strong) NSMutableArray *userHeadIvs;

@end

@implementation BXRewardTopThreeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        _bgIv = [[UIImageView alloc]init];
        _bgIv.alpha = .8;
        [self addSubview:_bgIv];
        [_bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _userViews = [NSMutableArray array];
        _userHeadIvs = [NSMutableArray array];
        UIView *firstView = nil;
        for (int i = 0; i < 3; i++) {
            UIView *userView = [[UIView alloc]init];
            userView.tag = i;
            userView.userInteractionEnabled = NO;
            [self addSubview:userView];
            [_userViews addObject:userView];
            
            UIImageView *headIv = [[UIImageView alloc]init];
            headIv.layer.masksToBounds = YES;
//            headIv.layer.borderColor = [UIColor whiteColor].CGColor;
//            headIv.layer.borderWidth = 1;
            headIv.tag = i;
            [userView addSubview:headIv];
            [_userHeadIvs addObject:headIv];
            
            NSString *imageName = [NSString stringWithFormat:@"reward_rank_%d",i + 1];
            UIImageView *rankIv = [[UIImageView alloc]init];
            rankIv.tag = i + 10;
            rankIv.image = CImage(imageName);
            [userView addSubview:rankIv];
            
            if (!i) {
                firstView = userView;
                [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(33);
                    make.centerX.centerY.mas_equalTo(0);
                }];
                headIv.layer.cornerRadius = 16.5;
                [rankIv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-5);
                    make.left.mas_equalTo(-4.5);
                    make.right.mas_equalTo(1);
                    make.bottom.mas_equalTo(2.5);
                }];
            } else {
                [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(28);
                    make.centerY.mas_equalTo(0);
                    if (i == 1) {
                        make.left.mas_equalTo(firstView.mas_right).offset(8);
                    } else {
                        make.right.mas_equalTo(firstView.mas_left).offset(-8);
                    }
                }];
                headIv.layer.cornerRadius = 14;
                [rankIv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-3.5);
                    make.left.mas_equalTo(-4.5);
                    make.right.mas_equalTo(1);
                    make.bottom.mas_equalTo(2);
                }];
            }
            [headIv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(0);
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    BXRewardListView *view = [[BXRewardListView alloc]initWithVideoId:_videoId];
    [view show];
}

- (void)setLiveUsers:(NSArray *)liveUsers {
    _liveUsers = liveUsers;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIView *userView = _userViews[i];
        if (!i) {
            if (liveUsers.count == 2) {
                [userView mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.centerX.mas_equalTo(-14);
                }];
            } else {
                [userView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                }];
            }
        }
        
        if (i < liveUsers.count) {
            userView.hidden = NO;
            BXLiveUser *liveUser = liveUsers[i];
            UIImageView *headIv = nil;
            if (i && (liveUsers.count == 3)) {
                if (i == 1) {
                    headIv = _userHeadIvs[2];
                    UIImageView *rankIv = [self viewWithTag:12];
                    rankIv.image = CImage(@"reward_rank_2");
                } else {
                    headIv = _userHeadIvs[1];
                    UIImageView *rankIv = [self viewWithTag:11];
                    rankIv.image = CImage(@"reward_rank_3");
                }
            } else {
                headIv = _userHeadIvs[i];
            }
            [headIv sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:CImage(@"placeholder_avatar")];
        } else {
            userView.hidden = YES;
        }
    }
    
    NSString *imageName = [NSString stringWithFormat:@"reward_topThree_0%lu",(unsigned long)liveUsers.count];
    _bgIv.image = CImage(imageName);
}

- (void)startAnimation {
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toInitialState) object:nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(0.0f);
    scaleAnimation.toValue = @(1.0f);
    scaleAnimation.duration = .2;
    [self.layer addAnimation:scaleAnimation forKey:nil];
    
    [self performSelector:@selector(toInitialState) withObject:nil afterDelay:5.0];
}

- (void)toInitialState {
    [self.layer removeAllAnimations];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(1.0f);
    scaleAnimation.toValue = @(0.0f);
    scaleAnimation.duration = .2;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:nil];
}

@end

//
//  BXHLuxuryGiftForCastleOfLove.m
//  BXlive
//
//  Created by bxlive on 2018/11/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXHLuxuryGiftForCastleOfLove.h"
#import <YYImage.h>
#import "SLDeveloperTools.h"

#define kScale(point) ((point) * (([UIScreen mainScreen].bounds.size.height == 480 || [UIScreen mainScreen].bounds.size.height == 568) ? 0.85 : ([UIScreen mainScreen].bounds.size.height == 667 ? 1 : 1.1)))

@interface BXHLuxuryGiftForCastleOfLove ()

@property (nonatomic, strong) UIImageView *receiverAvatarImageView; //主播头像
@property (nonatomic, strong) UIImageView *senderAvatarImageView; //赠送人头像
@property (nonatomic , assign) BOOL animing;
@end

@implementation BXHLuxuryGiftForCastleOfLove

- (instancetype)initWithAvatar:(NSString *)avatar Anchor_avatar:(NSString *)anchor_avatar GiftId:(nonnull NSString *)giftId oneFrameDuration:(NSTimeInterval)oneFrameDuration layout:(NSInteger)layout{
    self = [super initWithGiftId:giftId oneFrameDuration:oneFrameDuration layout:layout];
    if (self) {
        
        [self addSubview:self.receiverAvatarImageView];
        [self.receiverAvatarImageView zzl_setImageWithURLString:[NSURL URLWithString:avatar] placeholder:[UIImage imageNamed:@"placeplaceholder"]];
        
        [self addSubview:self.senderAvatarImageView];
        [self.senderAvatarImageView zzl_setImageWithURLString:[NSURL URLWithString:anchor_avatar] placeholder:[UIImage imageNamed:@"placeplaceholder"]];
        
        self.receiverAvatarImageView.center = CGPointMake(-kScale(25), SCREEN_HEIGHT / 2);
        self.senderAvatarImageView.center = CGPointMake(SCREEN_WIDTH + kScale(25), SCREEN_HEIGHT / 2);
        
        [self avatarAnimateBegin];
    }
    return self;
}

- (void)animationEffectDidEnd {
    self.animing = NO;
    [super animationEffectDidEnd];
}

- (void)avatarAnimateBegin {
    [UIView animateWithDuration:0.5 delay:4.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.receiverAvatarImageView.center = CGPointMake(SCREEN_WIDTH/2 - kScale(25), kScale(200));
        self.senderAvatarImageView.center = CGPointMake(SCREEN_WIDTH/2 + kScale(25), kScale(200));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.875 animations:^{
            self.receiverAvatarImageView.center = CGPointMake(SCREEN_WIDTH/2 - kScale(75), kScale(200));
            self.senderAvatarImageView.center = CGPointMake(SCREEN_WIDTH/2 + kScale(90), kScale(200));
        }];
        [UIView animateWithDuration:0.1875 animations:^{
            self.receiverAvatarImageView.transform = CGAffineTransformMakeScale(0.5, 1);
            self.senderAvatarImageView.transform = CGAffineTransformMakeScale(0.5, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1875 animations:^{
                self.receiverAvatarImageView.transform = CGAffineTransformIdentity;
                self.senderAvatarImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                CGPoint receiverAvatarImageViewCenter = self.receiverAvatarImageView.center;
                CGPoint senderAvatarImageViewCenter = self.senderAvatarImageView.center;
                
                [self shakeAnimationWithReceiverAvatarCenter:receiverAvatarImageViewCenter senderAvatarCenter:senderAvatarImageViewCenter];
            }];
        }];
    }];
    [UIView animateWithDuration:1.75 delay:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.receiverAvatarImageView.alpha = 0;
        self.senderAvatarImageView.alpha = 0;
    } completion:nil];
}

- (void)shakeAnimationWithReceiverAvatarCenter:(CGPoint)rcenter senderAvatarCenter:(CGPoint)scenter {
    self.animing = YES;
    [UIView animateWithDuration:0.6 animations:^{
        self.receiverAvatarImageView.center = [self shakePositionFor:rcenter];
        self.senderAvatarImageView.center = [self shakePositionFor:scenter];
    } completion:^(BOOL finished) {
        if (self.animing) {
            [self shakeAnimationWithReceiverAvatarCenter:rcenter senderAvatarCenter:scenter];
        }
    }];
}

- (CGPoint)shakePositionFor:(CGPoint)center {
    NSInteger x = (int)(arc4random() % 7) - 3 + center.x;
    NSInteger y = (int)(arc4random() % 7) - 3 + center.y;
    return CGPointMake(x, y);
}

- (UIImageView *)receiverAvatarImageView {
    if (!_receiverAvatarImageView) {
        _receiverAvatarImageView = [UIImageView new];
        _receiverAvatarImageView.frame = CGRectMake(0, 0, kScale(50), kScale(50));
        _receiverAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _receiverAvatarImageView.layer.borderWidth = 3;
        _receiverAvatarImageView.layer.masksToBounds = YES;
        _receiverAvatarImageView.layer.cornerRadius = kScale(25);
    }
    return _receiverAvatarImageView;
}

- (UIImageView *)senderAvatarImageView {
    if (!_senderAvatarImageView) {
        _senderAvatarImageView = [UIImageView new];
        _senderAvatarImageView.frame = CGRectMake(0, 0, kScale(50), kScale(50));
        _senderAvatarImageView.layer.cornerRadius = kScale(25);
        _senderAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _senderAvatarImageView.layer.borderWidth = 3;
        _senderAvatarImageView.layer.masksToBounds = YES;
    }
    return _senderAvatarImageView;
}

@end

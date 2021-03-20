//
//  BXDynNewHeaderView.m
//  BXlive
//
//  Created by mac on 2020/6/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNewHeaderView.h"
#import "../SLCategory/SLCategory.h"
#import "FilePathHelper.h"
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import "../SLMacro/SLMacro.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <SDWebImage/SDWebImage.h>
#import <AVFoundation/AVFoundation.h>
@interface BXDynNewHeaderView()
@property(nonatomic, strong)UIImageView *userImage;
@property(nonatomic, strong)UIImageView *user_genderImage;
@property(nonatomic, strong)UIImageView *friendImage;
@property(nonatomic, strong)UIImageView *friend_genderImage;
@property(nonatomic, strong)UIImageView *backImage;
@property(nonatomic, strong)UIImageView *coverImage;
@property(nonatomic, strong)UIImageView *dian_zanImage;

@property(nonatomic, strong)YYLabel *usernamelable;
@property(nonatomic, strong)YYLabel *friendnamelable;
@property(nonatomic, strong)UILabel *dian_zanlable;
@property(nonatomic, strong)YYLabel *contentlable;

@property(nonatomic, strong)UILabel *timelabel;

@property(nonatomic, assign)NSInteger duration;
@property(nonatomic, strong)NSString *pathfile;
@end
@implementation BXDynNewHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initview];
    }
    return self;
}
-(void)initview{
    UIView *backview = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:backview];
    WS(weakSelf);
    //背景
    _backImage = [[UIImageView alloc]init];
    _backImage.layer.cornerRadius = 10;
    _backImage.layer.masksToBounds = YES;
    _backImage.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.21 alpha:1.00];
    _backImage.userInteractionEnabled = YES;
    [backview addSubview:_backImage];
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview.mas_left).offset(12);
        make.right.mas_equalTo(backview.mas_right).offset(-12);
        make.top.mas_equalTo(backview.mas_top).offset(30);
        make.height.mas_equalTo(200);
    }];
    
    //女头像
    _friendImage = [[UIImageView alloc]init];
    _friendImage.backgroundColor = sl_subBGColors;
    _friendImage.layer.borderWidth = 2;
    _friendImage.layer.borderColor = UIColorHex(#505258).CGColor;
    _friendImage.layer.cornerRadius = 30;
    _friendImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *friendtap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        NSString *uid = [NSString stringWithFormat:@"%@",weakSelf.model.msgdetailmodel.friend_user_id];
        if (!IsNilString(uid)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":self->_model.msgdetailmodel.friend_user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
        }
        
//        [BXPersonHomeVC toPersonHomeWithUserId:self->_model.msgdetailmodel.friend_user_id isShow:nil nav:self.viewController.navigationController handle:nil];
    }];
    [_friendImage addGestureRecognizer:friendtap];
    _friendImage.userInteractionEnabled = YES;
    [backview addSubview:_friendImage];
    [_friendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backImage.mas_left).offset(55);
        make.top.mas_equalTo(_backImage.mas_top).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    //男头像
    _userImage = [[UIImageView alloc]init];
    _userImage.backgroundColor = sl_subBGColors;
    _userImage.layer.borderWidth = 2;
    _userImage.layer.borderColor = UIColorHex(#505258).CGColor;
    _userImage.layer.cornerRadius = 30;
    _userImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *usertap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        NSString *uid = [NSString stringWithFormat:@"%@",weakSelf.model.msgdetailmodel.user_id];
        if (!IsNilString(uid)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":self->_model.msgdetailmodel.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
        }
        
//        [BXPersonHomeVC toPersonHomeWithUserId:self->_model.msgdetailmodel.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
    }];
    [_userImage addGestureRecognizer:usertap];
    _userImage.userInteractionEnabled = YES;
    [backview addSubview:_userImage];
    [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backImage.mas_left).offset(20);
        make.top.mas_equalTo(_backImage.mas_top).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    //男名字
    _usernamelable = [[YYLabel alloc]init];
    _usernamelable.font = [UIFont systemFontOfSize:12];
    _usernamelable.textColor = [UIColor whiteColor];
    [backview addSubview:_usernamelable];
    [_usernamelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_friendImage.mas_right).offset(10);
        make.top.mas_equalTo(_backImage.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //男性别标识
    _user_genderImage = [[UIImageView alloc]init];
    _user_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
    [backview addSubview:_user_genderImage];
    [_user_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_usernamelable.mas_right).offset(5);
        make.centerY.mas_equalTo(_usernamelable.mas_centerY);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    //女名字
    _friendnamelable = [[YYLabel alloc]init];
    _friendnamelable.textColor = [UIColor whiteColor];
    _friendnamelable.font = [UIFont systemFontOfSize:12];
    [backview addSubview:_friendnamelable];
    [_friendnamelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_friendImage.mas_right).offset(10);
        make.top.mas_equalTo(_usernamelable.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    //女性别标识
    _friend_genderImage = [[UIImageView alloc]init];
    _friend_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    [backview addSubview:_friend_genderImage];
    [_friend_genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_friendnamelable.mas_right).offset(5);
        make.centerY.mas_equalTo(_friendnamelable.mas_centerY);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    _dian_zanlable = [[UILabel alloc]init];

    _dian_zanlable.textColor = UIColorHex(#FEE157);
    _dian_zanlable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [backview addSubview:_dian_zanlable];
    [_dian_zanlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backImage.mas_right).offset(-20);
        make.centerY.mas_equalTo(_usernamelable.mas_bottom);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    //
    _dian_zanImage = [[UIImageView alloc]init];
    _dian_zanImage.image = [UIImage imageNamed:@"express_Numicon"];
    [backview addSubview:_dian_zanImage];
    [_dian_zanImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_dian_zanlable.mas_left).offset(-5);
        make.centerY.mas_equalTo(_usernamelable.mas_bottom);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    //封面
    _coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 60 , backview.frame.size.width - 28,  138)];
//    _coverImage.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *moretap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
    [_coverImage addGestureRecognizer:moretap1];
    _coverImage.userInteractionEnabled = YES;
    _coverImage.contentMode=UIViewContentModeScaleAspectFill;
    _coverImage.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.coverImage.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.coverImage.bounds;
    maskLayer.path = maskPath.CGPath;
    self.coverImage.layer.mask = maskLayer;

    [_backImage addSubview:_coverImage];
//    [_coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_backImage.mas_left).offset(2);
//        make.right.mas_equalTo(_backImage.mas_right).offset(-2);
//        make.top.mas_equalTo(_girlnamelable.mas_bottom).offset(10);
//        make.bottom.mas_equalTo(_backImage.mas_bottom).offset(-2);
//    }];
    UIImageView *hazyImageview = [[UIImageView alloc]init];
//    hazyImageview.image = CImage(@"express_wall_big");
    hazyImageview.backgroundColor = [UIColor blackColor];
    hazyImageview.alpha = 0.5;
    [_coverImage addSubview:hazyImageview];
    [hazyImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(0);
    }];
    
    //内容
    self.contentlable = [[YYLabel alloc]init];
    self.contentlable.clearContentsBeforeAsynchronouslyDisplay = NO;
    UIEdgeInsets textContainerInset1 = self.contentlable.textContainerInset;
    textContainerInset1.top = 0;
    textContainerInset1.bottom = 0;
    self.contentlable.textContainerInset = textContainerInset1;
    self.contentlable.numberOfLines = 0 ;
    self.contentlable.font = CFont(15);
    self.contentlable.textAlignment = NSTextAlignmentCenter;
    [_coverImage addSubview:_contentlable];
    [_contentlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_coverImage.mas_centerY);
        make.left.mas_equalTo(_coverImage.mas_left).offset(20);
        make.right.mas_equalTo(_coverImage.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    //更多
    UIImageView *moreimage = [[UIImageView alloc]init];
    moreimage.image = [UIImage imageNamed:@"icon_dyn_more"];
    UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
    [moreimage addGestureRecognizer:moretap];
    moreimage.userInteractionEnabled = YES;
    [_coverImage addSubview:moreimage];
    [moreimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_coverImage.mas_right).offset(-10);
        make.bottom.mas_equalTo(_coverImage.mas_bottom).offset(-20);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    UILabel *morelabel = [[UILabel alloc]init];
    morelabel.text  = @"更多表白";
    morelabel.textColor = [UIColor whiteColor];
    morelabel.font = [UIFont systemFontOfSize:17];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
    [morelabel addGestureRecognizer:tap];
    morelabel.userInteractionEnabled = YES;
    [_coverImage addSubview:morelabel];
    [morelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(moreimage.mas_left).offset(-5);
        make.centerY.mas_equalTo(moreimage.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    _VoiceImageView = [[UIImageView alloc]init];
    _VoiceImageView.layer.cornerRadius = 10;
    _VoiceImageView.layer.masksToBounds = YES;
    //    _VoiceImageView.backgroundColor = [UIColor greenColor];
    _VoiceImageView.image = [UIImage imageNamed:@"express_sound_note"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        if ([self.delegate respondsToSelector:@selector(didClickplayCell:)]) {
//            [self.delegate didClickplayCell:self];
//        }
    }];
    [_VoiceImageView addGestureRecognizer:tap1];
    _VoiceImageView.userInteractionEnabled = YES;
    [_coverImage addSubview:_VoiceImageView];
    [_VoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_coverImage.mas_centerY);
        make.left.mas_equalTo(_coverImage.mas_left).offset(77);
        make.width.mas_equalTo(103);
        make.height.mas_equalTo(27);
    }];
    
    
    _duratimelable = [[UILabel alloc]init];
    _duratimelable.textColor = [UIColor whiteColor];
    _duratimelable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _duratimelable.textAlignment = 1;
    [_coverImage addSubview:_duratimelable];
    [_duratimelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_coverImage.mas_centerY);
        make.left.mas_equalTo(_VoiceImageView.mas_right).offset(16);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
//    _backImage.userInteractionEnabled = YES;
    
}
-(void)setModel:(BXDynamicModel *)model{
    [model.msgdetailmodel processAttributedString];
    _model = model;
    _dian_zanlable.text = [NSString stringWithFormat:@"%@", model.alreadysend];
    _usernamelable.text = model.msgdetailmodel.nickname;
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.avatar]];
    if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.gender] isEqualToString:@"2"]) {
            _user_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
        }else{
            _user_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
        }
//     _girl_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    [_usernamelable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_friendImage.mas_right).offset(10);
        make.top.mas_equalTo(_backImage.mas_top).offset(10);
        make.width.mas_equalTo([UILabel getWidthWithTitle:_usernamelable.text font:_usernamelable.font]);
        make.height.mas_equalTo(20);
    }];
    [_dian_zanlable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UILabel getWidthWithTitle:self.dian_zanlable.text font:self.dian_zanlable.font]);
    }];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"真情告白%@", model.msgdetailmodel.friend_nickname]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorHex(#8C8C8C) range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(4, model.msgdetailmodel.friend_nickname.length)];
    self.friendnamelable.attributedText = str;
    _friendnamelable.font = SLPFFont(12);
        [self.friendImage sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.friend_avatar]];
    
    if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.friend_gender] isEqualToString:@"2"]) {
        _friend_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    }else{
        _friend_genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
    }
    [_friendnamelable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_friendImage.mas_right).offset(10);
        make.top.mas_equalTo(_usernamelable.mas_bottom);
        make.width.mas_equalTo([UILabel getWidthWithTitle:_friendnamelable.text font:_friendnamelable.font]);
        make.height.mas_equalTo(20);
    }];
    
    _contentlable.attributedText = model.msgdetailmodel.attatties;
    _contentlable.textColor = UIColorHex(#F8F8F8);
    _contentlable.textAlignment = 1;
    if (IsNilString(model.msgdetailmodel.smallcover_url)) {
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.avatar] placeholderImage:CImage(@"video-placeholder")];
    }else{
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.smallcover_url] placeholderImage:CImage(@"video-placeholder")];
    }
    
    if (self.model.msgdetailmodel.voice && ![self.model.msgdetailmodel.voice isEqualToString:@""]) {
        self.VoiceImageView.hidden = NO;
        self.duratimelable.hidden = NO;
        self.contentlable.hidden = YES;
    }else{
        self.VoiceImageView.hidden = YES;
        self.duratimelable.hidden = YES;
        self.contentlable.hidden = NO;
    }
    
    WS(weakSelf);
        dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *urlstr = self.model.msgdetailmodel.voice;
                
                NSURL *url = [NSURL URLWithString:urlstr];
                NSData *audata = [NSData dataWithContentsOfURL:url];
                weakSelf.pathfile = [self getImageFilePath:audata];
                
                AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: [NSURL URLWithString:self.pathfile] error:nil];
                weakSelf.duration = avAudioPlayer.duration;

                dispatch_group_leave(group);
            });
        });

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            weakSelf.duratimelable.text = [self getFormatString:self.duration];
        });
}
-(void)moreAct{
    if (self.DidClickMore) {
        self.DidClickMore();
    }
}
- (void)rotateView{
    [_VoiceImageView.layer removeAllAnimations];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_VoiceImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)StoprotateView{
    [_VoiceImageView.layer removeAllAnimations];
}
- (NSString *)getFormatString:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}
//获取暂时文件路径
-(NSString *)getImageFilePath:(NSData *)Data {
    NSString *path = [[FilePathHelper getCachesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"wd%@.mp3",self.model.fcmid]];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [Data writeToFile:path atomically:YES];
    return path;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

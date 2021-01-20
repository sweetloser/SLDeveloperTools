//
//  BXMuiscReusableView.m
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMuiscReusableView.h"
//#import "BXPersonHomeVC.h"
#import "BXMusicManager.h"
#import <Masonry/Masonry.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDwebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>
#import "SLAppInfoConst.h"
@interface BXMuiscReusableView ()

@property (nonatomic, strong) UIImageView *effectView;
@property (nonatomic, strong) UIView *visualEffectView;
@property (nonatomic, strong) UIImageView *coverIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *playCountLb;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic,assign)CGFloat offsetY;

@property(nonatomic,strong) UIView *bottomCornerV;

@end

@implementation BXMuiscReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _offsetY = __ScaleWidth(41);
        _effectView = [[UIImageView alloc]init];
        _effectView.contentMode = UIViewContentModeScaleAspectFill;
        _effectView.alpha = .3;
        [self addSubview:_effectView];
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
            make.top.mas_equalTo(-__ScaleWidth(101));
        }];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        [self addSubview:_visualEffectView];
        [_visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.effectView);
            make.height.mas_equalTo(1.5 * __kHeight);
        }];
        
        _coverIv = [[UIImageView alloc]init];
        _coverIv.contentMode = UIViewContentModeScaleAspectFill;
        _coverIv.clipsToBounds = YES;
        _coverIv.image = CImage(@"placeholder_avatar");
        _coverIv.layer.cornerRadius = 12;
        _coverIv.layer.masksToBounds = YES;
        _coverIv.userInteractionEnabled = YES;
        [self addSubview:_coverIv];
        [_coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.top.mas_equalTo(__ScaleWidth(103-41-__kTopAddHeight) + __kTopAddHeight);
            make.height.width.mas_equalTo(__ScaleWidth(115));
        }];
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = [UIColor sl_colorWithHex:0xF8F8F8];
        _titleLb.font = SLBFont(18);
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverIv.mas_right).offset(__ScaleWidth(15));
            make.right.mas_equalTo(-__ScaleWidth(18));
            make.top.mas_equalTo(self.coverIv);
            make.height.mas_equalTo(__ScaleWidth(50));
        }];
        _titleLb.numberOfLines = 2;
        
        _nickLabel = [UILabel initWithFrame:CGRectZero size:12 color:[UIColor sl_colorWithHex:0xF8F8F8] alignment:NSTextAlignmentLeft lines:1];
        _nickLabel.font = SLPFFont(14);
        [self addSubview:_nickLabel];
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverIv.mas_right).offset(__ScaleWidth(15));
            make.width.mas_lessThanOrEqualTo(150);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(__ScaleWidth(10));
            make.height.mas_equalTo(__ScaleWidth(20));
        }];
        
//        UIImageView *nextImage = [UIImageView new];
//        nextImage.image = CImage(@"icon_next");
//        [self addSubview:nextImage];
//        [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.nickLabel.mas_right).offset(5);
//            make.width.height.mas_equalTo(12);
//            make.centerY.mas_equalTo(self.nickLabel.mas_centerY);
//        }];
        
        _collectionBtn = [[UIButton alloc]init];
       [_collectionBtn setImage:CImage(@"collection_like") forState:BtnNormal];
       [_collectionBtn setImage:CImage(@"collection_liked") forState:BtnSelected];
       [_collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:BtnTouchUpInside];
       [self addSubview:_collectionBtn];
       [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(__ScaleWidth(84));
           make.height.mas_equalTo(__ScaleWidth(30));
           make.bottom.mas_equalTo(self.coverIv.mas_bottom);
           make.right.mas_equalTo(__ScaleWidth(-12));
       }];
        
        _playCountLb = [[UILabel alloc]init];
        _playCountLb.textColor = [UIColor sl_colorWithHex:0xF8F8F8];
        _playCountLb.font = SLBFont(__ScaleWidth(14));
        [self addSubview:_playCountLb];
        [_playCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLb);
            make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(__ScaleWidth(10));
            make.height.mas_equalTo(__ScaleWidth(20));
            make.right.equalTo(self.collectionBtn.mas_right).offset(-__ScaleWidth(10));
        }];
        
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tap1.numberOfTapsRequired = 1;
        tap1.numberOfTouchesRequired = 1;
        [_nickLabel addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        [_nickLabel addGestureRecognizer:tap2];
        _nickLabel.userInteractionEnabled = YES;
//        nextImage.userInteractionEnabled = YES;
       
         _playBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(12) Color:[UIColor whiteColor] Image:CImage(@"icon_music_play") Target:self action:@selector(playBtnClick:) forControlEvents:BtnTouchUpInside];
        [_playBtn setImage:CImage(@"icon_music_pause") forState:BtnSelected];
        [_playBtn setImage:CImage(@"icon_music_play") forState:BtnNormal];
        [_coverIv addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(50);
        }];
        
//        底部圆角视图
        _bottomCornerV = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bottomCornerV];
        [_bottomCornerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(__ScaleWidth(41));
        }];
//        添加圆角
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, __ScaleWidth(41)) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _bottomCornerV.layer.mask = shapeLayer;
        _bottomCornerV.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    }
    return self;
}
-(void)tapClick{
    if ([BXLiveUser isLogin]) {
        if ([_music.user_id integerValue]) {
            self.playBtn.selected = NO;
            [[BXMusicManager sharedManager] stopPlay];
            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_music.user_id,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
//            [BXPersonHomeVC toPersonHomeWithUserId:_music.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
        }
    } else {
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.viewController.navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":self.viewController.navigationController}];
    }
}

-(void)playBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playMuiscBtn:)]) {
        [self.delegate playMuiscBtn:sender];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CALayer *layer = self.layer.mask;
    if (!layer) {
        CALayer *layer = [[CALayer alloc]init];
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.mask = layer;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    layer.frame = CGRectMake(0, -self.mj_h, self.mj_w, self.mj_h * 2);
    [CATransaction commit];
}

- (void)collectionAction {
    if ([BXLiveUser isLogin]) {
        [NewHttpManager collectionAddWithTargetId:_music.music_id type:@"music" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            if (flag) {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                NSDictionary *dataDic = jsonDic[@"data"];
                self.music.is_collect = dataDic[@"status"];
                self.collectionBtn.selected = [self.music.is_collect integerValue];
            } else {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            [BGProgressHUD showInfoWithMessage:@"操作失败"];
        }];
    } else {
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.viewController.navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":self.viewController.navigationController}];
    }
}



- (void)setMusic:(BXMusicModel *)music {
    _music = music;
    
    [_effectView sd_setImageWithURL:[NSURL URLWithString:music.image] placeholderImage:CImage(@"placeholder_avatar")];
    [_coverIv sd_setImageWithURL:[NSURL URLWithString:music.image] placeholderImage:CImage(@"placeholder_avatar")];
    _titleLb.text = music.title;
    _playCountLb.text = [NSString stringWithFormat:@"%@ 人参与",music.use_num];
    _nickLabel.text = music.singer;
    _collectionBtn.selected = [music.is_collect integerValue];
    
    
}

- (void)setOffset:(CGFloat)offset {
    if (offset <= 0) {
        CGRect frame = _effectView.frame;
        frame.origin.y = offset - 60;
        frame.size.height = -offset + self.mj_h + 60;
        _effectView.frame = frame;
    }
    _offset = offset;
}


@end


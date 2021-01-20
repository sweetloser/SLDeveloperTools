//
//  BXDynClickPlayVC.m
//  BXlive
//
//  Created by mac on 2020/8/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynClickPlayVC.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "BXNormalControllView.h"
#import "BXTextScrollView.h"
#import "BXTransitionAnimation.h"
#import "BXKTVHTTPCacheManager.h"
#import "SLAppInfoMacro.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface BXDynClickPlayVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIImageView *musicIcon;
@property (nonatomic ,strong) UIButton *playBtn;//播放文字
@property (nonatomic, strong) BXTextScrollView *musicName;
@property (nonatomic, strong) BXDynamicModel *model;
//动画过渡转场
@property (nonatomic, strong) BXTransitionAnimation * transitionAnimation;

@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation BXDynClickPlayVC

-(instancetype)initWithVideoModel:(BXDynamicModel *)model{
    if (self = [super init]) {
        self.model = model;
        self.transitionAnimation.transitionType = BXTransitionTypePresent;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:self.backView atIndex:0];
    
    
    [self.view addSubview:self.containerView];
    
    [self.player addPlayerViewToContainerView:self.containerView];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.containerView addGestureRecognizer:pan];

    [self setupUI];
    

}

//全屏播放
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.model.isPlay) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self.player.currentPlayerManager selector:@selector(play) userInfo:nil repeats:NO];
    }
}


- (void)tapClicked{
     [self.player addPlayerViewToContainerView:self.containerView];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self backPlayVideo];
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
    if (_moveState) {
        _moveState(panGesture.state);
    }
    
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
        self.bottomView.hidden = YES;
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGPoint  translation = [panGesture translationInView:self.view];
        self.containerView.center = CGPointMake(self.containerView.center.x + translation.x, self.containerView.center.y + translation.y);
        
        CGFloat scale = 1 - ABS(point.y - _startPoint.y) / (__kHeight * 1.2);
        if (scale > 1) scale = 1;
        if (scale < 0.35) scale = 0.35;
        self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
        
        CGFloat alpha = 1 - ABS(point.y - _startPoint.y) / (__kHeight * 1.1);
        if (alpha > 1) alpha = 1;
        if (alpha < 0) alpha = 0;
        self.backView.alpha = alpha;
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed) {
        CGPoint velocity = [panGesture velocityInView:self.view];
        BOOL velocityArrive = ABS(velocity.y) > 800;
        BOOL distanceArrive = ABS(point.y - _startPoint.y) > __kHeight * .22;
        
        BOOL shouldDismiss = distanceArrive || velocityArrive;
        if (shouldDismiss) {
            [self tapClicked];
        } else {
            self.containerView.center = CGPointMake(__kWidth / 2, __kHeight / 2);
            self.containerView.transform = CGAffineTransformIdentity;
        }
        self.bottomView.hidden = NO;
    }
    [panGesture setTranslation:CGPointZero inView:self.view];
}

#pragma mark -- Getter
- (BXTransitionAnimation *)transitionAnimation{
    
    if (_transitionAnimation == nil) {
        _transitionAnimation = [[BXTransitionAnimation alloc] init];
        self.transitioningDelegate = self;
    }
    return _transitionAnimation;
}


- (UIView *)containerView{
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        _containerView.userInteractionEnabled = YES;
        [_containerView addGestureRecognizer:tap];
    }
    return _containerView;
}

#pragma mark -- UIViewControllerTransitioningDelegate

//返回一个处理present动画过渡的对象
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.transitionAnimation;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    self.transitionAnimation.transitionType = BXTransitionTypeDissmiss;
    return self.transitionAnimation;
}


-(void)setupUI{
    self.bottomView = [UIView new];
    [self.containerView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
    }];
    
    self.playBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(12) Color:TextBrightestColor Image:CImage(@"icon_music_pause") Target:self action:@selector(playVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setImage:CImage(@"icon_music_pause") forState:BtnNormal];
    [self.playBtn setImage:CImage(@"icon_music_play") forState:BtnSelected];
    [self.bottomView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-8);
    }];

    //滚动文字
//    self.musicIcon = [[UIImageView alloc]init];
//    self.musicIcon.contentMode = UIViewContentModeCenter;
//    self.musicIcon.image = [UIImage imageNamed:@"icon_home_musie"];
//    [self.bottomView addSubview:_musicIcon];
//    [self.musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(0);
//        make.left.mas_equalTo(2);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(18);
//    }];
//

//    self.musicName = [[BXTextScrollView alloc]init];
//    self.musicName.font = CBFont(15);
//    [self.bottomView addSubview:self.musicName];
//    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(24);
//        make.left.mas_equalTo(self.musicIcon.mas_right).offset(1);
//        make.centerY.mas_equalTo(0);
//        make.right.mas_equalTo(self.playBtn.mas_left).offset(-8);
//    }];

    
//    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", _model.bgMusic.title, _model.nickname]];
//    [_musicName setTextColor:[UIColor whiteColor]];
//    [_musicName startAnimation];
    if (_model.isPlay) {
//        [self.musicName resume];
        self.playBtn.selected = NO;
    }else{
//        [self.musicName pause];
        self.playBtn.selected = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


-(void)playVideoBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
//        [self.musicName pause];
        self.model.isPlay = NO;
        [self.player.currentPlayerManager pause];
    }else{
//        [self.musicName resume];
        self.model.isPlay = YES;
        [self.player.currentPlayerManager play];
    }
}

-(void)backPlayVideo{
    if (self.detailPlayCallback) {
        self.detailPlayCallback(self.model);
    }
}




@end

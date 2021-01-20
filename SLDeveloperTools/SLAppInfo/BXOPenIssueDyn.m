//
//  BXOPenIssueDyn.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXOPenIssueDyn.h"
#import "HPGrowingTextView.h"
#import "BXAiteFriendVC.h"
#import "BXIssueDynCommentView.h"
#import "BXDynAddHuaTiVC.h"
#import "BXDynIssueRulesView.h"
#import "BXDynAddCircleVC.h"
#import "AddPictureCell.h"
#import "BXHHEmojiView.h"
#import <HXPhotoPicker.h>
#import "FilePathHelper.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BXLocation.h"
#import "BXDynIssueSelView.h"
#import "DynPlayMp3Voice.h"
#import "BXDynAiTeCategoryVC.h"
#import "BXShortVideoLocationSearchVC.h"
#import "HttpMakeFriendRequest.h"
//#import "HHHttpRequestManager.h"
#import "BXDynTopicModel.h"
#import "BXNormalControllView.h"
#import "BXTextScrollView.h"
#import "HZPhotoBrowser.h"
#import "AddPicturePhotoShow.h"
#import <YYCategories/YYCategories.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLUpLoadAndDownloadTools.h"
#import "../SLCategory/SLCategory.h"


@interface BXOPenIssueDyn ()<HPGrowingTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate,UIImagePickerControllerDelegate, IssueViewTextDelegate, IssueDataDelegate, playDelegate>
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property (strong, nonatomic) NSMutableArray *AtArray;
@property (strong, nonatomic) NSMutableArray *SelFriendArray;
@property (strong, nonatomic) NSMutableArray *TopicTitledArray;
@property (strong, nonatomic) NSString *addressString;
@property (assign, nonatomic) BOOL ShowAddress;
@property (strong, nonatomic)BXLocation *location;

@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;

@property (strong, nonatomic) UIView *itemView1;
@property (strong, nonatomic) UIView *itemView2;
@property(strong, nonatomic) UIView *bottomView;
//@property(strong, nonatomic) BXIssueDynCommentView *Commentview;


@property (strong, nonatomic) UILabel *huaTiLabel;
@property (strong, nonatomic) UILabel *quanXianLabel;
@property (strong, nonatomic) NSString *quanXianType;
@property (strong, nonatomic) UILabel *diZhiLabel;
@property (strong, nonatomic) BXTextScrollView *diZhiNameView;
@property (strong, nonatomic) BXTextScrollView *CircleNameView;
@property (strong, nonatomic) UIButton *deladdressbtn;
@property (strong, nonatomic) UILabel *quanZiLabel;
@property (strong, nonatomic) UIImageView *diZhiimageView;
@property (strong, nonatomic) UIImageView *quanXianImageView;
@property (strong, nonatomic) UIButton *delcirclebtn;

@property (strong, nonatomic) UIImageView *MicrImageView;
@property (strong, nonatomic) UIImageView *PicImageView;
@property (strong, nonatomic) UIImageView *EmojiImageView;
@property (strong, nonatomic) UIImageView *AiTeImageView;
@property (strong, nonatomic) UIImageView *KeyWordImageView;

@property(nonatomic, strong)BXDynIssueSelView *IssueSelDownView;
@property(nonatomic, strong)UIImageView *VoiceImageView;
@property(nonatomic, strong)UIImageView *SoundNoteImageView;
@property(nonatomic, strong)UILabel *duratimelabel;
@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@property(nonatomic, strong)NSString *mp3Path;
@property(nonatomic, strong)NSString *voice_time;
@property(nonatomic, assign)NSInteger playFlag;

@property(nonatomic, strong)BXDynIssueRulesView *rulesView;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *AddPicArray;
@property(nonatomic, strong)NSMutableArray *PicUrlArray;

//@property(nonatomic, strong)UIImageView *VideoCoverImageView;
@property(nonatomic, strong)UIView *VideoView;
@property(nonatomic, strong)UIView *containtView;
@property(nonatomic, strong)NSString *VideoAssetString;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) BXNormalControllView *controlView;


@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (assign, nonatomic) BOOL isSelPicture;


@property(nonatomic, strong)NSString *selCircle_id;
@end

@implementation BXOPenIssueDyn
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
- (BXNormalControllView *)controlView {
    if (!_controlView) {
        _controlView = [BXNormalControllView new];
    }
    return _controlView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.IssueSelDownView) {
//        self.IssueSelDownView.frame = CGRectMake(0, __kHeight - 46, __kWidth, 270);
//    }
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.IssueSelDownView) {
        self.IssueSelDownView.frame = CGRectMake(0, __kHeight - 46 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight);
        self.IssueSelDownView.emojiView.hidden = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _AtArray = [[NSMutableArray alloc]init];
    _SelFriendArray = [[NSMutableArray alloc]init];
    _AddPicArray = [[NSMutableArray alloc]init];
    _TopicTitledArray = [[NSMutableArray alloc]init];
    self.isSelPicture = YES;
    [self.AddPicArray addObject:[UIImage imageNamed:@"dyn_issue_AddPic_tianJia_big"]];
    _PicUrlArray = [[NSMutableArray alloc]init];
    [self setNavView];
//    [self downIssueView];
    [self ConcentView];
    [self createCollectionView];
    [self initVideoView];
    [self setVoiceView];
    [self addItemView];
    [self updataView];
//    _location = (BXLocation *)[CacheHelper objectForKey:@"NowLocation"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLocation:) name:kDidGetLocationNotification object:nil];
    
        WS(weakSelf);
        _IssueSelDownView = [[BXDynIssueSelView alloc]initWithFrame:CGRectMake(0, __kHeight - 46 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight)];
        _IssueSelDownView.delegate = self;
        _IssueSelDownView.ReturnPath = ^(NSString * _Nonnull mp3Path) {
            [weakSelf.playSound StartPlayWithplaypath:mp3Path];
            weakSelf.mp3Path = mp3Path;
            weakSelf.VoiceImageView.hidden = NO;
        };
        _IssueSelDownView.delegate = self;
        [self.view addSubview:_IssueSelDownView];
         _playSound = [[DynPlayMp3Voice alloc]init];
        _playSound.delegate =self;
    
    
    self.playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:_containtView];
    self.player.controlView = self.controlView;
    self.player.WWANAutoPlay = YES;
    self.player.shouldAutoPlay = YES;
    self.player.allowOrentitaionRotation = NO;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesSingleTap;
    self.player.playerDisapperaPercent = 1;
    
    
    if (self.topicModel) {
        [self.growingTextView.internalTextView unmarkText];
        NSInteger index = self.growingTextView.text.length;
        index = self.growingTextView.selectedRange.location + self.growingTextView.selectedRange.length;
        [self.TopicTitledArray addObject:self.topicModel];
        UITextView *textView = weakSelf.growingTextView.internalTextView;
        NSString *insertString = [NSString stringWithFormat:@"#%@# ", self.topicModel.topic_name];
        NSMutableString *string = [NSMutableString stringWithString:textView.text];
        [string insertString:insertString atIndex:index];
        weakSelf.growingTextView.text = string;
        textView.selectedRange = NSMakeRange(index + insertString.length, 0);
    }
    
    if (self.circleModel) {
        self.quanZiLabel.text = IsNilString(self.circleModel.circle_name)?@"添加圈子":self.circleModel.circle_name;
        self.selCircle_id = self.circleModel.circle_id;
    }
    
}
-(void)initVideoView{
    _VideoView = [[UIView alloc]init];
    _VideoView.backgroundColor = [UIColor whiteColor];
    _VideoView.layer.masksToBounds = YES;
    _VideoView.layer.cornerRadius = 5;
    [self.view addSubview:_VideoView];
    [_VideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(10);
        make.width.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3);
        make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3 * 1.5);
    }];
    _containtView = [[UIView alloc]init];
    _containtView.backgroundColor = [UIColor clearColor];
    _containtView.layer.masksToBounds = YES;
    _containtView.layer.cornerRadius = 5;
    [_VideoView addSubview:_containtView];
    [_containtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
   UIButton *_Delbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _Delbtn.backgroundColor = [UIColor clearColor];
    _Delbtn.contentMode = UIViewContentModeScaleAspectFit;
    [_Delbtn setImage:[UIImage imageNamed:@"dyn_issue_Del_addPic"] forState:UIControlStateNormal];
    [_Delbtn addTarget:self action:@selector(delVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.VideoView addSubview:_Delbtn];
    [_Delbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.VideoView.mas_right).offset(-10);
        make.top.mas_equalTo(self.VideoView.mas_top).offset(10);
        make.width.height.mas_equalTo(18);
    }];
    _VideoView.hidden = YES;
    
}
//-(void)initScrollview{
//    _scrollView = [[UIScrollView alloc] init];
//    _scrollView.backgroundColor = [UIColor grayColor];
//    _scrollView.contentSize = self.view.frame.size;
    
//    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.top.mas_equalTo(self.navView.mas_bottom);
//        make.bottom.mas_equalTo(_Commentview.mas_top);
//    }];
//}
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
//    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AddPictureCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3 * 2 + 36);
    }];
}

-(void)addItemView{
    _itemView1 = [[UIView alloc]init];
    _itemView1.backgroundColor = UIColorHex(#F5F9FC);
    _itemView1.layer.cornerRadius = 17;
    _itemView1.layer.masksToBounds = YES;
    _itemView1.tag = 0;
    UITapGestureRecognizer *itemtap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACtion:)];
    [_itemView1 addGestureRecognizer:itemtap1];
    _itemView1.userInteractionEnabled = YES;
    [self.view addSubview:_itemView1];
    [_itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(30);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(32);
    }];
    UIImageView *huaTiImageview = [[UIImageView alloc]init];
    huaTiImageview.image = [UIImage imageNamed:@"dyn_issue_huati"];
    [_itemView1 addSubview:huaTiImageview];
    [huaTiImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_itemView1.mas_left).offset(15);
        make.top.mas_equalTo(_itemView1.mas_top).offset(8);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *huaTiLable = [[UILabel alloc]init];
    huaTiLable.text = @"添加话题";
    huaTiLable.textColor = [UIColor blackColor];
    huaTiLable.textAlignment = 0;
    huaTiLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [_itemView1 addSubview:huaTiLable];
    [huaTiLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huaTiImageview.mas_right).offset(5);
        make.top.mas_equalTo(_itemView1.mas_top).offset(6);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(20);
    }];
    
    
   _itemView2 = [[UIView alloc]init];
    _itemView2.backgroundColor = UIColorHex(#F5F9FC);
    _itemView2.layer.cornerRadius = 17;
    _itemView2.layer.masksToBounds = YES;
    _itemView2.tag = 1;
    UITapGestureRecognizer *itemtap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACtion:)];
    [_itemView2 addGestureRecognizer:itemtap2];
    _itemView2.userInteractionEnabled = YES;
    [self.view addSubview:_itemView2];
    [_itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(_itemView1.mas_top);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(32);
    }];
    _quanXianImageView = [[UIImageView alloc]init];
    _quanXianImageView.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all_nosel"];
//    _quanXianImageView.contentMode=UIViewContentModeScaleAspectFill;
//    _quanXianImageView.clipsToBounds=YES;
    [_itemView2 addSubview:_quanXianImageView];
    [_quanXianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_itemView2.mas_left).offset(15);
        make.top.mas_equalTo(_itemView2.mas_top).offset(8);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    
    _quanXianLabel = [[UILabel alloc]init];
    _quanXianLabel.text = @"所有人可见";
    _quanXianLabel.textColor = [UIColor blackColor];
    _quanXianType = @"1";
    _quanXianLabel.textAlignment = 0;
    _quanXianLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [_itemView2 addSubview:_quanXianLabel];
    [_quanXianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_quanXianImageView.mas_right).offset(5);
        make.top.mas_equalTo(_itemView2.mas_top).offset(6);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    UIView *itemview3 = [[UIView alloc]init];
    itemview3.backgroundColor = UIColorHex(#F5F9FC);
    itemview3.layer.cornerRadius = 17;
    itemview3.layer.masksToBounds = YES;
    itemview3.tag = 2;
    UITapGestureRecognizer *itemtap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACtion:)];
    [itemview3 addGestureRecognizer:itemtap3];
    itemview3.userInteractionEnabled = YES;
    [self.view addSubview:itemview3];
    [itemview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_itemView1.mas_left);
        make.top.mas_equalTo(_itemView1.mas_bottom).offset(10);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(32);
    }];
    _diZhiimageView = [[UIImageView alloc]init];
    _diZhiimageView.image = [UIImage imageNamed:@"dyn_issue_Undizhi"];
    [itemview3 addSubview:_diZhiimageView];
    [_diZhiimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(itemview3.mas_left).offset(15);
        make.top.mas_equalTo(itemview3.mas_top).offset(8);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(15);
    }];
    
    _diZhiLabel = [[UILabel alloc]init];
    _diZhiLabel.text = @"添加地址";
    _diZhiLabel.textColor = [UIColor blackColor];
    _diZhiLabel.textAlignment = 0;
    _diZhiLabel.font = SLBFont(14);
    [itemview3 addSubview:_diZhiLabel];
    [_diZhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_diZhiimageView.mas_right).offset(5);
        make.top.mas_equalTo(itemview3.mas_top).offset(6);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
//    _diZhiNameView = [[BXTextScrollView alloc]init];
//    _diZhiNameView.font = SLBFont(14);
//    [itemview3 addSubview:_diZhiNameView];
//    [_diZhiNameView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_diZhiimageView.mas_right).offset(2);
//        make.top.bottom.mas_equalTo(0);
//        make.right.equalTo(self.diZhiLabel);
//    }];
//    _diZhiNameView.hidden = YES;
    
    /*
     self.musicName = [[BXTextScrollView alloc]init];
     self.musicName.font = CBFont(15);
     [self.bottomView addSubview:self.musicName];
     [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(24);
         make.left.mas_equalTo(self.musicIcon.mas_right).offset(1);
         make.centerY.mas_equalTo(0);
         make.right.mas_equalTo(self.playBtn.mas_left).offset(-8);
     }];

     
     [_musicName setText:[NSString stringWithFormat:@"%@ - %@", _model.bgMusic.title, _model.nickname]];
     [_musicName setTextColor:[UIColor whiteColor]];
     [_musicName startAnimation];
     */
    
    _deladdressbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deladdressbtn addTarget:self action:@selector(DeleAddressAct) forControlEvents:UIControlEventTouchUpInside];
    [_deladdressbtn setImage:CImage(@"dyn_issue_Del_addPic") forState:UIControlStateNormal];
    [itemview3 addSubview:_deladdressbtn];
    [_deladdressbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(itemview3.mas_right).offset(-5);
        make.centerY.mas_equalTo(itemview3.mas_centerY);
        make.height.width.mas_equalTo(15);
    }];
    _deladdressbtn.hidden = YES;
    
    UIView *itemview4 = [[UIView alloc]init];
    itemview4.backgroundColor = UIColorHex(#F5F9FC);
    itemview4.layer.cornerRadius = 17;
    itemview4.layer.masksToBounds = YES;
    itemview4.tag = 3;
    UITapGestureRecognizer *itemtap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACtion:)];
    [itemview4 addGestureRecognizer:itemtap4];
    itemview4.userInteractionEnabled = YES;
    [self.view addSubview:itemview4];
    [itemview4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_itemView2.mas_left);
        make.top.mas_equalTo(_itemView2.mas_bottom).offset(10);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(32);
    }];
    UIImageView *quanziImageView = [[UIImageView alloc]init];
    quanziImageView.image = [UIImage imageNamed:@"dyn_issue_quanzi"];
    [itemview4 addSubview:quanziImageView];
    [quanziImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(itemview4.mas_left).offset(15);
        make.top.mas_equalTo(itemview4.mas_top).offset(8);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    _quanZiLabel = [[UILabel alloc]init];
    _quanZiLabel.text = @"添加圈子";
    _quanZiLabel.textColor = [UIColor blackColor];
    _quanZiLabel.textAlignment = 0;
    _quanZiLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [itemview4 addSubview:_quanZiLabel];
    [_quanZiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(quanziImageView.mas_right).offset(5);
        make.top.mas_equalTo(itemview4.mas_top).offset(6);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
//    _CircleNameView = [[BXTextScrollView alloc]init];
//    _CircleNameView.font = SLBFont(14);
//    [itemview4 addSubview:_CircleNameView];
//    [_CircleNameView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(quanziImageView.mas_right).offset(2);
//        make.top.bottom.mas_equalTo(0);
//        make.right.equalTo(self.quanZiLabel);
//    }];
//    _CircleNameView.hidden = YES;
    
    _delcirclebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_delcirclebtn addTarget:self action:@selector(DelecircleAct) forControlEvents:UIControlEventTouchUpInside];
    [_delcirclebtn setImage:CImage(@"dyn_issue_Del_addPic") forState:UIControlStateNormal];
    [itemview4 addSubview:_delcirclebtn];
    [_delcirclebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(itemview4.mas_right).offset(-5);
        make.centerY.mas_equalTo(itemview4.mas_centerY);
        make.height.width.mas_equalTo(15);
    }];
    _delcirclebtn.hidden = YES;
    
    
    WS(weakSelf);
    _rulesView = [[BXDynIssueRulesView alloc]init];
    _rulesView.backgroundColor = [UIColor whiteColor];
    _rulesView.ChooseRules = ^(NSInteger type) {
        if (type == 0) {
            weakSelf.quanXianImageView.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all_nosel"];
            weakSelf.quanXianLabel.text = @"所有人可见";
            
            weakSelf.rulesView.image1.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all"];
            weakSelf.rulesView.label1.textColor = UIColorHex(#EF6856);
            weakSelf.rulesView.image2.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend_gray"];
            weakSelf.rulesView.label2.textColor = [UIColor blackColor];
            weakSelf.rulesView.image3.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger_gray"];
            weakSelf.rulesView.label3.textColor =[UIColor blackColor];
            weakSelf.rulesView.image4.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own_gray"];
            weakSelf.rulesView.label4.textColor = [UIColor blackColor];
            
//            weakSelf.quanXianLabel.textColor = UIColorHex(#EF6856);
            weakSelf.quanXianType = @"1";
        }
        if (type == 1) {
            weakSelf.quanXianLabel.text = @"仅好友可见";
            weakSelf.quanXianImageView.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend_nosel"];

            
            weakSelf.rulesView.image1.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all_gray"];
            weakSelf.rulesView.label1.textColor = [UIColor blackColor];
            weakSelf.rulesView.image2.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend"];
            weakSelf.rulesView.label2.textColor = UIColorHex(#EF6856);
            weakSelf.rulesView.image3.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger_gray"];
            weakSelf.rulesView.label3.textColor =[UIColor blackColor];
            weakSelf.rulesView.image4.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own_gray"];
            weakSelf.rulesView.label4.textColor = [UIColor blackColor];
            
            weakSelf.quanXianType = @"2";
        }
        if (type == 2) {
            weakSelf.quanXianLabel.text = @"仅陌生人可见";
            weakSelf.quanXianImageView.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger_nosel"];

            
            weakSelf.rulesView.image1.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all_gray"];
            weakSelf.rulesView.label1.textColor = [UIColor blackColor];
            weakSelf.rulesView.image2.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend_gray"];
            weakSelf.rulesView.label2.textColor = [UIColor blackColor];
            weakSelf.rulesView.image3.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger"];
            weakSelf.rulesView.label3.textColor =UIColorHex(#EF6856);
            weakSelf.rulesView.image4.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own_gray"];
            weakSelf.rulesView.label4.textColor = [UIColor blackColor];
            weakSelf.quanXianType = @"3";
        }
        if (type == 3) {
            weakSelf.quanXianLabel.text = @"私密";
            weakSelf.quanXianImageView.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own_nosel"];

            
            weakSelf.rulesView.image1.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all_gray"];
            weakSelf.rulesView.label1.textColor = [UIColor blackColor];
            weakSelf.rulesView.image2.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend_gray"];
            weakSelf.rulesView.label2.textColor = [UIColor blackColor];
            weakSelf.rulesView.image3.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger_gray"];
            weakSelf.rulesView.label3.textColor = [UIColor blackColor];
            weakSelf.rulesView.image4.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own"];
            weakSelf.rulesView.label4.textColor = UIColorHex(#EF6856);
            weakSelf.quanXianType = @"4";
        }
        weakSelf.rulesView.hidden = YES;
    };
    [self.view addSubview:_rulesView];
    [_rulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_itemView2.mas_top).offset(-5);
        make.left.mas_equalTo(_itemView2.mas_left);
        make.right.mas_equalTo(_itemView2.mas_right);
        make.height.mas_equalTo(135);
    }];
    _rulesView.hidden = YES;
}
-(void)ConcentView{
    self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(16,0, SCREEN_WIDTH-30, 38)];
    self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
    self.growingTextView.minHeight = 38;
    self.growingTextView.delegate = self;
    self.growingTextView.textColor = WhiteBgTitleColor;
    self.growingTextView.font = CFont(14);
    self.growingTextView.minNumberOfLines = 1;
//    self.growingTextView.maxNumberOfLines = 10;
//    self.growingTextView.animateHeightChange = YES;
    self.growingTextView.placeholder = @"想说点什么...";
    self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
    self.growingTextView.returnKeyType = UIReturnKeyDefault;
    self.growingTextView.enablesReturnKeyAutomatically = YES;
//    self.growingTextView.backgroundColor =  UIColorHex(F4F8F8);
    [self.view addSubview:self.growingTextView];
    [self.growingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
    }];
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"dyn_issue_Back") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_issueBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    _issueBtn.backgroundColor = DynUnSendButtonBackColor;
    _issueBtn.titleLabel.font = SLPFFont(14);
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
    _issueBtn.userInteractionEnabled = NO;
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(issueClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(20));
        make.width.height.mas_equalTo(18.5);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];

}
-(void)setVoiceView{
    _VoiceImageView = [[UIImageView alloc]init];
    _VoiceImageView.image = [UIImage imageNamed:@"express_sound_backview_no"];
    _VoiceImageView.layer.cornerRadius =5;
    _VoiceImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *playsoundtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PlaySoundAct)];
    [_VoiceImageView addGestureRecognizer:playsoundtap];
    _VoiceImageView.userInteractionEnabled = YES;
    [self.view addSubview:_VoiceImageView];
    [_VoiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(5);
        make.width.mas_equalTo(186);
        make.height.mas_equalTo(50);
    }];
    _VoiceImageView.hidden = YES;
    
    UIImageView *delImageView = [[UIImageView alloc]init];
    delImageView.image = [UIImage imageNamed:@"express_sound_del"];
    UITapGestureRecognizer *delsoundtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DelSoundAct)];
    [delImageView addGestureRecognizer:delsoundtap];
    delImageView.userInteractionEnabled = YES;
    [_VoiceImageView addSubview:delImageView];
    [delImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VoiceImageView.mas_top).offset(10);
        make.right.mas_equalTo(_VoiceImageView.mas_right).offset(-10);
        make.width.height.mas_equalTo(10);
    }];
//    express_sound_note
    
    _duratimelabel = [[UILabel alloc]init];
    _duratimelabel.textAlignment = 2;
    _duratimelabel.textColor = [UIColor whiteColor];
    _duratimelabel.font = [UIFont systemFontOfSize:14];
    [_VoiceImageView addSubview:_duratimelabel];
    [_duratimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(delImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(_VoiceImageView.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    _SoundNoteImageView = [[UIImageView alloc]init];
    _SoundNoteImageView.image = [UIImage imageNamed:@"express_sound_note"];
    [_VoiceImageView addSubview:_SoundNoteImageView];
    [_SoundNoteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_VoiceImageView.mas_centerY);
        make.left.mas_equalTo(_VoiceImageView.mas_left).offset(20);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(23);
    }];
}
-(void)initVideocontentView{
    
}
-(void)updataView{
    if (_AddPicArray.count == 1 || _AddPicArray.count == 0) {
        _collectionView.hidden = YES;
        [_itemView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(12);
            make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(80);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(32);
        }];
    }else{
        _collectionView.hidden = NO;
        if (_AddPicArray.count <= 3) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(40);
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);

                make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3  + 24);
            }];

            
        }else if(_AddPicArray.count <= 6){
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(40);
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);
                make.height.mas_equalTo(( __ScaleWidth(375)  - 48 ) / 3 * 2 + 36);
            }];

        }else{
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(40);
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(-130);
            }];

        }
        [_itemView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(12);
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(32);
        }];
    }
    
    
    if (!_VideoView.hidden) {
        [_itemView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(12);
            make.top.mas_equalTo(self.VideoView.mas_bottom).offset(10);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(32);
        }];
//        _VideoAssetString = [_VideoAssetString stringByReplacingOccurrencesOfString:@"file://"withString:@""];
//        self.player.assetURL = [NSURL URLWithString:str];
        self.player.currentPlayerManager.assetURL = [NSURL URLWithString:_VideoAssetString];
        [self.player.currentPlayerManager play];
//        [self.player playerReadyToPlay];
    }
     if (!_VoiceImageView.hidden) {
        [_itemView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(12);
            make.top.mas_equalTo(self.growingTextView.mas_bottom).offset(60);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(32);
        }];
    }
    


}
-(void)backClick{
    [self dismiss];
}
-(void)delVideo{
    _VideoView.hidden = YES;
    [self.player.currentPlayerManager stop];
    [self updataView];
   
}

-(void)tapACtion:(id)sender{
//    UIView *view = (UIView *)sender;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger flag = [tap.view tag];
    
    
    if (flag == 0) {
        [self.growingTextView.internalTextView unmarkText];
        NSInteger index = self.growingTextView.text.length;
        if (self.growingTextView.isFirstResponder)
        {
            index = self.growingTextView.selectedRange.location + self.growingTextView.selectedRange.length;
            [self.growingTextView resignFirstResponder];
        }
        WS(weakSelf);
        if (self.TopicTitledArray.count >= 3) {
            [BGProgressHUD showInfoWithMessage:@"话题选择超过上限啦"];
            return;
        }
        BXDynAddHuaTiVC *topic = [[BXDynAddHuaTiVC alloc] init];
        topic.MAXNumber = 3;
        NSMutableArray *arr = [NSMutableArray array];
        for (BXDynTopicModel *model in self.TopicTitledArray) {
            [arr addObject:model];
        }
//        if (!arr.count) {
//            topic.ItemArray = [NSMutableArray array];
//        }else{

//            topic.ItemArray = arr;
        topic.SelectedArray = arr;
//        }
        topic.SelTopicBlock = ^(NSMutableArray * _Nonnull array) {
            for (int i =0; i<array.count; i++) {
                BXDynTopicModel *model = array[i];
                model.topic_name= [array[i] topic_name];
                model.topic_id= [array[i] topic_id];
                [weakSelf.TopicTitledArray addObject:model];
                UITextView *textView = weakSelf.growingTextView.internalTextView;
                NSString *insertString = [NSString stringWithFormat:@"#%@# ", model.topic_name];
                NSMutableString *string = [NSMutableString stringWithString:textView.text];
                [string insertString:insertString atIndex:index];
                weakSelf.growingTextView.text = string;
//                [weakSelf.growingTextView becomeFirstResponder];
                textView.selectedRange = NSMakeRange(index + insertString.length, 0);
            }
        };
        
        [self.navigationController pushViewController:topic animated:YES];
    }
    if (flag == 1) {
        if (_rulesView.hidden == YES) {
            _rulesView.hidden = NO;
        }else{
            _rulesView.hidden = YES;
        }
    }
    if (flag == 2) {
  
        BXShortVideoLocationSearchVC *location = [[BXShortVideoLocationSearchVC alloc] init];
        @weakify(self);
        [location setLocationBlock:^(BXLocation *location) {
            @strongify(self);
            self.location = location;
//            self.diZhiimageView.image = [UIImage imageNamed:IsNilString(location.name)?@"dyn_issue_Undizhi":@"dyn_issue_dizhi"];
            
            self.deladdressbtn.hidden = IsNilString(location.name)? YES : NO;
//            if ([location.name widthForFont:SLBFont(14)] > 50) {
//                self.diZhiNameView.hidden = NO;
//                self.diZhiLabel.hidden = YES;
                
//                [self.diZhiNameView setText:IsNilString(location.name)?@"添加位置":location.name];
//                [self.diZhiNameView setTextColor: sl_textColors];
//            }else{
//                self.diZhiNameView.hidden = YES;
//                self.diZhiLabel.hidden = NO;
//                [self.diZhiNameView pause];
                self.diZhiLabel.text = IsNilString(location.name)?@"添加位置":location.name;
//            }
            
        }];
        location.backImage = [self.view snapshotImage];
        [self.navigationController pushViewController:location animated:YES];
    }
    if (flag == 3) {
        WS(weakSelf);
        BXDynAddCircleVC *vc = [[BXDynAddCircleVC alloc]init];
        vc.SelCircleBlock = ^(NSString * _Nonnull circle_id, NSString * _Nonnull circle_name) {
//            weakSelf.quanZiLabel.text = IsNilString(circle_name)?@"添加圈子":circle_name;
            weakSelf.delcirclebtn.hidden = IsNilString(circle_name)? YES : NO;
            weakSelf.selCircle_id = circle_id;
//            if ([circle_name widthForFont:SLBFont(14)] > 50) {
//                weakSelf.CircleNameView.hidden = NO;
//                weakSelf.quanZiLabel.hidden = YES;
//                [weakSelf.CircleNameView setText:IsNilString(circle_name)?@"添加圈子":circle_name];
//                [weakSelf.CircleNameView setTextColor: sl_textColors];
//            }else{
//                weakSelf.CircleNameView.hidden = YES;
//                weakSelf.quanZiLabel.hidden = NO;
                weakSelf.quanZiLabel.text = IsNilString(circle_name)?@"添加圈子":circle_name;
//            }
        };
        [self pushVc:vc];
    }
}
#pragma mark - 上传图片
-(void)uploadImgCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount{
    UIImage *img = self.AddPicArray[currentIndex];
    NSData *data = UIImageJPEGRepresentation(img, .8);
    NSString *path = [self getImageFilePath:data fileName:[NSString stringWithFormat:@"%ld.jpg",(long)currentIndex]];
    WS(weakSelf);
    [BGProgressHUD showLoadingWithMessage:[NSString stringWithFormat:@"上传中第%ld张", (long)currentIndex + 1]];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        
        if (flag) {
            [weakSelf.PicUrlArray addObject:jsonDic[@"filePath"]];
            NSLog(@"七牛：%@",jsonDic);
            NSLog(@"~%ld",(long)currentIndex);
            if (currentIndex < totalCount-1) {
                [weakSelf uploadImgCurrentIndex:currentIndex+1 totalCount:totalCount];
            }else{
//                    最后一个任务完成~
//                [BGProgressHUD showProgress:1.0 status:@"上传中"];
                [BGProgressHUD hidden];
                [self startIssue:nil type:@"picture"];
                [weakSelf.PicUrlArray removeAllObjects];
            }
        }else{
            [BGProgressHUD hidden];
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            [weakSelf.PicUrlArray removeAllObjects];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"上传失败"];
    }];
}
-(void)issueClick{

    if (self.AddPicArray.count > 1 && !self.collectionView.hidden) {
        [self uploadImgCurrentIndex:0 totalCount:self.AddPicArray.count - 1];
    }
  else if (!_VoiceImageView.hidden) {
      [BGProgressHUD showLoadingAnimation];
      [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_voice" filePath:self.mp3Path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
          NSLog(@"%@", jsonDic);
          [BGProgressHUD hidden];
          if (flag) {
              [self startIssue:jsonDic[@"filePath"] type:@"voice"];
          }else{
              [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
          }
      } failure:^(NSError *error) {
          [BGProgressHUD hidden];
      }];
    }
  else if (![_VideoAssetString isEqualToString:@""] && _VideoAssetString && !_VideoView.hidden){
          [BGProgressHUD showLoadingAnimation];
      _VideoAssetString = [_VideoAssetString stringByReplacingOccurrencesOfString:@"file://"withString:@""];
      [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_video" filePath:_VideoAssetString success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
          [BGProgressHUD hidden];
          
          if (flag) {
              [self startIssue:jsonDic[@"filePath"] type:@"video"];
          }else{
              [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
          }
      } failure:^(NSError *error) {
          [BGProgressHUD hidden];
      }];
  }else{
      [self startIssue:@"" type:@""];
  }
    
}

-(void)startIssue:(NSString *)filePath type:(NSString *)type{
    NSString *voice = @"";
    NSString *video = @"";
    NSString *picstr = @"";
    NSString *render_type = @"13";//纯文字
    NSString *extend_type = @"1";//纯文字
    NSString *topictitle = @"";
    NSString *coverurl = @"";
    NSString *issue_type = @"2";
    if ([type isEqualToString:@"voice"]) {
        voice = filePath;
        render_type = @"6";
        extend_type = @"3";
    }
    if ([type isEqualToString:@"video"]) {
        video = filePath;
        coverurl = [NSString stringWithFormat:@"%@?vframe/jpg/offset/0", video];
        render_type = @"3";
        extend_type = @"2";
    }
    if ([type isEqualToString:@"picture"]) {
        if (self.PicUrlArray.count == 1) {
            render_type = @"0";
        }
        else if(self.PicUrlArray.count == 4){
            render_type = @"2";
        }
        else{
            render_type = @"1";
        }
        picstr = [self.PicUrlArray componentsJoinedByString:@","];

    }
    if (self.TopicTitledArray.count) {
        NSMutableArray *topicarr = [NSMutableArray array];
        for (int i = 0; i < self.TopicTitledArray.count; i++) {
            [topicarr addObject:[self.TopicTitledArray[i] topic_id]];
        }
        topictitle = [topicarr componentsJoinedByString:@","];
    }
    
    if (self.selCircle_id && ![[NSString stringWithFormat:@"%@", self.selCircle_id] isEqualToString:@""]) {
        issue_type = @"3";
    }
        
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest UploadDynamicWithcontent:self.growingTextView.text picture:picstr video:video voice:voice voice_time:_voice_time location:[NSString stringWithFormat:@"%@, %@", self.location.lat, self.location.lng] type:issue_type msg_type:self.quanXianType title:topictitle extend_type:extend_type privateid:[self jsonString:self.AtArray] systemtype:@"" systemplus:@"" extend_talk:@"" extend_circle:self.selCircle_id render_type:render_type cover_url:coverurl dynamic_title:@"" address:self.location.name Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        NSLog(@"上传：%@", jsonDic);
        if (flag) {
            [self dismiss];
            if (self.IssueSuccess) {
                self.IssueSuccess();
            }
        }
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"发布失败"];
    }];
}


-(void)AddPicture{
    NSLog(@"选择 背景图片");
    
    [self.manager clearSelectedList];
    self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
     [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
    
}
-(void)ClickBtn:(NSInteger)flag{

    if (flag == 0) {
        if (!_VoiceImageView.hidden || !_VideoView.hidden || (_AddPicArray.count >1)) {
            _IssueSelDownView.micrBackView.hidden = YES;
            [BGProgressHUD showInfoWithMessage:@"语音，照片和视频不能同时发布哦"];
            return;
        }else{
            _IssueSelDownView.frame = CGRectMake(0, __kHeight - 270 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight);
            _IssueSelDownView.micrBackView.hidden = NO;
            _IssueSelDownView.emojiView.hidden = YES;
        }
    }
    if (flag == 1) {
        if (!_VoiceImageView.hidden || !_VideoView.hidden) {
            _IssueSelDownView.micrBackView.hidden = YES;
            [BGProgressHUD showInfoWithMessage:@"语音，照片和视频不能同时发布哦"];
            return;
        }
        else{
            if (_AddPicArray.count > 1) {
                self.manager.type = HXPhotoManagerSelectedTypePhoto;
            }else{
                self.manager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
            }
            if (self.AddPicArray.count >= 10) {
                [BGProgressHUD showInfoWithMessage:@"超出照片最大选择数"];
                return;
            }

            [self.manager clearSelectedList];
            _manager.configuration.photoMaxNum = 10 - self.AddPicArray.count;
            self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
            [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
            
        }
    }
    
    if ( flag == 2) {
        _IssueSelDownView.frame = CGRectMake(0, __kHeight - 270 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight);
        _IssueSelDownView.emojiView.hidden = NO;
        _IssueSelDownView.micrBackView.hidden = YES;
    }

    if (flag == 3) {
        [self.growingTextView.internalTextView unmarkText];
         NSInteger index = self.growingTextView.text.length;
         if (self.growingTextView.isFirstResponder)
         {
             index = self.growingTextView.selectedRange.location + self.growingTextView.selectedRange.length;
             [self.growingTextView resignFirstResponder];
         }
        WS(weakSelf);
        NSLog(@"------%@---------%@", self.AtArray, [self jsonString:self.AtArray]);
        BXDynAiTeCategoryVC *vc = [[BXDynAiTeCategoryVC alloc]init];
        vc.friendArray = self.AtArray;
        vc.SelFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name) {

            NSDictionary *dict = @{@"id": user_id, @"name": user_name};
            [weakSelf.AtArray addObject:dict];
            NSString *text = user_name;
            UITextView *textView = weakSelf.growingTextView.internalTextView;
            NSString *insertString = text;
            NSMutableString *string = [NSMutableString stringWithString:textView.text];
            [string insertString:insertString atIndex:index];
            weakSelf.growingTextView.text = string;

            [weakSelf.growingTextView becomeFirstResponder];
            textView.selectedRange = NSMakeRange(index + insertString.length, 0);
            
        };
        vc.selectFriendArray = ^(NSMutableArray * _Nonnull array) {
            if (array.count) {
                for (int i = 0; i<array.count; i++) {
                    NSDictionary *dict = array[i];
                    [weakSelf.AtArray addObject:dict];
                     NSString *text = dict[@"user_name"];
                     UITextView *textView = weakSelf.growingTextView.internalTextView;
                     NSString *insertString = text;
                     NSMutableString *string = [NSMutableString stringWithString:textView.text];
                     [string insertString:insertString atIndex:index];
                     weakSelf.growingTextView.text = string;
//                     [weakSelf.growingTextView becomeFirstResponder];
                     textView.selectedRange = NSMakeRange(index + insertString.length, 0);
                }
            }

        };
        [self pushVc:vc];
    }
    if (flag == 4) {
        [self.growingTextView becomeFirstResponder];
    }
 
}
#pragma - mark UITextViewDelegate
-(void)sendEmojiMsg:(BXHHEmoji *)emoji{
    NSString *tempText = self.growingTextView.text;
    tempText = [tempText stringByAppendingString:emoji.desc];
    self.growingTextView.text = tempText;
    [self growingTextViewDidChange:self.growingTextView];
    [self.growingTextView scrollRangeToVisible:NSMakeRange(self.growingTextView.text.length, 1)];
}
-(void)deleteEmojiMsg{
    
        NSString *text = _growingTextView.text;
    if (text && text.length) {
        NSString *lastStr = [text substringFromIndex:text.length - 1];
        if (IsEquallString(lastStr, @"]") && text.length > 2) {
            NSInteger index = - 1;
            for (NSInteger i = text.length - 1; i >= 0; i--) {
                NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
                if (IsEquallString(str, @"[")) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                _growingTextView.text = [text substringToIndex:index];
            } else {
                _growingTextView.text = [text substringToIndex:text.length - 1];
            }
        } else {
            if ([[text substringFromIndex:text.length-1] isEqualToString:@" "]) {
                // 判断删除的是一个@中间的字符就整体删除
                NSArray *matches = [self atAll];
                if (matches.count) {
                    NSTextCheckingResult *result = [matches lastObject];
                    if (result.range.location + result.range.length == text.length) {
                        
                        _growingTextView.text = [text substringToIndex:text.length - 1];
                        
                    } else {
                        _growingTextView.text = [text substringToIndex:text.length - 1];
                    }
                    
                } else {
                    _growingTextView.text = [text substringToIndex:text.length - 1];
                }
            } else {
                _growingTextView.text = [text substringToIndex:text.length - 1];
            }
        }
        
    }
}
#pragma - mark playDelegate
-(void)ReturnDuratime:(NSString *)timeString{
    self.duratimelabel.text = timeString;
}
-(void)getTime:(NSString *)timeString{
    self.duratimelabel.text = timeString;
}
-(void)getDurationTime:(NSString *)timeString{
        _voice_time = timeString;    _voice_time = timeString;
}
-(void)PlaySoundAct{
   
    if (_playFlag == 0) {
        [_playSound startPlay];

        _playFlag = 1;
    }else{
        _playFlag = 0;
        [_playSound StopPlay];
    }
}
-(void)DelSoundAct{
    self.VoiceImageView.hidden = YES;
}
-(void)SkipAiTeFriend{
    BXDynAiTeCategoryVC *vc = [[BXDynAiTeCategoryVC alloc]init];
    [self pushVc:vc];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.growingTextView resignFirstResponder];
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(0, 0, __kWidth, __kHeight - 270 - __kTopAddHeight), point)) {
        NSLog(@"范围内");
        [UIView animateWithDuration:0.2 animations:^{
            self.IssueSelDownView.frame = CGRectMake(0, __kHeight - 46 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight);
             self.IssueSelDownView.emojiView.hidden = YES;
        }];
//        return;
    }


}
#pragma - mark UITextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    if (height < 35) {
        height = 35;
    } else if (height > 80) {
        height = 80;
    }

    [_growingTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self layoutIfNeeded];
//        [self layoutSubviews];
//    });

}
-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self.growingTextView resignFirstResponder];
    return YES;
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    if ([text isEqualToString:@""])
    {
        //删除表情
        if(_growingTextView.text&&_growingTextView.text.length) {
            NSString *lastStr = [_growingTextView.text substringFromIndex:_growingTextView.text.length-1];
            if (IsEquallString(lastStr, @"]") && _growingTextView.text.length > 2) {
                NSInteger index = - 1;
                for (NSInteger i = _growingTextView.text.length - 1; i >= 0; i--) {
                    NSString *str = [_growingTextView.text substringWithRange:NSMakeRange(i, 1)];
                    if (IsEquallString(str, @"[")) {
                        index = i;
                        break;
                    }
                }
                if (index >= 0) {
                    _growingTextView.text = [_growingTextView.text substringToIndex:index];
                } else {
                    _growingTextView.text = [_growingTextView.text substringToIndex:_growingTextView.text.length-1];
                }
                return NO;
            }
            
        }


        //删除@
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }
        
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self atAll];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                
                for (int i=0; i<self.AtArray.count; i++) {
                    NSDictionary *dict = self.AtArray[i];
                    if (IsEquallString(dict[@"user_name"], [string substringWithRange:match.range])) {
                        [self.AtArray removeObjectAtIndex:i];
                        break;
                    }
                }
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
        
        //删除话题
        NSArray *matches1 = [self topicAll];
    
        BOOL inTopic = NO;
        NSInteger index1 = range.location;
        for (NSTextCheckingResult *match1 in matches1)
        {
            NSRange newRange1 = NSMakeRange(match1.range.location +1, match1.range.length-1);
            if (NSLocationInRange(range.location, newRange1))
            {
                NSLog(@"-%@-",[string substringWithRange:match1.range]);
                for (int i=0; i<self.TopicTitledArray.count; i++) {
                    BXDynTopicModel *model = self.TopicTitledArray[i];
                    NSString *topicname = [NSString stringWithFormat:@"#%@# ", model.topic_name];
                    if (IsEquallString(topicname, [string substringWithRange:match1.range])) {
                        [self.TopicTitledArray removeObjectAtIndex:i];
                        break;
                    }
                }
                NSLog(@"%@",self.TopicTitledArray);
                inTopic = YES;
                index1 = match1.range.location;
                [string replaceCharactersInRange:match1.range withString:@""];
                break;
            }
        }
        
        if (inTopic)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index1, 0);
            return NO;
        }
    }
    
    //判断是回车键就发送出去
    if ([text isEqualToString:@"\n"])
    {

        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length) {
        [_issueBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynSendButtonBackColor;
        _issueBtn.userInteractionEnabled = YES;
    }else{
        [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynUnSendButtonBackColor;
        _issueBtn.userInteractionEnabled = NO;
    }

//    _sendBtn.selected = !growingTextView.text.length;
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];
    if (newText.length < 1)
    {
        // 高亮输入框中的@
        UITextView *textView = self.growingTextView.internalTextView;
        NSRange range = textView.selectedRange;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:WhiteBgTitleColor range:NSMakeRange(0, string.string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.string.length)];
        NSArray *matches = [self atAll];
        
        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:UIColorHex(00D3C7) range:NSMakeRange(match.range.location, match.range.length-1)];
        }
        
        NSArray *matches1 = [self topicAll];
        for (NSTextCheckingResult *match1 in matches1)
        {
            [string addAttribute:NSForegroundColorAttributeName value:sl_normalColors range:NSMakeRange(match1.range.location, match1.range.length-1)];
        }
        
        textView.attributedText = string;
        textView.selectedRange = range;
    }
    if (growingTextView.text.length<=0) {
        growingTextView.textColor = WhiteBgTitleColor;
    }
    
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0)
    {
        // 选择文本时可以
        return;
    }
    NSArray *matches = [self atAll];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
    
    NSArray *matches1 = [self topicAll];
    
    for (NSTextCheckingResult *match1 in matches1)
    {
        NSRange newRange1 = NSMakeRange(match1.range.location+1, match1.range.length-1);
        if (NSLocationInRange(range.location, newRange1))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match1.range.location + match1.range.length, 0);
            break;
        }
    }
    
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{

}

- (NSArray<NSTextCheckingResult *> *)atAll
{
    // 找到文本中所有的@
    NSString *string = self.growingTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
- (NSArray<NSTextCheckingResult *> *)topicAll
{
    // 找到文本中所有的话题
    NSString *string = self.growingTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(.*?)#+ " options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
-(NSString *)jsonString:(NSArray *)dataArr{
    NSString *attring= [NSString string];
    if (dataArr.count>0) {
        NSMutableArray *atarr = [NSMutableArray array];
        for ( int i =0; i<dataArr.count; i++)
        {
            NSDictionary *dict = [dataArr objectAtIndex:i];
            [atarr addObject:dict[@"user_id"]];
            attring = [atarr componentsJoinedByString:@","];
        }
    }else{
        attring = @"";
    }
    return attring;
}
-(void)DeleAddressAct{
    self.location = nil;
//    self.diZhiimageView.image = [UIImage imageNamed:@"dyn_issue_Undizhi"];
//    self.diZhiNameView.text = @"添加位置";
    self.diZhiLabel.text = @"添加位置";
    self.deladdressbtn.hidden = YES ;
//    self.diZhiNameView.hidden = YES;
//    self.diZhiLabel.hidden = NO;
}
-(void)DelecircleAct{
    self.selCircle_id = @"";
    self.quanZiLabel.text = @"添加圈子";
//    self.CircleNameView.text = @"添加圈子";
    self.delcirclebtn.hidden = YES ;
//    self.CircleNameView.hidden = YES;
//    self.quanZiLabel.hidden = NO;
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _AddPicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_AddPicArray.count) {
        if (indexPath.row == _AddPicArray.count - 1) {
            cell.type = @"1";
        }else{
            cell.type = @"0";
        }
    }
    WS(weakSelf);
    cell.picImage.image = _AddPicArray[indexPath.row];
    cell.imageArray = _AddPicArray;
    cell.backgroundColor = [UIColor redColor];
    cell.DelPicture = ^{
        [weakSelf.AddPicArray removeObjectAtIndex:indexPath.row];
        if (weakSelf.AddPicArray.count == 1) {
//            [weakSelf.AddPicArray removeAllObjects];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf updataView];
    };
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.AddPicArray.count - 1) {
        [self ClickBtn:1];
    }else{
//        AddPictureCell *cell = (AddPictureCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
       HZPhotoBrowser  *_browser = [[HZPhotoBrowser alloc] init];
         _browser.isFullWidthForLandScape = YES;
         _browser.isNeedLandscape = NO;
        _browser.hiddenSavebottom = YES;
        _browser.hiddenbottom = YES;
        _browser.currentImageIndex = (int)indexPath.row;
        _browser.imageDataArray = self.AddPicArray;
        _browser.imageCount = self.AddPicArray.count - 1;
         [_browser show];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDynPhoto" object:nil userInfo:@{@"index":@(indexPath.row)}];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake( ( __ScaleWidth(375)  - 48 ) / 3, ( __ScaleWidth(375)  - 48 ) / 3);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 12;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 0;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

#pragma mark - 获取位置通知
- (void)didGetLocation:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSInteger type = [info[@"type"] integerValue];
    if (type==0) {
        _location = info[@"location"];
        _addressString = _location.city;
    }

}
//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [ZFPlayerControlView new];
//        _controlView.fastViewAnimated = YES;
//        _controlView.autoHiddenTimeInterval = 5;
//        _controlView.autoFadeTimeInterval = 0.5;
//        _controlView.prepareShowLoading = YES;
//        _controlView.prepareShowControlView = YES;
//    }
//    return _controlView;
//}
#pragma mark - 懒加载HXPhoto
//- (HXDatePhotoToolManager *)toolManager {
//    if (!_toolManager) {
//        _toolManager = [[HXDatePhotoToolManager alloc] init];
//    }
//    return _toolManager;
//}
- (HXPhotoManager *)manager {
    if (!_manager) {
//        WS(weakSelf);
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.lookGifPhoto = YES;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.singleSelected = NO;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = NO;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(500, 500);
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.themeColor = [UIColor sl_colorWithHex:0xF92C56];
        _manager.configuration.restoreNavigationBar = YES;
//        _manager.configuration.replaceCameraViewController = YES;
//        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
//            
//            // 这里拿使用系统相机做例子
//            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//            imagePickerController.delegate = (id)weakSelf;
//            imagePickerController.allowsEditing = NO;
//            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
//            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
//            NSArray *arrMediaTypes;
//            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
//                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
//            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
//                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
//            }else {
//                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
//            }
//            [imagePickerController setMediaTypes:arrMediaTypes];
//            // 设置录制视频的质量
//            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
//            //设置最长摄像时间
//            [imagePickerController setVideoMaximumDuration:60.f];
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//            [viewController presentViewController:imagePickerController animated:YES completion:nil];
//        };

    }
    return _manager;
}
#pragma mark - 图片选择 代理方法
/**
 点击完成

 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
-(void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    NSLog(@"%@",allList);
    NSLog(@"%@",photoList);
    NSLog(@"%@",videoList);
    WS(ws);
    if (videoList.count) {
        HXPhotoModel *model = videoList[0];
        if (model.type == HXPhotoModelMediaTypeVideo){
            [BGProgressHUD showLoadingWithMessage:@"视频处理中"];
            [model exportVideoWithPresetName:AVAssetExportPresetMediumQuality startRequestICloud:nil iCloudProgressHandler:nil exportProgressHandler:^(float progress, HXPhotoModel * _Nullable model) {
                     // 导出视频时的进度，在iCloud下载完成之后
                 } success:^(NSURL * _Nullable videoURL, HXPhotoModel * _Nullable model) {
                     // 导出完成, videoURL
//                     ws.VideoAssetString = [NSString stringWithFormat:@"%@", videoURL];
                     ws.VideoView.hidden = NO;
                     ws.VideoAssetString = [videoURL absoluteString];
                     [self updataView];
                     [BGProgressHUD hidden];
                 } failed:^(NSDictionary *info, HXPhotoModel *model) {
                     [BGProgressHUD showInfoWithMessage:@"视频处理失败"];
                 }];
        }

    }
    
    if (photoList.count) {

        [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            for (int i = 0; i < imageArray.count; i++) {
                UIImage *image = imageArray[i];

                [ws.AddPicArray insertObject:image atIndex:0];

            }

            [ws updataView];
            [ws.collectionView reloadData];
        }];
//    [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//
//        for (int i = 0; i < imageList.count; i++) {
//            UIImage *image = imageList[i];
//
//            [ws.AddPicArray insertObject:image atIndex:0];
//
//        }
//
//        [ws updataView];
//        [ws.collectionView reloadData];
//    } failed:^{
//
//    }];
    }
}
#pragma mark - 照相
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    WS(ws);
    model.selectIndexStr = @"1";
    [@[model] hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            [ws.AddPicArray addObject:image];
            [self updataView];
            [self.collectionView reloadData];
        }
    }];
//    [self.toolManager getSelectedImageList:@[model] requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//        for (int i = 0; i < imageList.count; i++) {
////            if (ws.AddPicArray.count) {
////                [ws.AddPicArray removeLastObject];
////            }
//
//            UIImage *image = imageList[i];
//            [ws.AddPicArray addObject:image];
////            if (ws.AddPicArray.count ) {
////                [ws.AddPicArray addObject:[UIImage imageNamed:@"dyn_issue_AddPic_tianJia_big"]];
////            }
////
//            [self updataView];
//            [self.collectionView reloadData];
//        }
//    } failed:^{
//
//    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    WS(weakSelf);
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:image location:nil complete:^(HXPhotoModel *model, BOOL success) {
                if (success) {
                    if (weakSelf.manager.configuration.useCameraComplete) {
                        weakSelf.manager.configuration.useCameraComplete(model);
                    }
                }else {
                    [weakSelf.view hx_showImageHUDText:@"保存图片失败"];
                }
            }];
        }else {
            HXPhotoModel *model = [HXPhotoModel photoModelWithImage:image];
            if (self.manager.configuration.useCameraComplete) {
                self.manager.configuration.useCameraComplete(model);
            }
        }
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url location:nil complete:^(HXPhotoModel *model, BOOL success) {
                if (success) {
                    if (weakSelf.manager.configuration.useCameraComplete) {
                        weakSelf.manager.configuration.useCameraComplete(model);
                    }
                }else {
                    [weakSelf.view hx_showImageHUDText:@"保存视频失败"];
                }
            }];
        }else {
            HXPhotoModel *model = [HXPhotoModel photoModelWithVideoURL:url];
            if (self.manager.configuration.useCameraComplete) {
                self.manager.configuration.useCameraComplete(model);
            }
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//获取暂时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData {
    NSString *path = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"addPicture_cover.jpg"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}

-(NSString *)getFileName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",str,((arc4random() % 501) + 500)];
    return fileName;
}
#pragma mark - 获取临时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData fileName:(NSString *)fileName {
    NSString *dirPath =[[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"manual"];
    BOOL isdir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath isDirectory:&isdir]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [dirPath stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

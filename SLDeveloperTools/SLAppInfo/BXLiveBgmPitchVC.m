//
//  BXLiveBgmPitchVC.m
//  BXlive
//
//  Created by bxlive on 2019/6/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLiveBgmPitchVC.h"
#import <YYCategories.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>


@interface BXLiveBgmPitchVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIImage *backImage;
@property(nonatomic,strong) UISlider *accompanySlider;//伴奏
@property(nonatomic,strong) UISlider *voiceSlider;//人声
@property(nonatomic,strong) UISlider *pitchSlider;//音调
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) UIView *leftContainer;
@property(nonatomic,strong) UIView *rightContainer;

@property (nonatomic,strong)CAGradientLayer *accompanygradient;

@property (nonatomic,strong)CAGradientLayer *voicegradient;

@property (nonatomic,strong)CAGradientLayer *pitchgradient;

@property(nonatomic,assign) CGFloat accompanySliderValue;
@property(nonatomic,assign) CGFloat voiceSliderValue;
@property(nonatomic,assign) CGFloat pitchSliderValue;
@property(nonatomic,assign) NSInteger mixingVoiceIndex;
@end

@implementation BXLiveBgmPitchVC

- (instancetype)initImage:(UIImage *)image accompanySliderValue:(CGFloat)accompanySliderValue voiceSliderValue:(CGFloat)voiceSliderValue pitchSliderValue:(CGFloat)pitchSliderValue mixingVoiceIndex:(NSInteger)mixingVoiceIndex{
    if (self = [super init]) {
        _backImage = image;
        self.accompanySliderValue = accompanySliderValue;
        self.voiceSliderValue = voiceSliderValue;
        self.pitchSliderValue = pitchSliderValue;
        self.mixingVoiceIndex = mixingVoiceIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPop];
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeNotiView) name:kClosePetchViewNotification object:nil];
//    [self onAccompanySliderValueChange:self.accompanySlider];
//    [self onVoiceSliderValueChange:self.voiceSlider];
//    [self onPitchSliderValueChange:self.pitchSlider];
    
    _accompanySlider.value = self.accompanySliderValue;
    _voiceSlider.value = self.voiceSliderValue;
    _pitchSlider.value = self.pitchSliderValue;
}
- (void)closeNotiView {
     if (self) {
         [self.popupController dismiss];
         
     }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initPop {
    self.view.backgroundColor = [UIColor clearColor];
//    CGFloat height = 44 + __kBottomAddHeight + 243;
    CGFloat height = 418 + __kBottomAddHeight ;
    self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH, height);
    self.popupController.navigationBarHidden = YES;
}

- (void)setUpUI {
    
//    UIImageView *bgImageView = [[UIImageView alloc] init];
//    bgImageView.userInteractionEnabled = YES;
//    bgImageView.image = self.backImage;
//    [self.view addSubview:bgImageView];
//    bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    effectView.frame = self.view.frame;
//    [bgImageView addSubview:effectView];
    
    UIView *contentView= [[UIView alloc]init];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    contentView.layer.cornerRadius = 12.0;
    contentView.layer.masksToBounds  = YES;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-__ScaleWidth(12));
        make.width.mas_equalTo(__ScaleWidth(50));
        make.height.mas_equalTo(__ScaleWidth(49));
        make.top.mas_equalTo(0);
    }];
    [resetBtn setTitle:@"重置" forState:BtnNormal];
    [resetBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    resetBtn.titleLabel.font = SLPFFont(__ScaleWidth(14));
    [resetBtn setImage:CImage(@"live_replay") forState:BtnNormal];
    [resetBtn addTarget:self action:@selector(resetBtnOnClick:) forControlEvents:BtnTouchUpInside];
    [resetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, __ScaleWidth(-10), 0, 0)];
    
    UIView *line = [[UIView alloc]init];
    [contentView addSubview:line];
    line.backgroundColor = sl_divideLineColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(49);
        make.height.mas_equalTo(1);
    }];
    
    
    

    UILabel *nameLabel =  [UILabel initWithFrame:CGRectZero text:@"音效调节" size:16 color:sl_blackBGColors alignment:NSTextAlignmentLeft lines:1 shadowColor:nil];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [contentView addSubview:nameLabel];
    nameLabel.sd_layout.leftSpaceToView(contentView, 12).rightSpaceToView(contentView, 0).heightIs(20).topSpaceToView(line, 14);
    
//    UIView *fengeView = [[UIView alloc]init];
//    fengeView.backgroundColor = RGBA(246, 246, 246,0.2);
//    [self.view addSubview:fengeView];
//    fengeView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(nameLabel, 0).heightIs(0.5);
    
   //伴奏
//    UILabel *accompanyLabel = [[UILabel alloc] init];
//    accompanyLabel.textColor = UIColorHex(D0D8D8);
//    accompanyLabel.font = CFont(12);
//    accompanyLabel.text = @"伴奏";
//    accompanyLabel.textAlignment = 1;
//    [self.view addSubview:accompanyLabel];
//    accompanyLabel.sd_layout.leftSpaceToView(self.view, 0).widthIs(50).heightIs(20).topSpaceToView(nameLabel, 25);
    UIButton *banzouBtn = [[UIButton alloc]init];
    [contentView addSubview:banzouBtn];
    [banzouBtn setTitle:@"伴奏" forState:BtnNormal];
    banzouBtn.titleLabel.font = SLPFFont(11);
    [banzouBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    [banzouBtn setImage:[UIImage imageNamed:@"live_icon_banzou"] forState:BtnNormal];
    [banzouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(48);
    }];
    
    
    
    _accompanySlider = [[UISlider alloc]init];
    [_accompanySlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateNormal];
    [_accompanySlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateHighlighted];
    _accompanySlider.minimumTrackTintColor = [UIColor clearColor];
    _accompanySlider.maximumTrackTintColor = sl_divideLineColor;
    [_accompanySlider addTarget:self action:@selector(onAccompanySliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_accompanySlider];
    _accompanySlider.sd_layout.leftSpaceToView(banzouBtn, 0).rightSpaceToView(self.view, 15).heightIs(20).centerYEqualToView(banzouBtn);
    _accompanySlider.value = self.accompanySliderValue;
    
    _accompanygradient = [CAGradientLayer layer];
    
    
    CGFloat accompanyvalue   = (SCREEN_WIDTH - 75) * _accompanySliderValue;
    _accompanygradient.frame =CGRectMake(_accompanySlider.bounds.origin.x,_accompanySlider.bounds.size.height/2 - 2 + _accompanySlider.bounds.origin.y , accompanyvalue , 4);
    _accompanygradient.cornerRadius = 2.0;
    _accompanygradient.masksToBounds = YES;

    _accompanygradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#FFD576"] CGColor], (id)[sl_FF2DtextColors CGColor], nil];

    _accompanygradient.startPoint=CGPointMake(0,0.5);

    _accompanygradient.endPoint=CGPointMake(1,0.5);

    [_accompanySlider.layer addSublayer:_accompanygradient];
    
    
    
//    UILabel *voiceLabel = [[UILabel alloc] init];
//    voiceLabel.textColor = UIColorHex(D0D8D8);
//    voiceLabel.font = CFont(12);
//    voiceLabel.text = @"人声";
//    voiceLabel.textAlignment = 1;
//    [self.view addSubview:voiceLabel];
//    voiceLabel.sd_layout.leftSpaceToView(self.view, 0).widthIs(50).heightIs(20).topSpaceToView(accompanyLabel, 30);
    
    UIButton *renshenBtn = [[UIButton alloc]init];
    [contentView addSubview:renshenBtn];
    [renshenBtn setTitle:@"人声" forState:BtnNormal];
    renshenBtn.titleLabel.font = SLPFFont(11);
    [renshenBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    [renshenBtn setImage:[UIImage imageNamed:@"live_icon_rensheng"] forState:BtnNormal];
    [renshenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(banzouBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(48);
    }];
    
    
    
    _voiceSlider = [[UISlider alloc]init];
    [_voiceSlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateNormal];
    [_voiceSlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateHighlighted];
    _voiceSlider.minimumTrackTintColor = [UIColor clearColor];
    _voiceSlider.maximumTrackTintColor = sl_divideLineColor;
    [_voiceSlider addTarget:self action:@selector(onVoiceSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_voiceSlider];
    
    _voiceSlider.sd_layout.leftSpaceToView(renshenBtn, 0).rightSpaceToView(self.view, 15).heightIs(20).centerYEqualToView(renshenBtn);
    _voiceSlider.value = self.voiceSliderValue;
    
    _voicegradient = [CAGradientLayer layer];
    
    
    CGFloat voicevalue   = (SCREEN_WIDTH - 75) * _voiceSlider.value;
    _voicegradient.frame =CGRectMake(_accompanySlider.bounds.origin.x,_accompanySlider.bounds.size.height/2 - 2 + _accompanySlider.bounds.origin.y , voicevalue , 4);
    _voicegradient.cornerRadius = 2.0;
    _voicegradient.masksToBounds = YES;

    _voicegradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#FFD576"] CGColor], (id)[sl_FF2DtextColors CGColor], nil];

    _voicegradient.startPoint=CGPointMake(0,0.5);

    _voicegradient.endPoint=CGPointMake(1,0.5);

    [_voiceSlider.layer addSublayer:_voicegradient];
    
    
    
//    UILabel *pitchLabel = [[UILabel alloc] init];
//    pitchLabel.textColor = UIColorHex(D0D8D8);
//    pitchLabel.font = CFont(12);
//    pitchLabel.textAlignment = 1;
//    pitchLabel.text = @"音调";
//    [self.view addSubview:pitchLabel];
//    pitchLabel.sd_layout.leftSpaceToView(self.view, 0).widthIs(50).heightIs(20).topSpaceToView(voiceLabel, 30);
    UIButton *yindiaoBtn = [[UIButton alloc]init];
    [contentView addSubview:yindiaoBtn];
    [yindiaoBtn setTitle:@"音调" forState:BtnNormal];
    yindiaoBtn.titleLabel.font = SLPFFont(11);
    [yindiaoBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    [yindiaoBtn setImage:[UIImage imageNamed:@"live_icon_yindiao"] forState:BtnNormal];
    [yindiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(renshenBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(48);
    }];
    
    _pitchSlider = [[UISlider alloc]init];
    [_pitchSlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateNormal];
    [_pitchSlider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateHighlighted];
    
//    _pitchSlider.minimumTrackTintColor = UIColorHex(7C8282);
    _pitchSlider.minimumTrackTintColor = [UIColor clearColor];
    _pitchSlider.maximumTrackTintColor = sl_divideLineColor;
    [_pitchSlider addTarget:self action:@selector(onPitchSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pitchSlider];
    
    _pitchSlider.sd_layout.leftSpaceToView(yindiaoBtn, 0).rightSpaceToView(self.view, 15).heightIs(20).centerYEqualToView(yindiaoBtn);
    _pitchSlider.value = self.pitchSliderValue;
    
    _pitchgradient = [CAGradientLayer layer];
    
    
    CGFloat pitchvalue   = (SCREEN_WIDTH - 75) * _pitchSlider.value;
    _pitchgradient.frame =CGRectMake(_accompanySlider.bounds.origin.x,_accompanySlider.bounds.size.height/2 - 2 + _accompanySlider.bounds.origin.y, pitchvalue ,4);
    _pitchgradient.cornerRadius = 2.0;
    _pitchgradient.masksToBounds = YES;

    _pitchgradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#FFD576"] CGColor], (id)[sl_FF2DtextColors CGColor], nil];

    _pitchgradient.startPoint=CGPointMake(0,0.5);

    _pitchgradient.endPoint=CGPointMake(1,0.5);

    [_pitchSlider.layer addSublayer:_pitchgradient];
    
    
    
    [self setuAutoViewsWithCount:6 margin:0 type:0 view:_leftContainer];
    [self setuAutoViewsWithCount:6 margin:0 type:1 view:_rightContainer];
    
    
    banzouBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -banzouBtn.imageView.frame.size.width, -banzouBtn.imageView.frame.size.height-5, 0);
    banzouBtn.imageEdgeInsets = UIEdgeInsetsMake(-banzouBtn.titleLabel.intrinsicContentSize.height-5, 0, 0, -banzouBtn.titleLabel.intrinsicContentSize.width);
    renshenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -renshenBtn.imageView.frame.size.width, -renshenBtn.imageView.frame.size.height-5, 0);
    renshenBtn.imageEdgeInsets = UIEdgeInsetsMake(-renshenBtn.titleLabel.intrinsicContentSize.height-5, 0, 0, -renshenBtn.titleLabel.intrinsicContentSize.width);
    yindiaoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -yindiaoBtn.imageView.frame.size.width, -yindiaoBtn.imageView.frame.size.height-5, 0);
    yindiaoBtn.imageEdgeInsets = UIEdgeInsetsMake(-yindiaoBtn.titleLabel.intrinsicContentSize.height-5, 0, 0, -yindiaoBtn.titleLabel.intrinsicContentSize.width);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[LiveBgnPitchViewCell class] forCellWithReuseIdentifier:@"LiveBgnPitchViewCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.leftSpaceToView(self.view, 12).rightSpaceToView(self.view, 12).topSpaceToView(yindiaoBtn, 20).heightIs(70);

    
    
    self.dataArray = @[@"",@"KTV",@"小房间",@"大会堂",@"低沉",@"洪亮",@"金属声",@"磁性"];
    
    [self.collectionView reloadData];

    
    
    
}

//展示cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveBgnPitchViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveBgnPitchViewCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        if (self.mixingVoiceIndex == indexPath.row) {
            cell.backImage.backgroundColor = normalColors;
        }else{
            cell.backImage.backgroundColor = RGBA(216, 216, 216, 0.3);
        }
        [cell loadData:self.dataArray[indexPath.row] index:indexPath.row];
    }
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexPathRow = indexPath.row;
    if (self.mixingVoiceIndex == indexPathRow) {
        return ;
    }
    self.mixingVoiceIndex = indexPath.row;
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mixingVoiceIndex:)]) {
        [self.delegate mixingVoiceIndex:self.mixingVoiceIndex];
    }
}


-(void)resetBtnOnClick:(UIButton *)btn{
    NSLog(@"重置音效");
//    accompanySlider;//伴奏
//@property(nonatomic,strong) UISlider *voiceSlider;//人声
//@property(nonatomic,strong) UISlider *pitchSlider;//音调
    self.accompanySlider.value = 0.5;
    self.voiceSlider.value = 0.5;
    self.pitchSlider.value = 0.5;
    [self onPitchSliderValueChange:self.pitchSlider];
    [self onVoiceSliderValueChange:self.voiceSlider];
    [self onAccompanySliderValueChange:self.accompanySlider];
}

-(void)onPitchSliderValueChange:(UISlider *)slide{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pitchSliderValue:)]) {
        [self.delegate pitchSliderValue:slide.value];
    }
    
    CGFloat _pro   = slide.bounds.size.width * slide.value;
    _pitchgradient.frame =CGRectMake(slide.bounds.origin.x,slide.bounds.size.height/2 - 2+slide.bounds.origin.y,_pro ,4);
}
-(void)onVoiceSliderValueChange:(UISlider *)slide{
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceSliderValue:)]) {
        [self.delegate voiceSliderValue:slide.value];
    }
    
    CGFloat _pro   = slide.bounds.size.width * slide.value;
    _voicegradient.frame =CGRectMake(slide.bounds.origin.x,slide.bounds.size.height/2 - 2+slide.bounds.origin.y,_pro ,4);
}

-(void)onAccompanySliderValueChange:(UISlider *)slide{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accompanySliderValue:)]) {
        [self.delegate accompanySliderValue:slide.value];
    }
    
    CGFloat _pro   = self.accompanySlider.bounds.size.width * slide.value;
    _accompanygradient.frame =CGRectMake(slide.bounds.origin.x,slide.bounds.size.height/2 - 2+slide.bounds.origin.y,_pro ,4);
}
- (void)setuAutoViewsWithCount:(NSInteger)count margin:(CGFloat)margin type:(NSInteger)type view:(UIView *)view
{
    view = [UIView new];

    [self.view addSubview:view];
    
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        UILabel  *textLabel = [UILabel initWithFrame:CGRectZero size:10 color:UIColorHex(A6ACAC) alignment:1 lines:1];
        [view addSubview:textLabel];
        textLabel.sd_layout.heightIs(13);
        [temp addObject:textLabel];
        if (type == 0) {
            textLabel.text = [NSString stringWithFormat:@"-%d",(int)count-i];
        }else{
            textLabel.text = [NSString stringWithFormat:@"%d",(int)i + 1];
        }
    }
    if (type==0) {
        view.sd_layout.leftEqualToView(self.pitchSlider).bottomSpaceToView(self.pitchSlider, 0).widthIs((SCREEN_WIDTH-50-20)/2.f);
        
    }else{
        view.sd_layout.rightEqualToView(self.pitchSlider).topSpaceToView(self.pitchSlider, 0).widthIs((SCREEN_WIDTH-50-20)/2.f);
    }
    
    
    [view setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:count verticalMargin:margin horizontalMargin:margin verticalEdgeInset:margin horizontalEdgeInset:margin];
    
}


@end


@implementation LiveBgnPitchViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.backImage.layer.masksToBounds = YES ;
        self.backImage.layer.cornerRadius = 25;
        self.backImage.backgroundColor = normalColors;
        [self addSubview:self.backImage];
        
        
        self.noneImage = [UIImageView new];
        self.noneImage.image = CImage(@"icon_live_cancel_none");
        [self.backImage addSubview:self.noneImage];
        [self.noneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(20);
        }];
        
        self.textLabel = [UILabel initWithFrame:CGRectZero size:12 color:sl_blackBGColors alignment:1 lines:1];
        [self.backImage addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
    }
    return self ;
}

-(void)loadData:(NSString *)title index:(NSInteger)index{
    if (index == 0) {
        self.noneImage.hidden = NO;
    }else{
        self.noneImage.hidden = YES;
    }
    self.textLabel.text = title;
}



@end


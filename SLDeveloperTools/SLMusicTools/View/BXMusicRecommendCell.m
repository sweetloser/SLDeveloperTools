//
//  BXMusicRecommendCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicRecommendCell.h"
#import "BXMusicModel.h"
#import "BXGradientButton.h"
#import <Lottie/Lottie.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Aspects/Aspects.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYCategories/YYCategories.h>
#import "SLMusicToolsMacro.h"
#import <YYWebImage/YYWebImage.h>
#import "SLMusicToolsMacro.h"
#define contentWidth SCREEN_WIDTH//SCREEN_WIDTH-16-8

@interface BXMusicRecommendCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger allNum;
//@property (nonatomic , strong) BXMusicModel * currentModel;

@end

@interface DSMusicRecommendScrollViewCell : UICollectionViewCell
/** 音乐图片 */
@property (nonatomic , strong) UIImageView *iconImageView;
/** 播放暂停图标 */
@property (nonatomic , strong) UIImageView *playPauseImageView;
/** 音乐名称 */
@property (nonatomic , strong) UILabel * musicLabel;
/** 昵称 */
@property (nonatomic , strong) UILabel * nameLabel;
/** 收藏 */
@property (nonatomic , strong) UIButton * collectBtn;
/** 使用 */
@property (nonatomic , strong) UIButton * useBtn;
/** 是否选中 */
@property (nonatomic , assign) BOOL isSelectMusic;

@property(nonatomic,copy)void(^seleIndexPath)(NSInteger tag);

@property(nonatomic,copy)void(^useIndexPath)(NSInteger tag);

@property (nonatomic,strong) BXMusicModel *models;
@end

@implementation BXMusicRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        [self.collectionView registerClass:[DSMusicRecommendScrollViewCell class] forCellWithReuseIdentifier:@"DSMusicRecommendScrollViewCell"];
        
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCollect:) name:kDidCollectNotification object:nil];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSMusicRecommendScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSMusicRecommendScrollViewCell" forIndexPath:indexPath];
    BXMusicModel *model = self.dataArray[indexPath.item];
    cell.models = model;
    cell.collectBtn.tag = indexPath.item;
    @weakify(self);
    [cell setSeleIndexPath:^(NSInteger tag) {
        @strongify(self);
        if (self.musicCollectBlock) {
            self.musicCollectBlock(tag);
        }
    }];
    [cell setUseIndexPath:^(NSInteger tag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUseMusicNotification object:nil userInfo:@{@"model":model}];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return ;
    }
    DSMusicRecommendScrollViewCell *cell = (DSMusicRecommendScrollViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BXMusicModel *themodel = self.dataArray[indexPath.item];
    for (BXMusicModel *model in self.dataArray) {
        if ([model isEqual:themodel]) {
            if (themodel.isSelect==NO) {
                themodel.isSelect = YES;
                cell.useBtn.hidden = NO;
                cell.playPauseImageView.image = [UIImage imageNamed:@"icon_music_pause"];
                [UIView animateWithDuration:0.5 animations:^{
                    cell.musicLabel.frame = CGRectMake(80, 15, contentWidth-80-55-85, 19);
                    cell.nameLabel.frame = CGRectMake(80, 38, contentWidth-80-55-85, 16);
                    cell.collectBtn.frame = CGRectMake(contentWidth-39-85, 23.5, 23, 21);
                    cell.useBtn.frame = CGRectMake(contentWidth-11-85+15, 18, 65, 32);
                }];
            }else{
                themodel.isSelect = NO;
                cell.useBtn.hidden = YES;
                cell.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
                cell.musicLabel.frame = CGRectMake(80, 15, contentWidth-80-55, 19);
                cell.nameLabel.frame = CGRectMake(80, 38, contentWidth-80-55, 16);
                cell.collectBtn.frame = CGRectMake(contentWidth-39, 23.5, 23, 21);
                cell.useBtn.frame = CGRectMake(contentWidth, 18, 65, 32);
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectMusicPlayPauseNotification object:nil userInfo:@{@"model":themodel}];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(contentWidth, 68);
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma - mark NSNotification
- (void)didCollect:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *type = info[@"type"];
    if (IsEquallString(type, @"music")) {
        NSString *musicId = info[@"musicId"];
        for (BXMusicModel *model in self.dataArray) {
            if ([musicId integerValue] == [model.music_id integerValue]) {
                model.is_collect = info[@"is_collect"];
            }
        }
        [self.collectionView reloadData];
    }
}

@end

@implementation DSMusicRecommendScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMusic:) name:kSelectMusicPlayPauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:kDidMusicPlayFinishNotification object:nil];

}

-(void)createView{
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 56, 56)];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4;
    _playPauseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17, 22, 22)];
    _playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
    [_iconImageView addSubview:_playPauseImageView];
    _musicLabel = [UILabel initWithFrame:CGRectZero size:15 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1];
    _musicLabel.frame = CGRectMake(80, 15, self.contentView.frame.size.width-80-55, 19);
    _nameLabel = [UILabel initWithFrame:CGRectZero size:12 color:MinorColor alignment:NSTextAlignmentLeft lines:1];
    _nameLabel.frame = CGRectMake(80, 38, self.contentView.frame.size.width-80-55, 16);
    _collectBtn = [[UIButton alloc]init];
    _collectBtn.frame = CGRectMake(self.contentView.frame.size.width-39, 23.5, 23, 21);
    [_collectBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _useBtn = [[BXGradientButton alloc]init];
    _useBtn.frame = CGRectMake(self.contentView.frame.size.width, 18, 65, 32);
    [_useBtn setTitle:@"使用" forState:BtnNormal];
    _useBtn.titleLabel.font =  CFont(15);
    [_useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.useBtn.hidden = YES;
    [self.contentView sd_addSubviews:@[_iconImageView,_musicLabel,_nameLabel,_collectBtn,_useBtn]];
    
}

#pragma mark - 收藏
-(void)collectionBtnClick:(UIButton *)btn{
    if (self.seleIndexPath) {
        self.seleIndexPath(btn.tag);
    }
}

- (void)useBtnClick:(UIButton *)btn{
    if (self.useIndexPath) {
        self.useIndexPath(btn.tag);
    }
}

-(void)setModels:(BXMusicModel *)models{
    _models = models;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:models.image] placeholder:[UIImage imageNamed:@""]];
    self.musicLabel.text = models.title;
    self.nameLabel.text = models.singer;
    if ([models.is_collect integerValue]==0) {
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_music_collect_n"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_music_collect_y"] forState:UIControlStateNormal];
    }
    if (models.isSelect==NO) {
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55, 16);
        self.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(SCREEN_WIDTH, 18, 65, 32);
    }else{
        self.useBtn.hidden = NO;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_pause"];
        self.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55-85, 19);
        self.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55-85, 16);
        self.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39-85, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(SCREEN_WIDTH-11-85+15, 18, 65, 32);
    }
}

- (void)selectMusic:(NSNotification *)notic{
    NSDictionary *info = notic.userInfo;
    BXMusicModel *model = info[@"model"];
    if (![model isEqual:_models]&&_models.isSelect==YES) {
        _models.isSelect = NO;
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, self.contentView.frame.size.width-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, self.contentView.frame.size.width-80-55, 16);
        self.collectBtn.frame = CGRectMake(self.contentView.frame.size.width-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(self.contentView.frame.size.width, 18, 65, 32);
    }
}

- (void)playFinish:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    BXMusicModel *model = info[@"model"];
    if ([model isEqual:_models]&&_models.isSelect == YES) {
        _models.isSelect = NO;
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, self.contentView.frame.size.width-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, self.contentView.frame.size.width-80-55, 16);
        self.collectBtn.frame = CGRectMake(self.contentView.frame.size.width-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(self.contentView.frame.size.width, 18, 65, 32);
    }
}

@end

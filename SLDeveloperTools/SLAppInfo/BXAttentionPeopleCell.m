//
//  BXAttentionPeopleCell.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionPeopleCell.h"
#import "BXAttentFollowModel.h"
#import <Lottie/Lottie.h>
//#import "HHMoviePlayVC.h"
//#import "BXPersonHomeVC.h"
//#import "HHFollowListVC.h"
#import "BXSLCircleRippleView.h"
#import "SLMoviePlayVCCoonfig.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "BXSLLiveRoom.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"

@interface BXAttentionPeopleCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger allNum;
@end

@interface DSAttentionScrollViewCell : UICollectionViewCell
@property (nonatomic,strong) LOTAnimationView *bgLotteImage;
@property (nonatomic,strong) UIImageView *iconbgView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) BXSLCircleRippleView *circleRippleView;
@property (nonatomic,strong) UIImageView *statusimage;//直播状态
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) BXAttentFollowModel *models;
- (void)loadCellData:(BXAttentFollowModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@implementation BXAttentionPeopleCell

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
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 8, 0, 0));
        [self.collectionView registerClass:[DSAttentionScrollViewCell class] forCellWithReuseIdentifier:@"DSAttentionScrollViewCell"];
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSAttentionScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSAttentionScrollViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (self.dataArr.count) {
        BXAttentFollowModel *model = self.dataArr[indexPath.item];
        cell.models = model;
        [cell loadCellData:model indexPath:indexPath];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(82, 105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item) {
        
    if ([[self.dataArr[indexPath.row] is_live] integerValue] == 1) {
        SLMoviePlayVCCoonfig *config = [SLMoviePlayVCCoonfig shareMovePlayConfig];
        config.hasMore = YES;
        BXSLLiveRoom *liveRoom = nil;
        liveRoom = self.is_live_dataArr[indexPath.row];
//        [BXLocalAgreement GHenterLiveRoomWithAllRoomData:self.is_live_dataArr currentSelectedIndex:indexPath.row fromVc:self.viewController];
    }else{
            
        BXAttentFollowModel *model = self.dataArr[indexPath.item];
//        [BXLocalAgreement loadUrl:model.jump fromVc:self.viewController completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDidSeeNotification object:nil userInfo:@{@"user_id":model.user_id}];
//        }];
            
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self reloadData];
}
-(void)setIs_live_dataArr:(NSMutableArray *)is_live_dataArr{
    _is_live_dataArr = is_live_dataArr;
}
@end

@implementation DSAttentionScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
    }
    return self;
}

-(void)createView {
//    self.bgLotteImage = [LOTAnimationView animationNamed:@"Live_status_Cirle"];
//    self.bgLotteImage.loopAnimation = YES;
//    [self.contentView addSubview:self.bgLotteImage];
//    [self.bgLotteImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.width.height.mas_equalTo(70);
//        make.top.mas_offset(4);
//    }];
//    [self.bgLotteImage play];
    
    self.iconbgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconbgView];
    self.iconbgView.layer.masksToBounds = YES;
    self.iconbgView.layer.cornerRadius = 33;
    self.iconbgView.layer.borderWidth = 2.f;
    self.iconbgView.layer.borderColor = [UIColor sl_colorWithHex:0xFF2D52].CGColor;
    [self.iconbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(66);
        make.top.mas_equalTo(6);
    }];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = sl_subBGColors;
    [self.iconbgView addSubview:self.iconImageView];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 28;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(54);
    }];
    _circleRippleView = [[BXSLCircleRippleView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
//    [self.contentView addSubview:self.circleRippleView];
    [self.contentView insertSubview:_circleRippleView belowSubview:_iconImageView];
//    _circleRippleView.sd_layout.widthIs(66).heightEqualToWidth().centerXEqualToView(_iconImageView).centerYEqualToView(_iconImageView);
    [self.circleRippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_iconImageView.mas_centerX);
        make.width.height.mas_equalTo(80);
         make.centerY.mas_equalTo(_iconImageView.mas_centerY);
    }];
    
    
    self.titleLabel = [UILabel initWithFrame:CGRectZero size:18 color:[UIColor blackColor] alignment:1 lines:1];
    [self.iconbgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    
//    self.statusimage = [UIImageView new];
//    self.statusimage.image = CImage(@"icon_attention_liveing");
//    [self.contentView addSubview:self.statusimage];
//    [self.statusimage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.bgLotteImage.mas_bottom).offset(-14);
//        make.centerX.mas_equalTo(self.bgLotteImage.mas_centerX);
//        make.width.mas_equalTo(45);
//        make.height.mas_equalTo(15);
//    }];
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.text = @"直播中";
    self.statusLabel.textAlignment = 1;
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:10];
    self.statusLabel.backgroundColor = [UIColor sl_colorWithHex:0xFF2D52];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 9;
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconbgView.mas_bottom).offset(-14);
        make.centerX.mas_equalTo(self.iconbgView.mas_centerX);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(18);
    }];

    self.nameLabel = [UILabel initWithFrame:CGRectZero size:14 color:[UIColor blackColor] alignment:1 lines:1];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.iconbgView.mas_bottom);
        make.height.mas_equalTo(38);
    }];
}

- (void)setModels:(BXAttentFollowModel *)models{
    _models = models;
}
- (void)loadCellData:(BXAttentFollowModel *)model indexPath:(NSIndexPath *)indexPath{
    
    self.nameLabel.font = CFont(14);
    self.iconImageView.hidden = NO;
//    self.iconbgView.image = nil;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"")];
    self.nameLabel.text = model.nickname;
    self.titleLabel.hidden = YES;
    if ([model.is_live integerValue]>0) {
        self.bgLotteImage.hidden = NO;
        self.statusimage.hidden = NO;
        self.statusLabel.hidden = NO;
        [_circleRippleView startAnimation];
        self.iconbgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.iconbgView.layer.borderWidth = 0;
    }else{
        [_circleRippleView stopAnimation];
        if ([model.is_see integerValue]<=0) {
            self.statusimage.hidden = YES;
            self.bgLotteImage.hidden = YES;
            self.statusLabel.hidden = YES;
            self.iconbgView.layer.borderWidth = 1;
            self.iconbgView.layer.borderColor = sl_textSubColors.CGColor;
        }else{
            self.statusimage.hidden = YES;
            self.bgLotteImage.hidden = YES;
            self.statusLabel.hidden = YES;
            self.iconbgView.layer.borderWidth = 1;
            self.iconbgView.layer.borderColor = sl_textSubColors.CGColor;
        }
    }
}

@end



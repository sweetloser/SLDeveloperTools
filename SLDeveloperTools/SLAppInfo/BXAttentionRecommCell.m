//
//  BXAttentionRecommCell.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionRecommCell.h"
#import "BXAttentFollowModel.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "SLAppInfoConst.h"
#import "../SLCategory/SLCategory.h"
#import <SDWebImage/SDWebImage.h>
#import "../SLUtilities/SLUtilities.h"


//#import "BXPersonHomeVC.h"
@interface BXAttentionRecommCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger allNum;
@end

@interface DSAttentionRecoPeopleCell : UICollectionViewCell
@property(nonatomic,strong)BXAttentFollowModel *model;
@property(nonatomic,strong)UIImageView *backView;//背景
@property (nonatomic,strong) UIImageView *iconbgView;
@property(nonatomic,strong)UIImageView *iconImage;//头像
@property(nonatomic,strong)UIView *nameView;//名字和性别背景
@property(nonatomic,strong)UILabel *nameLabel;//名字
@property(nonatomic,strong)UIImageView *sexImage;//性别
@property(nonatomic,strong)UILabel * levelLabel;//等级等图标
@property(nonatomic, strong)UIButton *followBtn;//关注
@property(nonatomic, strong)UIButton * colsewBtn;//关闭
@property(nonatomic,copy)void(^seleIndexPath)(NSInteger tag);


@end

@implementation BXAttentionRecommCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat itemW = (__kWidth - 32) / 3;
        CGFloat itemH = 224;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
//        layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.dataSource = self;
//        self.collectionView.userInteractionEnabled = YES;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 14, 0, 14));
        [self.collectionView registerClass:[DSAttentionRecoPeopleCell class] forCellWithReuseIdentifier:@"DSAttentionRecoPeopleCell"];
        
        UIView *downView = [UIView new];
        downView.backgroundColor = DynDownLineColor;
        
        [self.contentView addSubview:downView];
        [downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(8);
        }];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSAttentionRecoPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSAttentionRecoPeopleCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (self.recArr.count) {
        BXAttentFollowModel *model = self.recArr[indexPath.item];
        cell.model = model;
    }
    cell.followBtn.tag = indexPath.item;
    @weakify(self);
    [cell setSeleIndexPath:^(NSInteger tag) {
        @strongify(self);
        if (self.attentRecommBlock) {
            self.attentRecommBlock(tag);
        }
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(114, 224);
//}

- (void)reloadData
{
    
    [self.collectionView reloadData];
}

-(void)setRecArr:(NSMutableArray *)recArr{
    _recArr = recArr;
    [self reloadData];
}

@end

@implementation DSAttentionRecoPeopleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.backView = [UIImageView new];
    self.backView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 4;
//    self.backView.layer.borderWidth = 1;
//    self.backView.layer.borderColor = PageBackgroundColor.CGColor;
    self.iconbgView = [[UIImageView alloc] init];
    self.iconImage = [UIImageView new];
    self.iconImage.backgroundColor = sl_subBGColors;
    self.nameLabel = [UILabel initWithFrame:CGRectZero size:13 color:[UIColor blackColor] alignment:0 lines:1];
    self.nameView = [UIView new];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.sexImage = [UIImageView new];
    [self.nameView sd_addSubviews:@[self.nameLabel,self.sexImage]];
    self.levelLabel = [UILabel initWithFrame:CGRectZero size:13 color:nil alignment:0 lines:1];
    self.followBtn = [UIButton buttonWithFrame:CGRectZero Title:nil Font:CFont(14) Color:TextBrightestColor Image:nil Target:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.followBtn.sd_cornerRadius = @(13);
    self.colsewBtn = [UIButton buttonWithFrame:CGRectZero Title:nil Font:CFont(12) Color:normalColors Image:[UIImage imageNamed:@"close"] Target:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.colsewBtn.hidden = YES;
    
    [self.contentView sd_addSubviews:@[self.backView,self.colsewBtn,self.iconbgView, self.iconImage,self.nameView,self.levelLabel,self.followBtn]];
    
    self.backView.sd_layout.leftSpaceToView(self.contentView, 3).rightSpaceToView(self.contentView, 3).topSpaceToView(self.contentView, 4).bottomSpaceToView(self.contentView, 20);
    self.colsewBtn.sd_layout.rightSpaceToView(self.contentView, 3).topSpaceToView(self.contentView, 4).widthIs(25).heightEqualToWidth();
    self.colsewBtn.imageView.sd_layout.centerXEqualToView(self.colsewBtn).centerYEqualToView(self.colsewBtn).widthIs(13).heightEqualToWidth();
    
    self.backView.sd_cornerRadius = @(6);
    
    self.iconbgView.sd_layout.topSpaceToView(self.contentView, 22).centerXEqualToView(self.contentView).widthIs(90).heightEqualToWidth();
    self.iconbgView.layer.masksToBounds = YES;
    self.iconbgView.layer.cornerRadius = 45;
    self.iconbgView.layer.borderWidth = 1.f;
    self.iconbgView.layer.borderColor = [UIColor colorWithRed:1.00 green:0.15 blue:0.33 alpha:1.00].CGColor;
    
    self.iconImage.sd_layout.topSpaceToView(self.contentView, 28).centerXEqualToView(self.contentView).widthIs(78).heightEqualToWidth();
    self.iconImage.sd_cornerRadius = @(39);
    self.iconImage.userInteractionEnabled = YES;
    
    
    
    
    self.followBtn.sd_layout.centerXEqualToView(self.contentView).widthIs(80).heightIs(26).bottomSpaceToView(self.contentView, 36);
    //    self.followBtn.imageView.sd_layout.leftSpaceToView(self.followBtn, 0).rightSpaceToView(self.followBtn, 0).bottomSpaceToView(self.followBtn, 0).topSpaceToView(self.followBtn, 0);
    
    self.nameView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.iconImage, 5).heightIs(24).widthIs(100);
    self.levelLabel.sd_layout.leftSpaceToView(self.contentView, 7).rightSpaceToView(self.contentView, 7).topSpaceToView(self.nameView, 3).heightIs(24);
    
    
    self.sexImage.sd_layout.rightSpaceToView(self.nameView, 0).centerYEqualToView(self.nameView).widthIs(14).heightEqualToWidth();
    self.nameLabel.sd_layout.leftSpaceToView(self.nameView, 0).heightIs(24).rightSpaceToView(self.sexImage, 3);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:80.f];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.iconImage addGestureRecognizer:tap];
    
}
#pragma 个人主页
-(void)iconImageClick{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_model.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:_model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}
-(void)followBtnClick:(UIButton *)btn{
    
    if (self.seleIndexPath) {
        self.seleIndexPath(btn.tag);
    }

}
-(void)closeBtnClick:(UIButton *)btn{
    
}
-(void)setModel:(BXAttentFollowModel *)model{
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"nil")];
    UIImage *sexImage = nil;
    switch ([model.gender integerValue]) {
        case 0:
            sexImage = [UIImage imageNamed:@"gender_icon_weishezhi"];
            break;
            
        case 1:
            sexImage = [UIImage imageNamed:@"gender_icon_male"];
            break;
            
        default:
            sexImage = [UIImage imageNamed:@"gender_icon_female"];
            break;
    }
    CGFloat widths = [BXCalculate calculateRowWidth:model.nickname Font:CFont(13)];
    if (widths < 80) {
        self.nameView.sd_resetLayout.centerXEqualToView(self.contentView).topSpaceToView(self.iconImage, 5).heightIs(24).widthIs(widths+17);
    }else{
        self.nameView.sd_resetLayout.centerXEqualToView(self.contentView).topSpaceToView(self.iconImage, 5).heightIs(24).widthIs(100);;
    }
    self.sexImage.image = sexImage;
    self.nameLabel.text = model.nickname;
    self.levelLabel.attributedText = [self getAttributedStringFromModel:model];
    
    if ([model.is_follow integerValue]==1) {
        [self.followBtn setTitle:@"已关注" forState:BtnNormal];
        [self.followBtn setTitleColor:ButtonGrayTitleColor forState:BtnNormal];
        self.followBtn.backgroundColor = [UIColor colorWithRed:1.00 green:0.15 blue:0.33 alpha:1.00];
        NSArray<CALayer *> *subLayers = self.followBtn.layer.sublayers;
        NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:[CAGradientLayer class]];
        }]];
        [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
    }else{
        [self.followBtn setTitle:@"关注" forState:BtnNormal];
        [self.followBtn setTitleColor:TextBrightestColor forState:BtnNormal];
        self.followBtn.backgroundColor = [UIColor colorWithRed:1.00 green:0.15 blue:0.33 alpha:1.00];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0, 0, 80, 26);
//        gl.startPoint = CGPointMake(0.04, 0.5);
//        gl.endPoint = CGPointMake(1, 0.5);
//        gl.colors = @[(__bridge id)normalColors.CGColor, (__bridge id)CHHCOLOR_D(0x00E6BF).CGColor];
//        gl.locations = @[@(0), @(1.0f)];
//        [self.followBtn.layer insertSublayer:gl atIndex:0];
    }
}

-(NSAttributedString *)getAttributedStringFromModel:(BXAttentFollowModel *)msgModel{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    if([msgModel.level integerValue]>0) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",msgModel.level]];
        // 设置图片大小
        attch.bounds = CGRectMake(0,-1.5,30,14);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    if ([msgModel.vip_status integerValue] == 1) {
        NSTextAttachment *vipAttch = [[NSTextAttachment alloc] init];
        vipAttch.image = [UIImage imageNamed:@"mine_vipIdentification"];
        vipAttch.bounds = CGRectMake(0,-.1,15,15);
        NSAttributedString *vipAttri = [NSAttributedString attributedStringWithAttachment:vipAttch];
        [attribute appendAttributedString:vipAttri];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    if ([msgModel.is_creation integerValue] == 1) {
        NSTextAttachment *creationAttch = [[NSTextAttachment alloc] init];
        creationAttch.image = [UIImage imageNamed:@"mine-creationer"];
        creationAttch.bounds = CGRectMake(0,-2.5,13.5,17.5);
        NSAttributedString *creationAttri = [NSAttributedString attributedStringWithAttachment:creationAttch];
        [attribute appendAttributedString:creationAttri];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribute.length)];
    return attribute;
}

@end

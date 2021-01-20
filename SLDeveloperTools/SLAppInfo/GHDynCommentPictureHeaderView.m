//
//  GHDynCommentPictureHeaderView.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "GHDynCommentPictureHeaderView.h"
#import <Lottie/Lottie.h>
#import "DetailSendcomCollectionViewCell.h"
#import "HZPhotoBrowser.h"
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import <YYText/YYText.h>
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import "SLAppInfoMacro.h"
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"

@interface GHDynCommentPictureHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 头像 */
@property (strong, nonatomic) UIImageView *headImageView;
/** 昵称 */
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (nonatomic , strong) UIButton * nickNameBtn;
/** 作者 */
@property (strong, nonatomic) UIImageView *authorImageView;
/** 时间 */
@property (strong, nonatomic) YYLabel *timeLabel;
/** 点赞按钮 */
@property (strong, nonatomic) UIButton *clickZanBtn;

/** 内容 */
@property (strong, nonatomic) YYLabel *contentLabel;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *PicArray;
@property(nonatomic, strong)NSMutableArray *smallPicArray;

@end

@implementation GHDynCommentPictureHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
     if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
         self.backgroundColor = [UIColor whiteColor];
         self.PicArray = [NSMutableArray array];
         self.smallPicArray = [NSMutableArray array];
         UIButton *btn = [[UIButton alloc]init];
         [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
         [self.contentView addSubview:btn];
         btn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
         //头像
         self.headImageView = [[UIImageView alloc]init];
         self.headImageView.sd_cornerRadius = @(19);
         self.headImageView.layer.masksToBounds = YES;
         self.headImageView.userInteractionEnabled = YES;
         [self.contentView addSubview:self.headImageView];
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarOrNicknameDidClicked)];
         [self.headImageView addGestureRecognizer:tap];
         self.headImageView.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12).widthIs(38).heightIs(38);

         self.nickNameLabel = [[UILabel alloc]init];
         self.nickNameLabel.textColor = [UIColor blackColor];
         self.nickNameLabel.font = SLBFont(14);
         [self.contentView addSubview:self.nickNameLabel];
         self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.contentView, 12).rightSpaceToView(self.contentView, 40).heightIs(19);
         

         //内容&时间
         self.timeLabel = [[YYLabel alloc]init];
         UIEdgeInsets textContainerInset1 = self.timeLabel.textContainerInset;
         self.timeLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
         textContainerInset1.top = 0;
         textContainerInset1.bottom = 0;
         self.timeLabel.textContainerInset = textContainerInset1;
         self.timeLabel.textColor = UIColorHex(#B2B2B2);
         self.timeLabel.numberOfLines = 0;
         self.timeLabel.font = CFont(12);
         self.timeLabel.textAlignment = NSTextAlignmentLeft;
         [self.contentView addSubview:self.timeLabel];
         self.timeLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.nickNameLabel, 0).widthIs(SCREEN_WIDTH-110).heightIs(19);
         
         UIView *moreview = [[UIView alloc]init];
         UITapGestureRecognizer *moreviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
         [moreview addGestureRecognizer:moreviewtap];
         moreview.userInteractionEnabled = YES;
         [self.contentView addSubview:moreview];
         moreview.sd_layout.rightSpaceToView(self.contentView, 12).centerYEqualToView(self.headImageView).widthIs(20).heightIs(20);
         
         UIImageView *moreimage = [[UIImageView alloc]init];
         moreimage.image = [UIImage imageNamed:@"dyn_issue_more"];
//         UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
//         [moreimage addGestureRecognizer:moretap];
//         moreimage.userInteractionEnabled = YES;
         [moreview addSubview:moreimage];
         moreimage.sd_layout.rightSpaceToView(moreview, 0).centerYEqualToView(moreview).widthIs(20).heightIs(4);
         
         self.contentLabel = [[YYLabel alloc]init];
         self.contentLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
         UIEdgeInsets textContainerInset = self.contentLabel.textContainerInset;
         textContainerInset.top = 0;
         textContainerInset.bottom = 0;
         self.contentLabel.textContainerInset = textContainerInset;
         self.contentLabel.numberOfLines = 0 ;
         self.contentLabel.font = CFont(14);
         self.contentLabel.textAlignment = NSTextAlignmentLeft;
         [self.contentView addSubview:self.contentLabel];
         self.contentLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.timeLabel, 5).heightIs(19).widthIs(SCREEN_WIDTH-116);
         
         UITapGestureRecognizer *contenttap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsgAct)];
         [_contentLabel addGestureRecognizer:contenttap];
         _contentLabel.userInteractionEnabled = YES;
         
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
         self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 100) collectionViewLayout:layout];
         self.collectionView.showsVerticalScrollIndicator = NO;
         self.collectionView.showsHorizontalScrollIndicator = NO;
         self.collectionView.pagingEnabled = YES;
         self.collectionView.backgroundColor = [UIColor clearColor];
         [self.collectionView registerClass:[DetailSendcomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
         self.collectionView.dataSource = self;
         self.collectionView.delegate = self;
         [self.contentView addSubview:self.collectionView];
//         self.collectionView.sd_layout.leftSpaceToView(self.contentLabel, 0).topSpaceToView(self.contentLabel, 5).heightIs(100).rightSpaceToView(self.contentView, 40);
         [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.contentLabel.mas_left);
             make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(5);
             make.right.mas_equalTo(self.contentLabel.mas_right);
             make.height.mas_equalTo(69);
         }];

     }
    return self;
}
-(void)moreAct{
    if (self.clicktipoff) {
        self.clicktipoff(_model);
    }
}
- (void)setModel:(BXDynCommentModel *)model{
    [self layoutIfNeeded];
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
//    [self.nickNameLabel setTitle:model.nickname forState:UIControlStateNormal];
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = model.create_time;
//    self.contentLabel.text = model.content;
//    CGFloat  textH = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
//    [model processAttributedString];
    self.contentLabel.text = model.content;
     self.contentLabel.attributedText = model.attatties;
    self.contentLabel.sd_layout.heightIs(model.headerHeight + 10);
    NSArray *array = [model.imgs componentsSeparatedByString:@","];
    NSArray *smallarray = [model.smallimgs componentsSeparatedByString:@","];
    if (array.count) {
        self.PicArray = [NSMutableArray arrayWithArray:array];
//        [self.collectionView reloadData];
    }
    if (smallarray.count) {
        self.smallPicArray = [NSMutableArray arrayWithArray:smallarray];
        [self.collectionView reloadData];
    }
    

    [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:10];
}

- (void)setColorType:(NSInteger)colorType {
    if (colorType) {
        [self.nickNameBtn setTitleColor:CHHCOLOR_D(0x4A4F4F) forState:BtnNormal];
    } else {
        [self.nickNameBtn setTitleColor:UIColorHex(A8AFAF) forState:BtnNormal];
    }
}

- (void)btnClick{
    if (self.sectionClick) {
        self.sectionClick(_model);
    }
}

- (void)avatarOrNicknameDidClicked{
//    if (self.toPersonHome) {
//        self.toPersonHome(_model.user_id);
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_model.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//           [BXPersonHomeVC toPersonHomeWithUserId:self.model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}
-(void)sendMsgAct{
    if (self.SendMsgClick) {
        self.SendMsgClick(_model);
    }
}
- (void)clickZanBtnClick:(UIButton *)btn{
//    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentLikeWithCommentID:_model.comment_id Success:^(id responseObject) {
//        if ([responseObject[@"code"] integerValue]==0) {
//            NSDictionary *dataDic = responseObject[@"data"];
//            if (dataDic && [dataDic isDictionary]) {
//                self.model.is_like = [NSString stringWithFormat:@"%@",dataDic[@"status"]];
//                self.model.like_count = [NSString stringWithFormat:@"%@",dataDic[@"total"]];
//                self.clickZanBtn.selected = IsEquallString(self.model.is_like, @"1");
//                [self.clickZanBtn setTitle:[NSString stringWithFormat:@" %@",self.model.like_count] forState:UIControlStateNormal];
//            }
//        }else{
//            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
//        }
//    } Failure:^(NSError *error) {
//
//    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.sectionClick) {
        self.sectionClick(_model);
    }
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (!self.PicArray.count) {
//        return 0;
//    }
    return self.PicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailSendcomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.picurl = _smallPicArray[indexPath.row] ;
    cell.type = @"1";

    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//        if (self.didPicture) {
//            self.didPicture(indexPath.row);
//        }

    HZPhotoBrowser *_browser = [[HZPhotoBrowser alloc] init];
    _browser.isFullWidthForLandScape = YES;
    _browser.isNeedLandscape = NO;
    _browser.hiddenbottom = YES;
    _browser.currentImageIndex = (int)indexPath.row;
    _browser.imageArray = _PicArray;
    [_browser show];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake(69, 69);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 12;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 0;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 12);
}
@end

//
//  BXDynBaseTableviewCell.m
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMSeedingBaseTableviewCell.h"

#import "BXLiveUser.h"
#import "DynSharePopViewManager.h"
//#import "BXCodeLoginVC.h"

//#import "BXPersonHomeVC.h"
#import <SDWebImage/SDWebImage.h>
#import "BXDynDidDisbandAlert.h"
#import "SLAppInfoConst.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>
#import "SLAmwayListModel.h"
#import <CTMediatorSLAmway/CTMediator+SLAmway.h>

#import "TMSeedingTopicHomeVC.h"
@interface TMSeedingBaseTableviewCell()
@property(nonatomic, strong)UILabel *linelable;
@property(nonatomic, strong)UIView *moreView;
@end
@implementation TMSeedingBaseTableviewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];

    }
    return self;
}
-(void)setView{
    
}
-(void)initView{
    
    UIView *topLineColorView = [UIView new];
    topLineColorView.backgroundColor = sl_subBGColors;
    
    UIView *topLineCornerRadiusView = [UIView new];
    topLineCornerRadiusView.backgroundColor = [UIColor whiteColor];
    topLineCornerRadiusView.layer.masksToBounds = YES;
    topLineCornerRadiusView.layer.cornerRadius = 5;
    
    [self.contentView sd_addSubviews:@[topLineColorView, topLineCornerRadiusView]];
    topLineColorView.sd_layout.topSpaceToView(self.contentView, 0).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(10);
    topLineCornerRadiusView.sd_layout.topSpaceToView(self.contentView, 0).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(20);


    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.backgroundColor = sl_subBGColors;
    _headerImage.layer.cornerRadius = 20;
    _headerImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SkipPersonView)];
    [_headerImage addGestureRecognizer:headerTap];
    _headerImage.userInteractionEnabled = YES;
  
    _namelable = [[UILabel alloc]init];
    _namelable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _namelable.textAlignment = 0;
    _namelable.textColor = [UIColor blackColor];

    _genderImage = [[UIImageView alloc]init];
    _genderImage.image = [UIImage imageNamed:@"icon_dyn_gender_boy"];

    _timelable = [[UILabel alloc]init];
    _timelable.font = [UIFont systemFontOfSize:12];
    _timelable.textColor = UIColorHex(#B2B2B2);
    _timelable.textAlignment = 0;

    self.contentlable = [[YYLabel alloc]init];
    self.contentlable.clearContentsBeforeAsynchronouslyDisplay = NO;
    UIEdgeInsets textContainerInset1 = self.contentlable.textContainerInset;
    textContainerInset1.top = 0;
    self.contentlable.textContainerInset = textContainerInset1;
    self.contentlable.numberOfLines = 0 ;
    self.contentlable.font = CFont(16);
    self.contentlable.textAlignment = NSTextAlignmentLeft;

    _concenterBackview = [[UIView alloc]init];

    _unfoldBtn = [[UILabel alloc]init];
    _unfoldBtn.textColor = UIColorHex(#91B8F4);
    _unfoldBtn.text = @"展开";
    _unfoldBtn.font = [UIFont systemFontOfSize: 14];
    UITapGestureRecognizer *unfoldtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unfoldAct:)];
    [_unfoldBtn addGestureRecognizer:unfoldtap];
    _unfoldBtn.userInteractionEnabled = YES;

    _bottomview = [[UIView alloc]init];
    _bottomview.userInteractionEnabled = YES;
    UITapGestureRecognizer *bottomtap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
    }];
    [_bottomview addGestureRecognizer:bottomtap];

    _likeImage = [[UIImageView alloc]init];
    _likeImage.image = [UIImage imageNamed:@"dyn_like_gray"];
    UITapGestureRecognizer *liketap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAct:)];
    [_likeImage addGestureRecognizer:liketap];
    _likeImage.userInteractionEnabled = YES;

    _likeNumlable = [[UILabel alloc]init];
    _likeNumlable.font = [UIFont systemFontOfSize:12];

    
    UIImageView *comimage = [[UIImageView alloc]init];
    comimage.image = [UIImage imageNamed:@"dyn_comment_gray"];
    UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comAct:)];
    [comimage addGestureRecognizer:comtap];
    comimage.userInteractionEnabled = YES;

    _commentNumlable = [[UILabel alloc]init];
    _commentNumlable.font = [UIFont systemFontOfSize:12];

    UIImageView *shareimage = [[UIImageView alloc]init];
    shareimage.image = [UIImage imageNamed:@"dyn_share_gray"];
    UITapGestureRecognizer *sharetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAct:)];
    [shareimage addGestureRecognizer:sharetap];
    shareimage.userInteractionEnabled = YES;

    _moreView = [[UIView alloc]init];
    UITapGestureRecognizer *moreviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct:)];
    [_moreView addGestureRecognizer:moreviewtap];
    _moreView.userInteractionEnabled = YES;

    
    UIImageView *moreimage = [[UIImageView alloc]init];
    moreimage.image = [UIImage imageNamed:@"dyn_issue_more"];

    _addressimage = [[UIImageView alloc]init];
    _addressimage.image = [UIImage imageNamed:@"dyn_issue_adress"];

    
    _addressname = [[UILabel alloc]init];
    _addressname.font = SLPFFont(12);
    _addressname.textColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.6];


    
    [self.contentView sd_addSubviews:@[self.headerImage, self.namelable, self.genderImage, self.timelable,  self.concenterBackview, self.contentlable,self.unfoldBtn, self.addressname, self.addressimage,self.bottomview]];

    
    _headerImage.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 20).widthIs(40).heightIs(40);
    _namelable.sd_layout.leftSpaceToView(_headerImage, 10).topEqualToView(_headerImage).widthIs(50).heightIs(20);
    _genderImage.sd_layout.leftSpaceToView(_namelable, 5).centerYEqualToView(_namelable).widthIs(12).heightIs(12);
    _timelable.sd_layout.leftSpaceToView(_headerImage, 10).topSpaceToView(_namelable, 5).widthIs(150).heightIs(12);

    
    _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 15).rightSpaceToView(self.contentView, 12).heightIs(100);
    _unfoldBtn.sd_layout.leftEqualToView(_contentlable).topSpaceToView(_contentlable, 5).widthIs(40).heightIs(20);
    _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_unfoldBtn, 5).heightIs(200);
  
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 10).widthIs(18).heightIs(18);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self.contentView, 12).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_addressimage, 5).heightIs(25);
   


    [_bottomview sd_addSubviews:@[_likeImage, _likeNumlable, comimage, _commentNumlable, shareimage, _moreView]];
    _likeImage.sd_layout.leftEqualToView(_bottomview).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _likeNumlable.sd_layout.leftSpaceToView(_likeImage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    comimage.sd_layout.leftSpaceToView(_likeNumlable, 5).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _commentNumlable.sd_layout.leftSpaceToView(comimage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    shareimage.sd_layout.leftSpaceToView(_commentNumlable, 5).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _moreView.sd_layout.rightSpaceToView(_bottomview, 0).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    [_moreView sd_addSubviews:@[moreimage]];
    moreimage.sd_layout.rightSpaceToView(_moreView, 0).centerYEqualToView(_moreView).widthIs(20).heightIs(4);
    
    UIView *downlineview = [[UIView alloc]init];
    downlineview.backgroundColor = DynDownLineColor;
    [self.contentView sd_addSubviews:@[downlineview]];
    downlineview.sd_layout.topSpaceToView(_bottomview, 5).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(13);
    
    UIView *downLineCornerRadiusView = [UIView new];
    downLineCornerRadiusView.backgroundColor = [UIColor whiteColor];
    downLineCornerRadiusView.layer.masksToBounds = YES;
    downLineCornerRadiusView.layer.cornerRadius = 5;
    [self.contentView sd_addSubviews:@[downLineCornerRadiusView]];
    downLineCornerRadiusView.sd_layout.topSpaceToView(_bottomview, 0).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(10);
    

}
-(void)layoutSubviews{
    
}

-(void)setModel:(BXDynamicModel *)model{
    [self.contentView layoutIfNeeded];
    [model.msgdetailmodel processAttributedString];
    
    _model = model;
    self.namelable.text = model.msgdetailmodel.nickname;
    NSString *user_avatar = [NSString stringWithFormat:@"%@",model.msgdetailmodel.avatar];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:user_avatar]];

    self.namelable.sd_layout.leftSpaceToView(self.headerImage, 10).topEqualToView(self.headerImage).widthIs([UILabel getWidthWithTitle:self.namelable.text font:self.namelable.font]).heightIs(20);
    self.timelable.text = model.msgdetailmodel.difftime;

    self.contentlable.attributedText = model.msgdetailmodel.attatties;
    self.contentlable.textAlignment = 0;
    if (!self.contentlable.text) {

    }


    
    if ([model.msgdetailmodel.address isEqualToString:@""]) {
        _addressimage.hidden = YES;
        self.addressname.text = @"";
    }else{
        _addressimage.hidden = NO;
        self.addressname.text = model.msgdetailmodel.address;
    }
    
    if ([[NSString stringWithFormat:@"%@",model.msgdetailmodel.gender] isEqualToString:@"2"]) {
        _genderImage.image = [UIImage imageNamed:@"icon_dyn_gender_girl"];
    }else{
        _genderImage.image = [UIImage imageNamed:@"icon_dyn_gender_boy"];
    }


    
    if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.extend_already_live] isEqualToString:@"0"]) {
        _likeImage.image = CImage(@"dyn_like_gray");
    }else{
        _likeImage.image = CImage(@"dyn_issue_liked");
    }

    self.likeNumlable.text = [NSString stringWithFormat:@"%@", model.msgdetailmodel.like_num];
    self.commentNumlable.text = [NSString stringWithFormat:@"%@", model.msgdetailmodel.comment_num];


    [self.contentlable sizeToFit];
    //获取contentlable的高度
    CGFloat  textH = [self.contentlable sizeThatFits:CGSizeMake(__kWidth - 100, MAXFLOAT)].height;
    self.contentHeight = textH;
    //获取行数
    CGFloat lineHeight = self.contentlable.font.lineHeight;
    self.lineHeight = lineHeight;

    NSInteger newlincount = model.msgdetailmodel.dyncontentHeight / lineHeight;
    if (newlincount <= 3) {
        _unfoldBtn.hidden = YES;

        _concenterBackview.sd_layout.topSpaceToView(_contentlable, 10);

        _contentlable.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(_headerImage, 15).rightSpaceToView(self.contentView, 12).heightIs(model.msgdetailmodel.dyncontentHeight);

    }else{
        _concenterBackview.sd_layout.topSpaceToView(_unfoldBtn, 10);
        if (_model.isFold) {

            _contentlable.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(_headerImage, 15).rightSpaceToView(self.contentView, 12).heightIs(model.msgdetailmodel.dyncontentHeight);
            _unfoldBtn.text = @"收起";
        }else{
            _contentlable.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(_headerImage, 15).rightSpaceToView(self.contentView, 12).heightIs(lineHeight * 3);
             _unfoldBtn.text = @"展开";
        }

        _unfoldBtn.hidden = NO;

    }
    WS(weakSelf);

    model.msgdetailmodel.goToTopic = ^(NSString * _Nonnull topic_id) {
        TMSeedingTopicHomeVC *vc = [[TMSeedingTopicHomeVC alloc]init];
        vc.topic_id = topic_id;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    };
    
    
    [self updateCenterView];
    [self updateDownView];
    [self updateLayout];
    [self setupAutoHeightWithBottomView:self.bottomview bottomMargin:18];

}
-(void)UpdateCellLayout{

}
-(void)SkipPersonView{

    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":self.model.msgdetailmodel.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:self.model.msgdetailmodel.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}

-(void)guanzhuAct{

}
-(void)moreAct:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didClickMoreCell:)]) {
        [self.delegate didClickMoreCell:self];
    }
}
-(void)shareAct:(id)sender{
    if ([BXLiveUser isLogin]) {
        [DynSharePopViewManager shareWithVideoId:[NSString stringWithFormat:@"%@",self.model.fcmid] user_Id:self.model.msgdetailmodel.user_id likeNum:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.like_num] is_zan:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.extend_already_live] is_collect:@"" is_follow:self.model.msgdetailmodel.extend_followed vc:self.viewController type:1 share_type:@"PlantingGrass"];
    } else {
        [self pushToLoginVC];
    }
}
-(void)comAct:(id)sender{
    if ([_model.msgdetailmodel.render_type intValue] != 7) {
    
        SLAmwayListModel *model = [[SLAmwayListModel alloc]init];
        model.list_id = [NSNumber numberWithString:[NSString stringWithFormat:@"%@", _model.fcmid]];
        model.user.avatar = _model.msgdetailmodel.avatar;
        model.address = _model.msgdetailmodel.address;
        model.user.nickname = _model.msgdetailmodel.nickname;
        
        UIViewController *vc = [[CTMediator sharedInstance] TMSeedingPictureDetailVC_ViewControllerWithListModel:model DynModel:_model];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)likeAct:(id)sender{
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/grass/msg_live" parameters:@{@"fcmid":[self.model fcmid]} success:^(id  _Nonnull responseObject) {

        if ([responseObject[@"code"] intValue] == 0) {
            if ([[NSString stringWithFormat:@"%@",weakSelf.model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
                weakSelf.model.msgdetailmodel.extend_already_live = @"0";
                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] - 1;
                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];

                weakSelf.likeImage.image = CImage(@"dyn_issue_like_whiteBack");
                weakSelf.likeNumlable.text = [NSString stringWithFormat:@"%ld", (long)like_num];
                [[NSNotificationCenter defaultCenter] postNotificationName:TMSeedLikeStatus object:nil userInfo:@{@"model":self.model, @"fcmid":self.model.fcmid, @"status":@"0"}];
            }else{
                weakSelf.likeImage.image = CImage(@"dyn_issue_liked");
                weakSelf.model.msgdetailmodel.extend_already_live = @"1";
                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] + 1;
                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];
                weakSelf.likeNumlable.text = [NSString stringWithFormat:@"%ld", (long)like_num];
                [[NSNotificationCenter defaultCenter] postNotificationName:TMSeedLikeStatus object:nil userInfo:@{@"model":self.model,@"fcmid":self.model.fcmid, @"status":@"1"}];
            }

        }else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"message"]];
        }
    }
    failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];

}

-(void)imageAct:(id)sender{
    
}
-(void)unfoldAct:(UILabel *)btn{

   


    if (!_model.isFold) {

        _unfoldBtn.text = @"展开";
        _model.isFold = YES;

    }else{

        _unfoldBtn.text = @"收起";
        _model.isFold = NO;
    }
    if ([self.delegate respondsToSelector:@selector(didClickUnfoldInCell:)]) {
        [self.delegate didClickUnfoldInCell:self];
    }


}

-(void)updateCenterView{

}
-(void)updateDownView{


    if (!_addressimage.hidden){
        
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self.contentView, 12).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_addressimage, 15).heightIs(25);
    }else{

        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_concenterBackview, 15).heightIs(25);
    }





}
- (void)pushToLoginVC {
//    [BXCodeLoginVC toLoginViewControllerWithNav:self.viewController.navigationController];
    [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":self.viewController.navigationController}];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DetailBaseheaderView.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailBaseheaderView.h"
#import "HttpMakeFriendRequest.h"
#import "DynSharePopViewManager.h"
#import "BXDynCircelOperAlert.h"
#import "BXDynTipOffVC.h"
#import "BXDynRollCircleCategory.h"
//#import "BXPersonHomeVC.h"
#import "BXDynDidDisbandAlert.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
@interface DetailBaseheaderView()
@property(nonatomic, strong)UILabel *linelable;
@property(nonatomic, strong)UIView *moreView;
@end
@implementation DetailBaseheaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setView];
//        self.backgroundColor = [UIColor cyanColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendChangeStatus:) name:DynamdicCommentStatusNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddNumberAct) name:DynamdicCommenAddtNumberNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SubNumberAct) name:DynamdicCommenSubtNumberNotification object:nil];
    }
    return self;
}
-(void)initView{
    
}
-(void)setView{
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _topView.layer.cornerRadius = 5;
    _topView.layer.masksToBounds = YES;
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SkipCircleAct)];
    [_topView addGestureRecognizer:topTap];
    _topView.userInteractionEnabled = YES;
    
    _topHeaderImage = [[UIImageView alloc]init];
//    _topHeaderImage.backgroundColor = [UIColor randomColor];
    _topHeaderImage.layer.cornerRadius = 5;
    _topHeaderImage.layer.masksToBounds = YES;
    
    _topTitlelable = [[UILabel alloc]init];
//    _topTitlelable.backgroundColor = [UIColor randomColor];
    _topTitlelable.textAlignment = 0;
    _topTitlelable.font = [UIFont systemFontOfSize:14];
    
    _topConcentlable = [UILabel new];
//    _topConcentlable.backgroundColor = [UIColor randomColor];
    _topConcentlable.textAlignment = 0;
    _topConcentlable.textColor = UIColorHex(#8C8C8C);
    _topConcentlable.font = [UIFont systemFontOfSize:12];
    
    UIImageView *rightRowImage = [[UIImageView alloc]init];
    rightRowImage.image = [UIImage imageNamed:@"icon_dyn_circle_right_row"];
    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.backgroundColor = sl_subBGColors;
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = 20;
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SkipPersonView)];
    [_headerImage addGestureRecognizer:headerTap];
    _headerImage.userInteractionEnabled = YES;
    
    
    _namelable = [[UILabel alloc]init];
    _namelable.font = [UIFont systemFontOfSize:14];
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
    textContainerInset1.bottom = 0;
    self.contentlable.textContainerInset = textContainerInset1;
    self.contentlable.numberOfLines = 0 ;
    self.contentlable.font = CFont(15);
    self.contentlable.textAlignment = NSTextAlignmentLeft;
    
    _concenterBackview = [[UIView alloc]init];
//    _concenterBackview.backgroundColor = [UIColor cyanColor];
    
    _unfoldBtn = [[UILabel alloc]init];
    _unfoldBtn.textColor = UIColorHex(#91B8F4);
    _unfoldBtn.text = @"展开";
    _unfoldBtn.font = [UIFont systemFontOfSize: 14];
    UITapGestureRecognizer *unfoldtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unfoldAct:)];
    [_unfoldBtn addGestureRecognizer:unfoldtap];
    _unfoldBtn.userInteractionEnabled = YES;
    
    
    
    _bottomview = [[UIView alloc]init];
//    _bottomview.backgroundColor = [UIColor randomColor];
    
    
    _likeImage = [[UIImageView alloc]init];
    _likeImage.image = [UIImage imageNamed:@"dyn_like_gray"];
    UITapGestureRecognizer *liketap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAct:)];
    [_likeImage addGestureRecognizer:liketap];
    _likeImage.userInteractionEnabled = YES;
    
    
    _likeNumlable = [[UILabel alloc]init];
    _likeNumlable.text = @"1.0w";
    _likeNumlable.font = [UIFont systemFontOfSize:12];
    
    
    UIImageView *comimage = [[UIImageView alloc]init];
    comimage.image = [UIImage imageNamed:@"dyn_comment_gray"];
    UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comAct:)];
    [comimage addGestureRecognizer:comtap];
    comimage.userInteractionEnabled = YES;
    
    
    _commentNumlable = [[UILabel alloc]init];
    _commentNumlable.text = @"10";
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
//    UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct:)];
//    [moreimage addGestureRecognizer:moretap];
//    moreimage.userInteractionEnabled = YES;
    
    
    _addressimage = [[UIImageView alloc]init];
    _addressimage.image = [UIImage imageNamed:@"dyn_issue_adress"];

    
    
    _addressname = [[UILabel alloc]init];
    _addressname.font = SLPFFont(12);
    _addressname.textColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.6];
    
    _quanzibackview = [[UIView alloc]init];
    _quanzibackview.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _quanzibackview.layer.cornerRadius = 10;
    _quanzibackview.layer.masksToBounds = YES;
    
    
    _quanziimage = [[UIImageView alloc]init];
    _quanziimage.image = [UIImage imageNamed:@"dyn_issue_new_quanzi"];
//    _quanziimage.backgroundColor = [UIColor randomColor];
    
    
    _quanzititle = [[UILabel alloc]init];
    _quanzititle.font = [UIFont systemFontOfSize:12];
    _quanzititle.text = @"潮服时装";
    _quanzititle.textColor = UIColorHex(#8C8C8C);
    
    
    _quanzigaunzhu = [[UILabel alloc]init];
    _quanzigaunzhu.font = [UIFont systemFontOfSize:12];
    _quanzigaunzhu.text = @"关注";
    _quanzigaunzhu.textAlignment = 1;
    _quanzigaunzhu.textColor = UIColorHex(#91B8F4);
    UITapGestureRecognizer *guanzhutap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanzhuAct)];
    [_quanzigaunzhu addGestureRecognizer:guanzhutap];
    _quanzigaunzhu.userInteractionEnabled = YES;
    
    _linelable = [[UILabel alloc]init];
    _linelable.backgroundColor = [UIColor blackColor];
    
    UILabel *downLabel = [[UILabel alloc]init];
    downLabel.backgroundColor = UIColorHex(#EAEAEA);
    
    _NotCommentLable = [UILabel new];
    _NotCommentLable.text = @"暂无评论";
    _NotCommentLable.textColor = UIColorHex(#B2B2B2);
    _NotCommentLable.font = [UIFont systemFontOfSize:14];
    
    _allcommentLabel = [UILabel new];
    _allcommentLabel.text = @"所有评论";
    _allcommentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    
    [self sd_addSubviews:@[self.topView, self.headerImage, self.namelable, self.genderImage, self.timelable, self.concenterBackview, self.contentlable,self.unfoldBtn, self.quanzibackview,self.addressname, self.addressimage,self.bottomview, downLabel, self.allcommentLabel, self.NotCommentLable]];
    
    _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 12).rightSpaceToView(self, 12).heightIs(62);

    [_topView sd_addSubviews:@[_topHeaderImage, _topTitlelable, _topConcentlable, rightRowImage]];

    _topHeaderImage.sd_layout.leftSpaceToView(_topView, 7).centerYEqualToView(_topView).widthIs(48).heightIs(48);
    _topTitlelable.sd_layout.leftSpaceToView(_topHeaderImage, 5).topSpaceToView(_topView, 10).rightSpaceToView(_topView, 20).heightIs(20);
    _topConcentlable.sd_layout.leftSpaceToView(_topHeaderImage, 5).topSpaceToView(_topTitlelable, 5).rightSpaceToView(_topView, 20).heightIs(17);
    rightRowImage.sd_layout.rightSpaceToView(_topView, 12).centerYEqualToView(_topView).widthIs(8).heightIs(10);
    
    _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self.topView, 0).widthIs(40).heightIs(40);
    _namelable.sd_layout.leftSpaceToView(_headerImage, 10).topEqualToView(_headerImage).widthIs(50).heightIs(20);
    _genderImage.sd_layout.leftSpaceToView(_namelable, 5).centerYEqualToView(_namelable).widthIs(10).heightIs(10);
    _timelable.sd_layout.leftSpaceToView(_headerImage, 10).topSpaceToView(_namelable, 0).widthIs(100).heightIs(20);
    _contentlable.sd_layout.leftSpaceToView(self, 12).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 12).heightIs(100);
    _unfoldBtn.sd_layout.leftEqualToView(_contentlable).topSpaceToView(_contentlable, 0).widthIs(40).heightIs(30);
    _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_unfoldBtn, 5).heightIs(200);
    _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 0).widthIs(100).heightIs(20);
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    
    
    [_quanzibackview sd_addSubviews:@[_quanziimage, _quanzititle, _quanzigaunzhu, _linelable]];
    _quanziimage.sd_layout.leftEqualToView(_quanzibackview).offset(5).centerYEqualToView(_quanzibackview).widthIs(15).heightIs(15);
    _quanzititle.sd_layout.leftSpaceToView(_quanziimage, 5).offset(5).centerYEqualToView(_quanzibackview).widthIs(50).heightIs(20);
    _linelable.sd_layout.leftSpaceToView(_quanzititle, 5).centerYEqualToView(_quanzibackview).widthIs(1).heightIs(15);
    _quanzigaunzhu.sd_layout.leftSpaceToView(_linelable, 5).centerYEqualToView(_quanzibackview).widthIs(30).heightIs(20);
    
    [_bottomview sd_addSubviews:@[_likeImage, _likeNumlable, comimage, _commentNumlable, shareimage, _moreView]];
    _likeImage.sd_layout.leftEqualToView(_bottomview).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _likeNumlable.sd_layout.leftSpaceToView(_likeImage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    comimage.sd_layout.leftSpaceToView(_likeNumlable, 5).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _commentNumlable.sd_layout.leftSpaceToView(comimage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    shareimage.sd_layout.leftSpaceToView(_commentNumlable, 5).centerYEqualToView(_bottomview).widthIs(23).heightIs(22);
    _moreView.sd_layout.rightSpaceToView(_bottomview, 0).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    [_moreView sd_addSubviews:@[moreimage]];
    moreimage.sd_layout.rightSpaceToView(_moreView, 0).centerYEqualToView(_moreView).widthIs(20).heightIs(4);
    
    _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
    _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20 + 55);
    
    downLabel.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_bottomview, 15).heightIs(1);
    
    _NotCommentLable.sd_layout.centerXEqualToView(self).topSpaceToView(downLabel, 15).heightIs(20).widthIs(60);
    _allcommentLabel.sd_layout.topSpaceToView(downLabel, 15).leftSpaceToView(self, 12).widthIs(60).heightIs(20);
    _allcommentLabel.hidden = YES;
//    _NotCommentLable.hidden = YES;

//    [self GetConcentHeight];
}
-(void)GetConcentHeight{
    [self layoutIfNeeded];
    [self.contentlable sizeToFit];
    //获取contentlable的高度
    CGFloat  textH = [self.contentlable sizeThatFits:CGSizeMake(__kWidth - 24, MAXFLOAT)].height;
    self.contentHeight = textH;
    //获取行数
    CGFloat lineHeight = self.contentlable.font.lineHeight;
    self.lineHeight = lineHeight;
    NSInteger  lineCount = textH / lineHeight;
    if (lineCount <= 3) {
        _unfoldBtn.hidden = YES;
        
        _concenterBackview.sd_layout.topSpaceToView(_contentlable, 10);
        
        _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 90).heightIs(textH);
        
    }else{
        _concenterBackview.sd_layout.topSpaceToView(_unfoldBtn, 10);
        if (_model.isFold) {
            _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 15).rightSpaceToView(self, 86).heightIs(textH);
            _unfoldBtn.text = @"收起";
        }else{
            _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 15).rightSpaceToView(self, 86).heightIs(lineHeight * 3 + 15);
            _unfoldBtn.text = @"展开";
        }
        _unfoldBtn.hidden = NO;
        
    }
}
-(void)setModel:(BXDynamicModel *)model{
    [self layoutIfNeeded];
    [model.msgdetailmodel processAttributedString];
    _model = model;
    self.namelable.text = model.msgdetailmodel.nickname;
    NSString *user_avatar = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.msgdetailmodel.avatar];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:user_avatar]];

    self.namelable.sd_layout.leftSpaceToView(self.headerImage, 10).topEqualToView(self.headerImage).widthIs([UILabel getWidthWithTitle:self.namelable.text font:self.namelable.font]).heightIs(20);
    self.timelable.text = model.msgdetailmodel.difftime;
//    self.contentlable.text = model.msgdetailmodel.content;
    self.contentlable.attributedText = model.msgdetailmodel.attatties;

    
    if ([model.msgdetailmodel.address isEqualToString:@""]) {
        _addressimage.hidden = YES;
    }else{
        _addressimage.hidden = NO;
        self.addressname.text = model.msgdetailmodel.address;
    }
    
    if ([[NSString stringWithFormat:@"%@",model.msgdetailmodel.gender] isEqualToString:@"2"]) {
        _genderImage.image = [UIImage imageNamed:@"icon_dyn_gender_girlicon_dyn_gender_boy"];
    }else{
        _genderImage.image = [UIImage imageNamed:@"icon_dyn_gender_boy"];
    }
    if ([[NSString stringWithFormat:@"%@",model.msgdetailmodel.extend_circlfollowed] isEqualToString:@"1"]) {
        _quanzigaunzhu.hidden = YES;
        _linelable.hidden = YES;
    }else{
        _quanzigaunzhu.hidden = NO;
        _linelable.hidden = NO;
    }
    if ([[NSString stringWithFormat:@"%@",model.ismysender] isEqualToString:@"1"]) {
        _moreView.hidden = YES;
    }else{
        _moreView.hidden = NO;
    }
    
    if (model.msgdetailmodel.extend_circledetailArray.count && !model.isHiddenCircle) {
        self.topView.hidden = NO;
        self.quanzibackview.hidden = NO;
        [self.topHeaderImage sd_setImageWithURL:[NSURL URLWithString:[model.msgdetailmodel.extend_circledetailArray[0] circle_cover_img]] placeholderImage:CImage( @"placeplaceholder")];
        self.topTitlelable.text = [model.msgdetailmodel.extend_circledetailArray[0] circle_name];
        self.topConcentlable.text = [model.msgdetailmodel.extend_circledetailArray[0] circle_describe];
        self.quanzititle.text = [model.msgdetailmodel.extend_circledetailArray[0] circle_name];
        if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.extend_circlfollowed] isEqualToString:@"0"]) {
            self.quanzigaunzhu.hidden = NO;
        }else{
            self.quanzigaunzhu.hidden = YES;
            self.linelable.hidden = YES;
        }
    }else{
        self.topView.hidden = YES;
        self.quanzibackview.hidden = YES;
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
    CGFloat  textH = [self.contentlable sizeThatFits:CGSizeMake(__kWidth - 24, MAXFLOAT)].height;
    self.contentHeight = textH;
    //获取行数
    CGFloat lineHeight = self.contentlable.font.lineHeight;
    self.lineHeight = lineHeight;
    NSInteger  lineCount = textH / lineHeight;
    if (lineCount <= 3) {
        _unfoldBtn.hidden = YES;
        
        _concenterBackview.sd_layout.topSpaceToView(_contentlable, 10);
        
            _contentlable.sd_layout.leftSpaceToView(self, 12).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 12).heightIs(textH);
        
    }else{
        _concenterBackview.sd_layout.topSpaceToView(_unfoldBtn, 10);
        if (_model.isFold) {
            _contentlable.sd_layout.leftSpaceToView(self, 12).topSpaceToView(_headerImage, 15).rightSpaceToView(self, 12).heightIs(textH);
            _unfoldBtn.text = @"收起";
        }else{
            _contentlable.sd_layout.leftSpaceToView(self, 12).topSpaceToView(_headerImage, 15).rightSpaceToView(self, 12).heightIs(lineHeight * 3 + 15);
            _unfoldBtn.text = @"展开";
        }
        _unfoldBtn.hidden = NO;
        
    
    }
    
    [self updateHeaderView];
    [self updateCenterView];
    [self updateDownView];
    [self setupAutoHeightWithBottomView:self.bottomview bottomMargin:55];
}
-(void)SkipPersonView{
//    [self.delegate didClickHeaderCell:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":self.model.msgdetailmodel.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:self.model.msgdetailmodel.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}
-(void)SkipCircleAct{
     BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
    [model updateWithJsonDic:self.model.msgdetailmodel.extend_circledetail[0]];
    model.isHiddenTop = YES;
    if ([[NSString stringWithFormat:@"%@", model.dismiss] isEqualToString:@"1"]) {
        [HttpMakeFriendRequest DetailCircleWithcircle_id:model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                BXDynCircleModel *dissmodel = [[BXDynCircleModel alloc]init];
                [dissmodel updateWithJsonDic:jsonDic[@"data"]];
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                BXDynDidDisbandAlert *alert = [[BXDynDidDisbandAlert alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
                alert.model = dissmodel;
                [alert showWithView:window];
            }
            else{
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD showInfoWithMessage:@"获取圈子详情失败"];
        }];

    }else{
    BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
    vc.model = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)guanzhuAct{
     [self.delegate DidClickType:3];
}
-(void)moreAct:(id)sender{
//     [self.delegate DidClickType:2];
    WS(weakSelf);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
   BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报",@"取消"]];
       OperationAlert.DidOpeClick = ^(NSInteger tag) {
           if (tag == 0) {
               
               BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
               vc.model = weakSelf.model;
               vc.reporttype = @"2";
               vc.reportmsg_id = self.model.fcmid;
               [self.viewController.navigationController pushViewController:vc animated:YES];
           }
       
       };
       [OperationAlert showWithView:window];
}
-(void)shareAct:(id)sender{
//    [self.delegate DidClickType:1];
        [DynSharePopViewManager shareWithVideoId:self.model.fcmid user_Id:self.model.msgdetailmodel.user_id likeNum:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.like_num] is_zan:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.extend_already_live] is_collect:@"" is_follow:self.model.msgdetailmodel.extend_followed vc:self.viewController type:1 share_type:@"dynamic"];

}
-(void)comAct:(id)sender{
    
}
-(void)likeAct:(id)sender{
    [self.delegate DidClickType:0];
    WS(weakSelf);
    [HttpMakeFriendRequest GiveLikeWithfcmid:[self.model fcmid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            if ([[NSString stringWithFormat:@"%@",weakSelf.model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
                weakSelf.model.msgdetailmodel.extend_already_live = @"0";
                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] - 1;
                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];
            }else{
                weakSelf.model.msgdetailmodel.extend_already_live = @"1";
                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] + 1;
                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];
            }
             [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicLikeStatusNotification object:nil userInfo:@{@"model":self.model}];

            [self setModel:weakSelf.model];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
-(void)whispersAct:(id)sender{
    
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
        if ([self.delegate respondsToSelector:@selector(Didfold:)]) {
            [self.delegate Didfold:_model];
        }
}
-(void)updateHeaderView{
    
    if (_topView.hidden){
        _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 15).rightSpaceToView(self, 15).heightIs(62);
        _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 15).widthIs(40).heightIs(40);
    }else{
        _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 15).rightSpaceToView(self, 15).heightIs(62);
        _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self.topView, 15).widthIs(40).heightIs(40);
       
    }
}
- (void)sendChangeStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    BXDynamicModel *model = info[@"model"];
    self.model = model;
    self.commentNumlable.text = [NSString stringWithFormat:@"%@", model.msgdetailmodel.comment_num];
    
}
-(void)AddNumberAct{
    
}
-(void)SubNumberAct{
    
}
-(void)updateCenterView{
    
}
-(void)updateDownView{

    if (_addressimage.hidden && !_quanzibackview.hidden) {
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 13).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_quanzibackview, 15).heightIs(25);
    }
    else if (!_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_quanzibackview, 15).heightIs(25);
    }else if(_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_concenterBackview, 15).heightIs(25);
    }else{
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 15).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 13).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).rightSpaceToView(self, 12).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 15).heightIs(25);
    }
    

    if (_quanzigaunzhu.hidden) {
        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 30);
    }else{

        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 35 + 40);
    }

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

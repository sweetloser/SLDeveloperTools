//
//  BXCommentHeaderView.m
//  BXlive
//
//  Created by bxlive on 2019/5/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "GHDynCommentHeaderView.h"
#import <Lottie/Lottie.h>
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import <YYText/YYText.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoMacro.h"

@interface GHDynCommentHeaderView ()

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

@end

@implementation GHDynCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
     if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
         self.backgroundColor = [UIColor whiteColor];

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
         
         //昵称
//         self.nickNameBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(13) Color:SubTitleColor Image:nil Target:self action:@selector(avatarOrNicknameDidClicked) forControlEvents:UIControlEventTouchUpInside];
//         [self.contentView addSubview:self.nickNameBtn];
//         self.nickNameBtn.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.contentView, 20).widthIs(50).heightIs(17);
         
         self.nickNameLabel = [[UILabel alloc]init];
         self.nickNameLabel.textColor = [UIColor blackColor];
         self.nickNameLabel.font = SLBFont(14);
         [self.contentView addSubview:self.nickNameLabel];
         self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.contentView, 12).rightSpaceToView(self.contentView, 40).heightIs(19);
         
         //作者
//         self.authorImageView = [[UIImageView alloc]init];
//         self.authorImageView.image = [UIImage imageNamed:@"icon_attention_auto"];
//         [self.contentView addSubview:self.authorImageView];
         
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
         
//         _contentLabel = [[YYLabel alloc]init];
//         _contentLabel.backgroundColor = [UIColor cyanColor];

//         _contentLabel.numberOfLines = 0;
//         _contentLabel.textColor = [UIColor blackColor];
//         _contentLabel.font = [UIFont systemFontOfSize:14];
//         [self.contentView addSubview:_contentLabel];
//         self.contentLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.timeLabel, 5).rightSpaceToView(self.contentView, 58).heightIs(19);
         
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
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.create_time ];
//    NSString *contentString = @"";
//    if (model.reply_user_id && ![[NSString stringWithFormat:@"%@", model.reply_user_id] isEqualToString:@""]) {
//        contentString = [NSString stringWithFormat:@"回复 %@: %@", model.reply_nickname, model.content];
//    }else{
//        contentString = model.content;
//    }
//    self.contentLabel.text = contentString;
//    [model processAttributedStringWithIsChild:YES];
//    self.contentLabel.text = model.content;
//    CGFloat  textH = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
    if (!_isChild) {
        self.contentLabel.attributedText = model.attatties;
        self.contentLabel.sd_layout.heightIs(model.headerHeight + 10);
        
    }else{
        self.contentLabel.attributedText = model.DetailChildattatties;
        self.contentLabel.sd_layout.heightIs(model.ChildheaderHeight + 10);
    }
//    if ([model.is_like integerValue] == 0) {
//        self.clickZanBtn.selected = NO;
//    }else{
//        self.clickZanBtn.selected = YES;
//    }
//    [self.clickZanBtn setTitle:[NSString stringWithFormat:@"%@",model.like_count] forState:UIControlStateNormal];
    
//    float nickNameWidth = [BXCalculate calculateRowWidth:self.nickNameBtn.titleLabel.text Font:CFont(13)];
//    if (nickNameWidth > 195) {
//        nickNameWidth = 195;
//    } else if (__kWidth <= 320) {
//        if (nickNameWidth > 130) {
//            nickNameWidth = 130;
//        }
//    }
//    self.nickNameBtn.sd_layout.widthIs(nickNameWidth);
    
//    if ([model.is_anchor integerValue]==0) {
//        self.authorImageView.hidden = YES;
//    }else{
//        self.authorImageView.hidden = NO;
//    }
//    self.authorImageView.sd_layout.leftSpaceToView(self.nickNameBtn, 8).topSpaceToView(self.contentView, 22).widthIs(29).heightIs(13);
    
//    self.timeLabel.attributedText = model.attatties;
//    self.timeLabel.sd_layout.heightIs(model.headerHeight-45);
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
    
//       [BXPersonHomeVC toPersonHomeWithUserId:self.model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
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

@end

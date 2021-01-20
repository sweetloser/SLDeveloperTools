//
//  BXDynDetailNoPicCommentView.m
//  BXlive
//
//  Created by mac on 2020/7/31.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynDetailNoPicCommentView.h"
#import <Lottie/Lottie.h>
#import <YYText/YYText.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoMacro.h"
@interface BXDynDetailNoPicCommentView ()

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

@implementation BXDynDetailNoPicCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
//        UIButton *btn = [[UIButton alloc]init];
//        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//        btn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        //头像
        self.headImageView = [[UIImageView alloc]init];
        self.headImageView.sd_cornerRadius = @(19);
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.userInteractionEnabled = YES;
//        [self addSubview:self.headImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarOrNicknameDidClicked)];
        [self.headImageView addGestureRecognizer:tap];
    
        
        
        self.nickNameLabel = [[UILabel alloc]init];
        self.nickNameLabel.textColor = [UIColor blackColor];
        self.nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
//        [self addSubview:self.nickNameLabel];
        
        
        
        
        //内容&时间
        self.timeLabel = [[YYLabel alloc]init];
        UIEdgeInsets textContainerInset = self.timeLabel.textContainerInset;
        self.timeLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
        textContainerInset.top = 0;
        textContainerInset.bottom = 0;
        self.timeLabel.textContainerInset = textContainerInset;
        self.timeLabel.textColor = UIColorHex(#B2B2B2);
        self.timeLabel.numberOfLines = 0;
        self.timeLabel.font = CFont(15);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:self.timeLabel];
        
        
        UIImageView *moreimage = [[UIImageView alloc]init];
        moreimage.image = [UIImage imageNamed:@"dyn_issue_more"];
        UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct)];
        [moreimage addGestureRecognizer:moretap];
        moreimage.userInteractionEnabled = YES;
//        [self addSubview:moreimage];
       
        
        self.contentLabel = [[YYLabel alloc]init];
        self.contentLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
        UIEdgeInsets textContainerInset1 = self.contentLabel.textContainerInset;
        textContainerInset1.top = 0;
        textContainerInset1.bottom = 0;
        self.contentLabel.textContainerInset = textContainerInset1;
        self.contentLabel.numberOfLines = 0 ;
        self.contentLabel.font = CFont(14);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        UITapGestureRecognizer *contenttap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsgAct)];
        [_contentLabel addGestureRecognizer:contenttap];
        _contentLabel.userInteractionEnabled = YES;
        
        
        UILabel *downlabel = [[UILabel alloc]init];
        downlabel.backgroundColor = UIColorHex(#EAEAEA);
//        [self addSubview:downlabel];
        
        
            [self sd_addSubviews:@[self.headImageView, self.nickNameLabel, self.timeLabel,moreimage,_contentLabel, downlabel]];
        self.headImageView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 12).widthIs(38).heightIs(38);
        self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self, 12).widthIs(100).heightIs(19);
        self.timeLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.nickNameLabel, 0).widthIs(SCREEN_WIDTH-110).heightIs(19);
         moreimage.sd_layout.rightSpaceToView(self, 12).centerYEqualToView(self.headImageView).widthIs(20).heightIs(4);
        self.contentLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.timeLabel, 5).rightSpaceToView(self, 40).heightIs(19);
        downlabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.contentLabel, 15).rightSpaceToView(self, 0).heightIs(.5);
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
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.create_time ];
//    self.contentLabel.text = model.content;
    self.contentLabel.attributedText = model.attatties;
//    CGFloat  textH = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
    self.contentLabel.sd_layout.heightIs(model.headerHeight + 10);
    
     [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:30];

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
    if (self.toPersonHome) {
        self.toPersonHome(_model.user_id);
    }
}
-(void)sendMsgAct{
    if (self.SendMsgClick) {
        self.SendMsgClick(_model);
    }
}

@end

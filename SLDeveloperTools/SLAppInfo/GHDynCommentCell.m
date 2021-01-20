//
//  BXCommentCell.m
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "GHDynCommentCell.h"
#import <YYCategories/YYCategories.h>
#import <YYText/YYText.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLUtilities/SLUtilities.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import "NewHttpRequestHuang.h"


@interface GHDynCommentCell ()

/** 头像 */
@property (strong, nonatomic) UIImageView *headImageView;
/** 昵称 */
//@property (strong, nonatomic) YYLabel *nickNameLabel;
@property (nonatomic , strong) UIButton * nickNameBtn;
/** 是否是作者 */
@property (strong, nonatomic) UIImageView *authorImageView;
/** 回复昵称按钮 */
@property (nonatomic , strong) UIButton * replyNickNameBtn;
/** 内容 */
@property (strong, nonatomic) YYLabel *contentLabel;
/** 时间 */
@property (strong, nonatomic) YYLabel *timeLabel;
/** 点赞按钮 */
@property (strong, nonatomic) UIButton *clickZanBtn;

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * commentReplyArray;

@end

@implementation GHDynCommentCell

-(NSMutableArray *)commentReplyArray{
    if(!_commentReplyArray){
        _commentReplyArray = [NSMutableArray array];
    }
    return _commentReplyArray;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BXCommentCell";
    GHDynCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //头像
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.sd_cornerRadius = @(11.5);
    self.headImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarOrNicknameDidClicked)];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.sd_layout.leftSpaceToView(self.contentView, 60).topSpaceToView(self.contentView, 12).widthIs(23).heightIs(23);
    
    //昵称
    self.nickNameBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(13) Color:SubTitleColor Image:nil Target:self action:@selector(avatarOrNicknameDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nickNameBtn];
    self.nickNameBtn.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.contentView, 14).widthIs(50).heightIs(17);
    
    //作者
    self.authorImageView = [[UIImageView alloc]init];
    self.authorImageView.image = [UIImage imageNamed:@"icon_attention_auto"];
    [self.contentView addSubview:self.authorImageView];
    
    //内容&时间
    self.contentLabel = [[YYLabel alloc]init];
    self.contentLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
    UIEdgeInsets textContainerInset = self.contentLabel.textContainerInset;
    textContainerInset.top = 0;
    textContainerInset.bottom = 0;
    self.contentLabel.textContainerInset = textContainerInset;
    self.contentLabel.numberOfLines = 0 ;
    self.contentLabel.font = CFont(15);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.sd_layout.leftSpaceToView(self.headImageView, 8).topSpaceToView(self.nickNameBtn, 4).heightIs(20).widthIs(SCREEN_WIDTH-141);
    
    //点赞
    self.clickZanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickZanBtn setBackgroundColor:[UIColor clearColor]];
    [self.clickZanBtn setImage:[UIImage imageNamed:@"icon_comment_zan_no"] forState:UIControlStateNormal];
    [self.clickZanBtn setImage:[UIImage imageNamed:@"icon_comment_zan_yes"] forState:UIControlStateSelected];
    [self.clickZanBtn setTitleColor:MinorColor forState:UIControlStateNormal];
    [self.clickZanBtn setTitleColor:CHHCOLOR_D(0xDE2E52) forState:UIControlStateSelected];
    self.clickZanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.clickZanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.clickZanBtn addTarget:self action:@selector(clickZanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.clickZanBtn];
    self.clickZanBtn.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 12).widthIs(34).heightIs(48);
    self.clickZanBtn.imageView.sd_layout.centerXEqualToView(self.clickZanBtn).topSpaceToView(self.clickZanBtn, 5).widthIs(23).heightIs(23);
    self.clickZanBtn.titleLabel.sd_layout.centerXEqualToView(self.clickZanBtn).bottomSpaceToView(self.clickZanBtn, 4).widthIs(34).heightIs(16);
    self.exclusiveTouch = YES;
    self.clickZanBtn.exclusiveTouch = YES;
}

-(void)setModel:(BXCommentModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    [self.nickNameBtn setTitle:model.nickname forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
    if ([model.is_like integerValue] == 0) {
        self.clickZanBtn.selected = NO;
    }else{
        self.clickZanBtn.selected = YES;
    }
    [self.clickZanBtn setTitle:[NSString stringWithFormat:@"%@",model.like_count] forState:UIControlStateNormal];
    
    float nickNameWidth = [BXCalculate calculateRowWidth:self.nickNameBtn.titleLabel.text Font:CFont(13)];
    if (nickNameWidth > 195) {
        nickNameWidth = 195;
    } else if (__kWidth <= 320) {
        if (nickNameWidth > 130) {
            nickNameWidth = 130;
        }
    }
    self.nickNameBtn.sd_layout.widthIs(nickNameWidth);
    
    if ([model.is_anchor integerValue]==0) {
        self.authorImageView.hidden = YES;
    }else{
        self.authorImageView.hidden = NO;
    }
    self.authorImageView.sd_layout.leftSpaceToView(self.nickNameBtn, 8).topSpaceToView(self.contentView, 16).widthIs(29).heightIs(13);
    
    self.contentLabel.attributedText = model.attatties;
    self.contentLabel.sd_layout.heightIs(model.rowHeight-35);
}

- (void)setColorType:(NSInteger)colorType {
    if (colorType) {
        [self.nickNameBtn setTitleColor:CHHCOLOR_D(0x4A4F4F) forState:BtnNormal];
    } else {
        [self.nickNameBtn setTitleColor:UIColorHex(A8AFAF) forState:BtnNormal];
    }
}

#pragma mark - 点击头像和昵称跳转个人主页
- (void)avatarOrNicknameDidClicked
{
    if (self.toPersonHome) {
        self.toPersonHome();
    }
}

#pragma mark - 点赞
- (void)clickZanBtnClick:(UIButton *)btn
{
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentLikeWithCommentID:_model.comment_id Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                self.model.is_like = [NSString stringWithFormat:@"%@",dataDic[@"status"]];
                self.model.like_count = [NSString stringWithFormat:@"%@",dataDic[@"total"]];
                self.clickZanBtn.selected = IsEquallString(self.model.is_like, @"1");
                [self.clickZanBtn setTitle:[NSString stringWithFormat:@" %@",self.model.like_count] forState:UIControlStateNormal];
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];

}

@end

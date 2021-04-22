//
//  GHDynNoPicCommentCell.m
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import "GHDynNoPicCommentCell.h"
#import <YYCategories/YYCategories.h>
#import <YYText/YYText.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>
@interface GHDynNoPicCommentCell ()

/** 昵称 */
//@property (strong, nonatomic) YYLabel *nickNameLabel;
@property (nonatomic , strong) UIButton * nickNameBtn;

/** 回复昵称按钮 */
@property (nonatomic , strong) UIButton * replyNickNameBtn;
/** 内容 */
@property (strong, nonatomic) YYLabel *contentLabel;

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * commentReplyArray;

@end
@implementation GHDynNoPicCommentCell
-(NSMutableArray *)commentReplyArray{
    if(!_commentReplyArray){
        _commentReplyArray = [NSMutableArray array];
    }
    return _commentReplyArray;
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
    
    //昵称
    self.nickNameBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(13) Color:SubTitleColor Image:nil Target:self action:@selector(avatarOrNicknameDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nickNameBtn];
    self.nickNameBtn.sd_layout.leftSpaceToView(self.contentView, 60).topSpaceToView(self.contentView, 12).widthIs(50).heightIs(17);
    

    //内容
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
    self.contentLabel.sd_layout.leftSpaceToView(self.contentView, 58).topSpaceToView(self.contentView, 4).heightIs(20).widthIs(SCREEN_WIDTH-116);
    
}

-(void)setModel:(BXDynCommentModel *)model{
    [self.contentView layoutIfNeeded];
    _model = model;
//    NSString *contentstring = @"";
    

    
//    if (model.reply_user_id && ![[NSString stringWithFormat:@"%@", model.reply_user_id] isEqualToString:@""]) {
//        contentstring = [NSString stringWithFormat:@"%@ 回复 %@: %@", model.nickname, model.reply_nickname, model.content];
//    }else{
//
//        if (model.user_id && ![[NSString stringWithFormat:@"%@", model.user_id]isEqualToString:@""]) {
//            contentstring = [NSString stringWithFormat:@"%@:%@", model.nickname, model.content];
//        }else{
//            contentstring = model.content;
//        }
//    }

    self.contentLabel.text = model.content;
    self.contentLabel.attributedText = model.attatties;
    self.contentLabel.sd_layout.heightIs(model.headerHeight + 10);
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:4];
//    if (model.is_anchor) {
//
//        self.contentLabel.text = model.content;
//    }else{
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
//
//         [att addAttribute:NSForegroundColorAttributeName value:UIColorHex(#91B8F4) range:[self.contentLabel.text rangeOfString:model.reply_nickname]];
//         [att addAttribute:@"name" value:@"name" range:[self.contentLabel.text rangeOfString:model.reply_nickname]];
//
//        self.contentLabel.text = [NSString stringWithFormat:@"%@:%@", model.reply_nickname, model.content];
//    }
//    [self.contentLabel sizeToFit];
//    CGFloat  textH = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
////    CGFloat lineHeight = self.contentLabel.font.lineHeight;
//
//    float nickNameWidth = [BXCalculate calculateRowWidth:self.nickNameBtn.titleLabel.text Font:CFont(13)];
//    if (nickNameWidth > 195) {
//        nickNameWidth = 195;
//    } else if (__kWidth <= 320) {
//        if (nickNameWidth > 130) {
//            nickNameWidth = 130;
//        }
//    }
//    self.nickNameBtn.sd_layout.widthIs(nickNameWidth);
//
//    self.contentLabel.attributedText = model.attatties;
//    self.contentLabel.sd_layout.heightIs(textH);
//    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:10];
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
//    if (self.toPersonHome) {
//        self.toPersonHome();
//    }
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

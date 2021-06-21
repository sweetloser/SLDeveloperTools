//
//  BXGameListCell.m
//  BXlive
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXGameListCell.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
@interface BXGameListCell()

@property (nonatomic , strong) UIImageView *headImageView;//头像
@property (nonatomic , strong) UILabel * nickNameLabel;//昵称
@property (nonatomic , strong) UILabel * signatureLabel;//个性签名

@end

@implementation BXGameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    BXGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGameListCell"];

    if (cell == nil) {
        cell = [[BXGameListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXGameListCell"];
    }

    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/**
 *  初始化控件
 */
- (void) setupUI{

    self.headImageView = [UIImageView new];

    self.nickNameLabel = [UILabel initWithFrame:CGRectZero size:__ScaleWidth(14) color:sl_textColors alignment:0 lines:1];
    self.signatureLabel =[UILabel initWithFrame:CGRectZero size:__ScaleWidth(12) color:sl_textSubColors alignment:0 lines:0];
    self.signatureLabel.isAttributedContent = YES;
    self.signatureLabel.numberOfLines = 0;
    [self.contentView sd_addSubviews:@[self.headImageView,self.nickNameLabel,self.signatureLabel]];
    self.headImageView.sd_layout.leftSpaceToView(self.contentView, __ScaleWidth(12)).centerYEqualToView(self.contentView).widthIs(__ScaleWidth(43)).heightEqualToWidth();
    self.headImageView.sd_cornerRadius = @(__ScaleWidth(21.5));
    
    self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, __ScaleWidth(30)).topSpaceToView(self.contentView, __ScaleWidth(15)).heightIs(__ScaleWidth(20)).rightSpaceToView(self.contentView, __ScaleWidth(12));
    
    self.signatureLabel.sd_layout.leftSpaceToView(self.headImageView, __ScaleWidth(30)).rightSpaceToView(self.contentView, __ScaleWidth(12)).topSpaceToView(self.nickNameLabel, __ScaleWidth(6)).autoHeightRatio(0);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = sl_divideLineColor;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(__ScaleWidth(12));
        make.right.mas_equalTo(__ScaleWidth(-12));
    }];
}

- (void)setLiveChannel:(BXLiveChannel *)liveChannel {
    _liveChannel = liveChannel;
    
    [self.headImageView zzl_setImageWithURLString:[NSURL URLWithString:liveChannel.icon] placeholder:nil];
    self.nickNameLabel.text = liveChannel.name;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:4];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:liveChannel.descriptions attributes:@{NSForegroundColorAttributeName:sl_textSubColors, NSParagraphStyleAttributeName: paragraphStyle}];
   self.signatureLabel.attributedText = string;
    
    [self setupAutoHeightWithBottomView:self.signatureLabel bottomMargin:11];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

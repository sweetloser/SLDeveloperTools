//
//  BXAttentionLiveCell.m
//  BXlive
//
//  Created by bxlive on 2019/8/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionLiveCell.h"
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import <YYText/YYText.h>
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"
#import <YYWebImage/YYWebImage.h>
#import <SDWebImage/SDWebImage.h>

@interface BXAttentionLiveCell()
@property (nonatomic ,strong) UIImageView *headImageView;//头像
@property (nonatomic ,strong) UILabel *nickNameLabel;//昵称
@property (nonatomic ,strong) UILabel *liveLabel;//直播
@property (nonatomic ,strong) YYLabel *titleLb;        //标题
@property (nonatomic ,strong) UIImageView *coveImageView;//封面
@property (nonatomic ,strong) UILabel *numLabel;//人数
@property (nonatomic ,strong) UILabel *lineLabel;
@property (nonatomic ,strong) UIView *topView;
//@property (nonatomic ,strong) UILabel *lineLabel;

@end

@implementation BXAttentionLiveCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    BXAttentionLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXAttentionLiveCell"];
    if (cell == nil) {
        cell = [[BXAttentionLiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXAttentionLiveCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.headImageView];
        self.headImageView.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.contentView, 16).widthIs(40).heightEqualToWidth();
        self.headImageView.sd_cornerRadius = @(20);
        
        
        //昵称
        self.nickNameLabel = [UILabel initWithFrame:CGRectZero size:16 color:MainTitleColor alignment:0 lines:1];
        self.nickNameLabel.font = CBFont(16);
        [self.contentView addSubview:self.nickNameLabel];
         self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, 8).centerYEqualToView(self.headImageView).heightIs(20);
        [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:150.f];
        
        
        //正在直播中
        self.liveLabel = [UILabel initWithFrame:CGRectZero size:16 color:MinorColor alignment:0 lines:1];
        [self.contentView addSubview:self.liveLabel];
        self.liveLabel.sd_layout.leftSpaceToView(self.nickNameLabel, 8).centerYEqualToView(self.headImageView).heightIs(20).rightSpaceToView(self.contentView, 15);
        self.liveLabel.text = @"· 正在直播中";
        
        //内容
        self.titleLb = [[YYLabel alloc] init];
        self.titleLb.numberOfLines = 0;
        [self.contentView addSubview:self.titleLb];
         self.titleLb.sd_layout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).topSpaceToView(self.headImageView, 14).heightIs(50);
        
        //封面
        self.coveImageView = [UIImageView new];
        self.coveImageView.sd_cornerRadius = @(8);
        self.coveImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.coveImageView];
         self.coveImageView.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.titleLb, 12).rightSpaceToView(self.contentView, 16).heightEqualToWidth();
        
        
        //直播人数
        self.topView = [UIView new];
        self.topView.backgroundColor = RGBA(0, 0, 0, 0.4);
        self.topView.layer.cornerRadius = 2;
        self.topView.layer.masksToBounds = YES;
        [self.coveImageView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(16);
            make.height.mas_equalTo(24);
        }];

        UIImageView *liveImage = [UIImageView new];
        liveImage.image = CImage(@"icon_attention_live_bg");
        [self.topView addSubview:liveImage];
        [liveImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(48);
        }];

        UIImageView *accountImage = [UIImageView new];
        accountImage.image = CImage(@"icon_attention_live_account");
        [self.topView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(liveImage.mas_right).offset(5);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(14);
        }];

        self.numLabel = [UILabel initWithFrame:CGRectZero size:12 color:TextBrightestColor alignment:0 lines:1];
        [self.topView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(accountImage.mas_right).offset(5);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(14);
            make.right.mas_equalTo(-5);
        }];

        //底部线
        self.lineLabel = [UILabel creatLabelLine:CGRectZero backgroundColor:LineNormalColor];
        [self.contentView addSubview:self.lineLabel];
        self.lineLabel.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1).topSpaceToView(self.coveImageView ,20);
        
        UIView * bottomView = [[UIView alloc] init];
        [self.coveImageView addSubview:bottomView];
        bottomView.sd_layout.leftSpaceToView(self.coveImageView, 0).bottomSpaceToView(self.coveImageView, 0).rightSpaceToView(self.coveImageView, 0).heightIs(54);
        
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.opacity = .24;
        gl.frame = CGRectMake(0,0,SCREEN_WIDTH-32,54);
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [bottomView.layer insertSublayer:gl atIndex:0];
       
        UILabel *currentLiveLabel = [UILabel initWithFrame:CGRectZero size:14 color:TextBrightestColor alignment:1 lines:1];
        currentLiveLabel.backgroundColor = [UIColor clearColor];
        currentLiveLabel.font = CBFont(14);
        currentLiveLabel.text = @"点击观看直播";
        [bottomView addSubview:currentLiveLabel];
        currentLiveLabel.sd_layout.leftSpaceToView(bottomView, 0).bottomSpaceToView(bottomView, 0).rightSpaceToView(bottomView, 0).heightIs(54);
       
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageClick)];
        tap1.numberOfTapsRequired = 1;
        tap1.numberOfTouchesRequired = 1;
        self.headImageView.userInteractionEnabled = YES;
        [self.headImageView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageClick)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        self.nickNameLabel.userInteractionEnabled = YES;
        [self.nickNameLabel addGestureRecognizer:tap2];
    }
    return self;
}

-(void)setModel:(BXSLLiveRoom *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    self.nickNameLabel.text = model.nickname;
    [_coveImageView yy_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholder:CImage(@"video-placeholder")];
   
    
    self.titleLb.attributedText = [[self vodioDescribeAttri:model] objectForKey:@"attri"];
    self.titleLb.sd_layout.heightIs([[[self vodioDescribeAttri:model] objectForKey:@"height"] floatValue]);
   
    
    self.numLabel.text = [NSString stringWithFormat:@"%@",model.audience];
    [self setupAutoHeightWithBottomView:self.lineLabel bottomMargin:0];
}

- (NSDictionary *)vodioDescribeAttri:(BXSLLiveRoom *)video {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.title];
    attri.yy_font = CFont(16);
    attri.yy_color = MainTitleColor;
    attri.yy_lineSpacing = 5;
    return @{@"attri":attri,@"height":@([self getAttributedTextHeightWithAttributedText:attri width:__kWidth-32])};
    
}
- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}


-(void)iconImageClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_model.user_id,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:_model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}






@end


//
//  BXAttentionVideoCell.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionVideoCell.h"
#import <Lottie/Lottie.h>
//#import "SharePopViewManager.h"
//#import "BXTopicDetailVC.h"
//#import "BXPersonHomeVC.h"
//#import <YYAnimatedImageView.h>
#import <YYImage/YYImage.h>
//#import "BXVideoPlayVC.h"
#import "BXAttentionCellCommentView.h"
#import "BXLikeView.h"
#import "HMovieModel+DescribeAttri.h"
#import <YYText/YYText.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "NewHttpRequestPort.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLUtilities/SLUtilities.h"
#import <SDWebImage/SDWebImage.h>
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"
#import "BXTopicModel.h"
#import "BXLiveUser.h"
#import <YYCategories/YYCategories.h>


@interface BXAttentionVideoCell()<CAAnimationDelegate,DSAttentionCellCommentViewDelegate>
@property (nonatomic ,strong) UIImageView *headImageView;//头像
@property (nonatomic ,strong) UILabel *nickNameLabel;//昵称
@property (nonatomic ,strong) UILabel * timeLabel;//时间
@property (strong, nonatomic) BXLikeView *likeView;
@property (nonatomic ,strong) UIImageView *coveImageView;//封面
@property (nonatomic ,strong) YYLabel *titleLb;        //标题
@property (nonatomic ,strong) UIButton *likeBtn;//点赞
@property (nonatomic ,strong) UIImageView *musicIcon;
@property (nonatomic ,strong) BXAttentionCellCommentView *commentView;
@property (nonatomic ,strong) UIButton *commentBtn;//评论
@property (nonatomic ,strong) UIButton *moreBtn;   //更多
@property (nonatomic ,strong) UILabel *lineLabel;
@property (nonatomic ,weak) id<BXAttentionVideoCelllDelegate> delegate;
@end

@implementation BXAttentionVideoCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    BXAttentionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXAttentionVideoCell"];
    
    if (cell == nil) {
        cell = [[BXAttentionVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXAttentionVideoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    [_likeView  resetView];
    [_musicName resetView];
    _model = nil;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //头像
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        
        
        //关注按钮
        self.focusButton = [[UIButton alloc] init];
        [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:TextBrightestColor forState:UIControlStateNormal];
        self.focusButton.titleLabel.font = CFont(12);
        self.focusButton.clipsToBounds = YES;
        [self.focusButton setImage:[UIImage imageNamed:@"icon_add_little"] forState:UIControlStateNormal];
        [self.focusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
        self.focusButton.layer.backgroundColor = normalColors.CGColor;
        self.focusButton.layer.cornerRadius = 4;
        [self.focusButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapAction)]];
        
        //昵称
        self.nickNameLabel = [UILabel initWithFrame:CGRectZero size:16 color:MainTitleColor alignment:0 lines:1];
        self.nickNameLabel.font = CBFont(16);
        
        //内容
        self.titleLb = [[YYLabel alloc] init];
        self.titleLb.numberOfLines = 0;
        
        self.backView = [UIView new];
        
        //封面
        self.coveImageView = [UIImageView new];
        self.coveImageView.userInteractionEnabled = YES;
        self.coveImageView.tag = 101;
        self.coveImageView.userInteractionEnabled = YES;
        self.coveImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.coveImageView addGestureRecognizer:tap];

        
        //播放按钮
        self.playBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(12) Color:TextBrightestColor Image:CImage(@"icon_music_pause") Target:self action:@selector(playVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.playBtn setImage:CImage(@"icon_music_pause") forState:BtnNormal];
        [self.playBtn setImage:CImage(@"icon_music_play") forState:BtnSelected];
        //滚动文字
        self.musicIcon = [[UIImageView alloc]init];
        self.musicIcon.contentMode = UIViewContentModeCenter;
        self.musicIcon.image = [UIImage imageNamed:@"icon_home_musie"];
       
        self.musicName = [[BXTextScrollView alloc]init];
        self.musicName.font = CBFont(15);
       
   
        
        //时间
        self.timeLabel = [UILabel initWithFrame:CGRectZero size:12 color:MinorColor alignment:0 lines:1];

        //点赞
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeBtn setBackgroundColor:[UIColor clearColor]];
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_dianzan_default"] forState:BtnNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_dianzan_selected"] forState:BtnSelected];
        [self.likeBtn setTitleColor:MainTitleColor forState:UIControlStateNormal];
        self.likeBtn.titleLabel.font = CFont(12);
        self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.likeBtn addTarget:self action:@selector(clickZanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //评论
        self.commentBtn = [UIButton buttonWithFrame:CGRectZero Title:@"评论" Font:CFont(12) Color:MainTitleColor Image:CImage(@"icon_attention_comment") Target:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
       
        //更多
        self.moreBtn = [UIButton buttonWithFrame:CGRectZero Title:@"更多" Font:CFont(12) Color:MainTitleColor Image:CImage(@"icon_attention_more") Target:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.commentView = [BXAttentionCellCommentView new];
        self.commentView.delegate = self;
        self.commentView.sd_cornerRadius = @(4);
        self.lineLabel = [UILabel creatLabelLine:CGRectZero backgroundColor:LineNormalColor];
       
        [self.contentView sd_addSubviews:@[self.headImageView,self.focusButton,self.nickNameLabel,self.titleLb,self.backView,self.likeBtn,self.commentBtn,self.moreBtn,self.timeLabel,self.commentView,self.lineLabel]];
        self.headImageView.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.contentView, 16).widthIs(40).heightEqualToWidth();
         self.headImageView.sd_cornerRadius = @(20);
        self.focusButton.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.headImageView).widthIs(60).heightIs(26);
        
    self.nickNameLabel.sd_layout.leftSpaceToView(self.headImageView, 8).centerYEqualToView(self.headImageView).heightIs(20).rightSpaceToView(self.focusButton, 10);
       
      self.titleLb.sd_layout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).topSpaceToView(self.headImageView, 14).heightIs(50);
        
        self.backView.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.titleLb, 12);
            self.backView.sd_cornerRadius = @(5);
       
        
   
        self.likeBtn.sd_layout.rightSpaceToView(self.contentView, 16).topSpaceToView(self.backView, 4).heightIs(45).widthIs(50);
       self.likeBtn.imageView.sd_layout.leftSpaceToView(self.likeBtn, 0).widthIs(25).heightIs(25).centerYEqualToView(self.likeBtn); self.likeBtn.titleLabel.sd_layout.leftSpaceToView(self.likeBtn.imageView, 5).centerYEqualToView(self.likeBtn).heightIs(19).rightSpaceToView(self.likeBtn, 0);
        
        
        
        self.commentBtn.sd_layout.rightSpaceToView(self.likeBtn, 16).topSpaceToView(self.backView, 4).heightIs(45).widthIs(55);
        self.commentBtn.imageView.sd_layout.leftSpaceToView(self.commentBtn, 0).widthIs(25).heightIs(25).centerYEqualToView(self.commentBtn); self.commentBtn.titleLabel.sd_layout.leftSpaceToView(self.commentBtn.imageView, 5).centerYEqualToView(self.commentBtn).heightIs(19).rightSpaceToView(self.commentBtn, 0);
        
        
        self.moreBtn.sd_layout.rightSpaceToView(self.commentBtn, 16).topSpaceToView(self.backView, 4).heightIs(45).widthIs(55);
        self.moreBtn.imageView.sd_layout.leftSpaceToView(self.moreBtn, 0).widthIs(25).heightIs(25).centerYEqualToView(self.moreBtn).offset(-1); self.moreBtn.titleLabel.sd_layout.leftSpaceToView(self.moreBtn.imageView, 5).centerYEqualToView(self.moreBtn).heightIs(19).rightSpaceToView(self.moreBtn, 0);
        
       
      
        
        self.timeLabel.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.likeBtn).heightIs(14).rightSpaceToView(self.moreBtn, 10);
        
        self.commentView.sd_layout
        .leftSpaceToView(self.contentView,16)
        .rightSpaceToView(self.contentView, 16)
        .topSpaceToView(self.likeBtn, 3); //
        
        self.lineLabel.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1).topSpaceToView(self.commentView ,12);
        
        [self.backView sd_addSubviews:@[self.coveImageView,self.musicIcon,self.musicName,self.playBtn]];
        
        self.coveImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.playBtn.sd_layout.rightSpaceToView(self.backView, 8).bottomSpaceToView(self.backView, 8).widthIs(25).heightIs(25);
        
    self.musicIcon.sd_layout.widthIs(30).heightIs(18).leftSpaceToView(self.backView, 2).centerYEqualToView(self.playBtn);
        
        self.musicName.sd_layout.leftSpaceToView(_musicIcon, 1).centerYEqualToView(_musicIcon).heightIs(24).rightSpaceToView(self.playBtn, 8);
        
        
        
        
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
#pragma 播放
-(void)playVideoBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(didClickPlayButtonInCell:playButton:)]) {
        [self.delegate didClickPlayButtonInCell:self playButton:btn];
    }
}

#pragma 点赞
-(void)clickZanBtnClick:(UIButton *)btn{
    dispatch_group_t group = nil;
    LOTAnimationView *animationView = nil;
    if (!btn.selected) {
        group = dispatch_group_create();
        dispatch_group_enter(group);
        
        animationView = [LOTAnimationView animationNamed:@"icon_attention_like_new"];
        [btn addSubview:animationView];
        animationView.sd_layout.widthIs(35).heightEqualToWidth().centerXEqualToView(btn.imageView).offset(-0.5).centerYEqualToView(btn.imageView);
        animationView.completionBlock = ^(BOOL animationFinished) {
            dispatch_group_leave(group);
            
        };
        
        [self.likeBtn setImage:nil forState:BtnNormal];
        [self.likeBtn setImage:nil forState:BtnSelected];
        [animationView play];
        
    }
    
    [self likeCommentWithGroup:group];
    if (group) {
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (animationView) {
                [btn setImage:[UIImage imageNamed:@"icon_dianzan_default"] forState:BtnNormal];
                [btn setImage:[UIImage imageNamed:@"icon_dianzan_selected"] forState:BtnSelected];
                [animationView removeFromSuperview];
            }
        });
    }
}

- (void)likeCommentWithGroup:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    WS(weakSelf);
    [[NewHttpRequestPort sharedNewHttpRequestPort] Filmsupport:@{@"id":_model.movieID,@"status":_model.is_zan} Success:^(id responseObject) {
        if (group) {
            dispatch_group_leave(group);
        }
        if([responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                weakSelf.model.is_zan = [NSString stringWithFormat:@"%d",![weakSelf.model.is_zan boolValue]];
                weakSelf.model.zan_sum = [NSString stringWithFormat:@"%@",dataDic[@"total"]];
                weakSelf.likeBtn.selected = [weakSelf.model.is_zan integerValue];
                [weakSelf.likeBtn setTitle:[NSString stringWithFormat:@"%@",weakSelf.model.zan_sum] forState:UIControlStateNormal];
                if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
                    [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
                }
            }
        }
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
    }];
}
#pragma 评论
-(void)commentBtnClick{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:type:)]) {
        [self.delegate didClickcCommentButtonInCell:self type:0];
    }
}
#pragma 更多
-(void)moreBtnClick{
//    [SharePopViewManager shareWithVideoId:_model.movieID user_Id:_model.user_id likeNum:_model.zan_sum is_zan:_model.is_zan is_collect:_model.is_collect is_follow:_model.is_follow vc:self.viewController type:1];
}

-(void)onTapAction{
    [self showFollowedAnimation];
    [[NewHttpRequestPort sharedNewHttpRequestPort] Followfollow:@{@"user_id":_model.user_id} Success:^(id responseObject) {
        if ([responseObject[@"code"]intValue] == 0) {
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]] isEqualToString:@"1"]) {
                self.model.is_follow = @"1";
                self.focusButton.hidden = YES;
                [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
            }else{
                self.model.is_follow = @"0";
                [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kSendChangeStatusNotification object:nil userInfo:@{@"user_id":self.model.user_id,@"status":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]]}];
        }
    } Failure:^(NSError *error) {
        
    }];
}


-(void)setModel:(BXHMovieModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    self.nickNameLabel.text = model.nickname;
    self.timeLabel.text = model.publish_time;
    [_coveImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:CImage(@"video-placeholder")];
    [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:model.cover_url]];
    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", model.bgMusic.title, model.nickname]];
    [_musicName setTextColor:[UIColor whiteColor]];
    [_musicName startAnimation];
    self.titleLb.attributedText = [self getVideoDescribeAttri:model];
    if (self.titleLb.text.length) {
        
    }else{
        self.titleLb.sd_layout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).topSpaceToView(self.headImageView, 14).heightIs(50);
        
        self.backView.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.titleLb, 12);
        self.backView.sd_cornerRadius = @(5);
    }
    
    
    self.titleLb.sd_layout.heightIs(model.describeHeight);
    self.likeBtn.selected = [model.is_zan integerValue];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",model.zan_sum] forState:BtnNormal];
    
    CGFloat w1 = [BXCalculate calculateRowWidth:self.likeBtn.currentTitle Font:CFont(16)];
    CGFloat width = 0;
    if (32 + w1 < 50) {
        width = 50;
    }else{
        width = 32 + w1;
    }
    self.likeBtn.sd_layout.widthIs(width);
    
    CGFloat videoWidth = SCREEN_WIDTH - 32;
    CGFloat videoHeight = videoWidth;
    if ([model.height integerValue] && [model.width integerValue]) {
        CGFloat rate = [model getRate];
        if (rate > 1) {
            if(iPhoneX) {
                videoWidth *= .8;
            }
            videoHeight = videoWidth * 4 / 3;
        } else {
            videoHeight = videoWidth *rate;
        }
    }
    self.backView.sd_layout.widthIs(videoWidth).heightIs(videoHeight);
    
    if ([model.is_follow integerValue]) {
        self.focusButton.hidden = YES;
    }else{
        self.focusButton.hidden = NO;
    }
    [_commentView setupWithLikeItemsCount:[model.zan_sum integerValue] commentCount:[model.comment_sum integerValue] commentItemsArray:model.commentlist];
    [self setupAutoHeightWithBottomView:_commentView bottomMargin:12];
    
    if (model.isPlay) {
        [self.musicName resume];
        self.playBtn.selected = NO;
    }else{
        [self.musicName pause];
        self.playBtn.selected = YES;
    }
}

- (void)showFollowedAnimation {
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = 0.25;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    CALayer *layer = _focusButton.layer;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0 , _focusButton.frame.size.width, _focusButton.frame.size.height )] CGPath];
    layer.mask = maskLayer;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(layer.frame.origin.x + layer.frame.size.width*0.5);
    positionAnimation.toValue = @(layer.frame.origin.x + layer.frame.size.width);
    
    CABasicAnimation *sizeAnimation = [CABasicAnimation animation];
    sizeAnimation.keyPath = @"bounds.size.width";
    sizeAnimation.fromValue = @(layer.frame.size.width);
    sizeAnimation.toValue = @(0);
    [animationGroup setAnimations:@[positionAnimation, sizeAnimation]];
    [layer addAnimation:animationGroup forKey:nil];
}

- (NSAttributedString *)getVideoDescribeAttri:(BXHMovieModel *)video {
    if (!video.describeAttri) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.describe];
        attri.yy_font = CFont(16);
        attri.yy_color = MainTitleColor;
        attri.yy_lineSpacing = 5;
        
        WS(ws);
        for (BXTopicModel *topic in video.topics) {
            NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.title];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.describe subText:topicTitle];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], topicTitle.length);
                [attri yy_setFont:CBFont(16) range:range];
                [attri yy_setTextHighlightRange:range color:ContentHighlightColor backgroundColor:[UIColor colorWithWhite:0.631 alpha:1.000] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws topicDetail:topic.topic_id title:topicTitle];
                }];
            }
        }
        
        for (BXLiveUser *liveUser in video.friends) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:video.describe subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                [attri yy_setFont:CBFont(16) range:range];
                [attri yy_setTextHighlightRange:range color:ContentHighlightColor backgroundColor:[UIColor colorWithWhite:0.631 alpha:1.000] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        video.describeAttri = attri;
        video.describeHeight = [self getAttributedTextHeightWithAttributedText:attri width:__kWidth-32];
    }
    return video.describeAttri;
}

- (void)topicDetail:(NSString *)topicId title:(NSString *)title {
    if ([BXLiveUser isLogin]) {
//        BXTopicDetailVC *vc = [[BXTopicDetailVC alloc]init];
//        vc.topicId = topicId;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.viewController.navigationController];
    }
}

- (void)userDetail:(NSString *)userId {
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":self.viewController.navigationController}];
//    [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:self.viewController.navigationController handle:nil];
}
-(void)iconImageClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_model.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
//    [BXPersonHomeVC toPersonHomeWithUserId:_model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}

#pragma - mark tool
- (NSMutableArray *)getRangeLocationsWithText:( NSString *)text subText:(NSString *)subText {
    NSMutableArray *rangeLocations=[NSMutableArray new];
    NSArray *array=[text componentsSeparatedByString:subText];
    NSInteger d = 0;
    for (NSInteger i = 0; i<array.count-1; i++) {
        NSString *string = array[i];
        NSNumber *number = @(d += string.length);
        d += subText.length;
        [rangeLocations addObject:number];
    }
    return rangeLocations;
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}

#pragma BXAttentionVideoCelllDelegate
-(void)setDelegate:(id<BXAttentionVideoCelllDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

#pragma 查看更多评论
- (void)didClickMoreButtonInView{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:type:)]) {
        [self.delegate didClickcCommentButtonInCell:self type:0];
    }
}
#pragma 添加评论
- (void)didClickcCommentButtonInView{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:type:)]) {
        [self.delegate didClickcCommentButtonInCell:self type:1];
    }
}
#pragma 回复评论
-(void)didClickSelfInView:(BXCommentModel *)model{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:model:)]) {
        [self.delegate didClickcCommentButtonInCell:self model:model];
    }
}
#pragma 点击封面
-(void)tapClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickCoverImageInCell:)]) {
        [self.delegate didClickCoverImageInCell:self];
    }
}


@end



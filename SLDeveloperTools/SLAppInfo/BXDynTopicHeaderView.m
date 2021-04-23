//
//  BXDynTopicHeaderView.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicHeaderView.h"
#import "HttpMakeFriendRequest.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface BXDynTopicHeaderView()
@property(nonatomic, strong)UILabel *topicLabel;
@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)UILabel *TopicNumLabel;


@property(nonatomic, strong)UIView *hazyView;
@end
@implementation BXDynTopicHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    _coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _coverImageView.contentMode=UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds=YES;
//    _coverImageView.backgroundColor = [UIColor randomColor];
    [self addSubview:_coverImageView];
//    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
    
    _hazyView = [[UIView alloc]initWithFrame:self.bounds];
    _hazyView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [self addSubview:_hazyView];
    
    _topicLabel = [[UILabel alloc]init];
    _topicLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    _topicLabel.textColor = [UIColor whiteColor];
    _topicLabel.textAlignment = 0;
    [self addSubview:_topicLabel];
    [_topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(27);
    }];
    
    _attImageView = [[UIImageView alloc]init];
//    _attImageView.backgroundColor = [UIColor randomColor];
//    _attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attent"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AttenAct)];
    [_attImageView addGestureRecognizer:tap];
    _attImageView.userInteractionEnabled = YES;
    [self addSubview:_attImageView];
    [_attImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.topicLabel.mas_bottom);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(32);
    }];
    
    _TopicNumLabel = [[UILabel alloc]init];
    _TopicNumLabel.textColor = [UIColor whiteColor];
    _TopicNumLabel.font = [UIFont systemFontOfSize:12];
    _TopicNumLabel.textAlignment = 0;
    [self addSubview:_TopicNumLabel];
    [_TopicNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topicLabel);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    UIView *bottomview = [[UIView alloc]init];
    bottomview.backgroundColor = [UIColor whiteColor];
    bottomview.layer.masksToBounds = YES;
    bottomview.layer.cornerRadius = 10;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.coverImage.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bottomview.bounds;
//    maskLayer.path = maskPath.CGPath;
//    bottomview.layer.mask = maskLayer;
    [self addSubview:bottomview];
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
}
- (void)setModel:(BXDynTopicModel *)model{
    _model = model;
    _topicLabel.text = model.topic_name;
    _TopicNumLabel.text = [NSString stringWithFormat:@"%@条动态",model.hot];
    if (!IsNilString(model.avatar)) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"video-placeholder")];
    }
    else if (!IsNilString(model.img)){
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:CImage(@"video-placeholder")];
    }
    _attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attent"];
    _attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attented"];
    if ([[NSString stringWithFormat:@"%@",model.myfollowed] isEqualToString:@"1"]) {
        self.attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attented"];
    }
    else {
        self.attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attent"];
    }
    _TopicNumLabel.text = [NSString stringWithFormat:@"%@条动态", model.dynamic];
    
}

-(void)AttenAct{
    if (self.AttentClickTopic) {
        self.AttentClickTopic();
        return;
    }
    WS(weakSelf);
    [HttpMakeFriendRequest FollowTopicWithtopic_id:self.model.topic_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            if ([[NSString stringWithFormat:@"%@",weakSelf.model.myfollowed] isEqualToString:@"1"]) {
                weakSelf.model.myfollowed = @"0";
                weakSelf.attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attent"];
            }else{
                weakSelf.model.myfollowed = @"1";
                weakSelf.attImageView.image = [UIImage imageNamed:@"icon_dyn_cirlce_attented"];
            }
      
            if (weakSelf.DidClickTopic) {
                weakSelf.DidClickTopic(weakSelf.model);
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];

}
- (void)scrollViewDidScroll:(CGFloat)offsetY {
    // topImageView下拉放大

    if (offsetY<0) {
        self.coverImageView.frame = CGRectMake( offsetY / 2.0, offsetY, self.width - offsetY, self.height- offsetY);
         self.hazyView.frame = CGRectMake( offsetY / 2.0, offsetY, self.width - offsetY, self.height- offsetY);
    }
    else{
        self.coverImageView.frame = CGRectMake( 0, 0, self.width, self.height);
        self.hazyView.frame = CGRectMake( 0, 0, self.width, self.height);
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

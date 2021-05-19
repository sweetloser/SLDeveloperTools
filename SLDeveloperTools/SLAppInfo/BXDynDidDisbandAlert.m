//
//  BXDynDidDisbandAlert.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynDidDisbandAlert.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>

@interface BXDynDidDisbandAlert()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)UILabel *circleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UILabel *dayLabel;
@property(nonatomic, strong)UILabel *peopleLabel;
@end

@implementation BXDynDidDisbandAlert

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.height.mas_equalTo(336);
            make.left.offset(__ScaleWidth(27));
        }];
        self.contentView.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        _contentView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _contentView.alpha = 0;
        [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self->_contentView.alpha = 1.0;
        } completion:nil];
        
        
        _backImageView = [[UIImageView alloc]init];
        _backImageView.contentMode=UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds=YES;
        [self.contentView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, self.backImageView.size.width, self.backImageView.size.height);
//        effectview.backgroundColor = [UIColor whiteColor];
//        effectview.alpha = 0.7;
        [_backImageView addSubview:effectview];
        
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(30);
            make.width.height.mas_equalTo(84);
        }];
        
        _circleLabel = [[UILabel alloc]init];
        _circleLabel.textColor = [UIColor whiteColor];
        _circleLabel.textAlignment = 1;
        _circleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        [self.contentView addSubview:_circleLabel];
        [_circleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(60);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
        }];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = 1;
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.circleLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(55);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-55);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"该社区已解散";
        titleLabel.textAlignment = 1;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = sl_textSubColors;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backImageView.mas_bottom).offset(25);
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
            make.height.mas_equalTo(22);
        }];
        
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.textAlignment = 1;
        [self.contentView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(50);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(25);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(17);
        }];
        
        UILabel *dayCircleLabel = [[UILabel alloc]init];
        dayCircleLabel.font = [UIFont systemFontOfSize:12];
        dayCircleLabel.text = @"圈子成立";
        dayCircleLabel.textAlignment = 1;
        dayCircleLabel.textColor = UIColorHex(#B2B2B2);
        [self.contentView addSubview:dayCircleLabel];
        [dayCircleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(50);
            make.top.mas_equalTo(self.dayLabel.mas_bottom).offset(3);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(17);
        }];
        
        _peopleLabel = [[UILabel alloc]init];
        _peopleLabel.textAlignment = 1;
        [self.contentView addSubview:_peopleLabel];
        [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(25);
            make.width.mas_equalTo(48);
              make.height.mas_equalTo(17);
          }];
          
          UILabel *peopelCircleLabel = [[UILabel alloc]init];
          peopelCircleLabel.font = [UIFont systemFontOfSize:12];
          peopelCircleLabel.text = @"圈子成员";
          peopelCircleLabel.textAlignment = 1;
          peopelCircleLabel.textColor = UIColorHex(#B2B2B2);
          [self.contentView addSubview:peopelCircleLabel];
          [peopelCircleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
              make.top.mas_equalTo(self.peopleLabel.mas_bottom).offset(3);
              make.width.mas_equalTo(60);
              make.height.mas_equalTo(17);
          }];

//        dyn_issue_Del_addPic
        
    
//        UIButton *DelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [DelButton setImage:CImage(@"dyn_issue_Del_addPic") forState:UIControlStateNormal];
//
//        [DelButton addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
//        [self addSubview:DelButton];
//        [DelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.contentView.mas_bottom).offset(25);
//            make.centerX.mas_equalTo(self.contentView.mas_centerX);
//            make.width.height.mas_equalTo(50);
//        }];
        
        
        UIImageView *delImage = [[UIImageView alloc]init];
        delImage.image = CImage(@"icon_dyn_cirlce_dismiss");
        UITapGestureRecognizer *deltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnOnClick:)];
        delImage.userInteractionEnabled = YES;
        [delImage addGestureRecognizer:deltap];
        [self addSubview:delImage];
        [delImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(25);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.width.height.mas_equalTo(30);
        }];

        
        
        
    }
    return self;
}
-(void)setModel:(BXDynCircleModel *)model{
    NSString *circle_background_img = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",model.circle_background_img];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:circle_background_img] placeholderImage:CImage(@"video-placeholder")];
    NSString *circle_cover_img = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.circle_cover_img];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:circle_cover_img] placeholderImage:CImage(@"video-placeholder")];
    _circleLabel.text = model.circle_name;
    _contentLabel.text = model.circle_describe;
    _dayLabel.text = [NSString stringWithFormat:@"%@天", model.founded];
    NSMutableAttributedString *dayfollowAttri = [self attriWithString:_dayLabel.text];
    self.dayLabel.attributedText = dayfollowAttri ;
    
    _peopleLabel.text =[NSString stringWithFormat:@"%@人", model.follow];
    NSMutableAttributedString *followAttri = [self attriWithString:_peopleLabel.text];
    self.peopleLabel.attributedText = followAttri ;
}
-(void)tap:(UITapGestureRecognizer *)tap{
//    CGPoint point = [tap locationInView:self];
//    if (CGRectContainsPoint(self.contentView.frame, point)) {
//        NSLog(@"范围内");
//        return;
//    }
//    [self hiddenView];
}

-(void)btnOnClick:(UIButton *)btn{
//    if (btn.tag == 100) {
//
//    }else{
        if (self.DidClickBlock) {
            self.DidClickBlock();
        }
//    }
    [self hiddenView];
}
- (NSMutableAttributedString *)attriWithString:(NSString *)string{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attrisDic1 = @{
                                NSForegroundColorAttributeName:sl_FF2DtextColors,
                                NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18]
                                };
    [AttributedStr addAttributes:attrisDic1 range:NSMakeRange(0, [string length]-1)];
    NSDictionary *attrisDic2 = @{
                                NSForegroundColorAttributeName:sl_textSubColors,
                                NSFontAttributeName:CFont(12)
                                };
    [AttributedStr addAttributes:attrisDic2 range:NSMakeRange([string length]-1, 1)];
    return AttributedStr;
}
-(void)showWithView:(UIView *)superView{
    self.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

-(void)hiddenView{
    self.hidden = YES;
    [self.contentView removeAllSubViews];
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self removeFromSuperview];
}


@end

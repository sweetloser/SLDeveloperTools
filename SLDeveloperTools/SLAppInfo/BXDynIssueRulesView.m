//
//  BXDynIssueRulesView.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynIssueRulesView.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

@implementation BXDynIssueRulesView
-(instancetype)init{
    self = [super init];
    if (self) {
        _image1 = [UIImageView new];
        _image1.image = [UIImage imageNamed:@"dyn_issue_QuanXian_all"];
        [self addSubview:_image1];
        [_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(13);
            make.width.height.mas_equalTo(12);
        }];
        _label1 = [[UILabel alloc]init];
        _label1.textAlignment = 0;
        _label1.textColor = UIColorHex(#EF6856);
//        _label1.textColor = [UIColor blackColor];
        _label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _label1.text = @"所有人可见";
        _label1.tag = 0;
        UITapGestureRecognizer *tap1  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Act:)];
        [_label1 addGestureRecognizer:tap1];
        _label1.userInteractionEnabled = YES;
        [self addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_image1.mas_right).offset(10);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.height.mas_equalTo(17);
            make.right.mas_equalTo(self.mas_right).offset(12);
        }];
        
        
        _image2 = [UIImageView new];
        _image2.image = [UIImage imageNamed:@"dyn_issue_QuanXian_friend_gray"];
        [self addSubview:_image2];
        [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(_image1.mas_bottom).offset(20);
            make.width.height.mas_equalTo(12);
        }];
          _label2 = [[UILabel alloc]init];
          _label2.textAlignment = 0;
//          _label2.textColor = UIColorHex(#8C8C8C);
          _label2.textColor = [UIColor blackColor];
          _label2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
          _label2.text = @"仅好友可见";
        _label2.tag = 1;
        UITapGestureRecognizer *tap2  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Act:)];
        [_label2 addGestureRecognizer:tap2];
        _label2.userInteractionEnabled = YES;
          [self addSubview:_label2];
          [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(_image2.mas_right).offset(10);
              make.top.mas_equalTo(_label1.mas_bottom).offset(15);
              make.height.mas_equalTo(17);
              make.right.mas_equalTo(self.mas_right).offset(12);
          }];
        
        _image3 = [UIImageView new];
        _image3.image = [UIImage imageNamed:@"dyn_issue_QuanXian_stranger_gray"];
        [self addSubview:_image3];
        [_image3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(_image2.mas_bottom).offset(20);
            make.width.height.mas_equalTo(12);
        }];
        _label3 = [[UILabel alloc]init];
        _label3.textAlignment = 0;
        _label3.textColor =[UIColor blackColor];
        _label3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _label3.text = @"仅陌生人可见";
        _label3.tag = 2;
        UITapGestureRecognizer *tap3  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Act:)];
        [_label3 addGestureRecognizer:tap3];
        _label3.userInteractionEnabled = YES;
        [self addSubview:_label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_image3.mas_right).offset(10);
            make.top.mas_equalTo(_label2.mas_bottom).offset(15);
            make.height.mas_equalTo(17);
            make.right.mas_equalTo(self.mas_right).offset(12);
          }];
        
        _image4 = [UIImageView new];
        _image4.image = [UIImage imageNamed:@"dyn_issue_QuanXian_own_gray"];
        [self addSubview:_image4];
        [_image4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(_image3.mas_bottom).offset(20);
            make.width.height.mas_equalTo(12);
        }];
        _label4 = [[UILabel alloc]init];
        _label4.textAlignment = 0;
        _label4.textColor = [UIColor blackColor];
        _label4.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _label4.text = @"私密";
        _label4.tag = 3;
        UITapGestureRecognizer *tap4  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Act:)];
        [_label4 addGestureRecognizer:tap4];
        _label4.userInteractionEnabled = YES;
        [self addSubview:_label4];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_image4.mas_right).offset(10);
            make.top.mas_equalTo(_label3.mas_bottom).offset(15);
            make.height.mas_equalTo(17);
            make.right.mas_equalTo(self.mas_right).offset(12);
          }];
        
    }
    return self;
}
-(void)Act:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger flag = [tap.view tag];
    if (_ChooseRules) {
        self.ChooseRules(flag);
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

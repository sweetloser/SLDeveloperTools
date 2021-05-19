//
//  BXDynTopicDelItemCell.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicDelItemCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>

@interface BXDynTopicDelItemCell()

@end
@implementation BXDynTopicDelItemCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 19;
        self.backgroundColor = sl_subBGColors;
    }
    return self;
}
-(void)initView{
    _concentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _concentLabel.backgroundColor = sl_subBGColors;
    _concentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    _concentLabel.textColor = [UIColor blackColor];
    _concentLabel.layer.masksToBounds = YES;
    _concentLabel.userInteractionEnabled = YES;
    _concentLabel.layer.cornerRadius = 19;
//    _concentLabel.textAlignment = 0;
    [self.contentView addSubview:_concentLabel];
    [_concentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
//    icon_dyn_topic_2_delete
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:CImage(@"icon_dyn_topic_2_delete") forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(delItem) forControlEvents:UIControlEventTouchUpInside];
    [_concentLabel addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.concentLabel.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.concentLabel.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
}
-(void)delItem{
    if (self.DidDelIndex) {
        self.DidDelIndex();
    }
}
-(void)setTopicStr:(NSString *)topicStr{
    if ([_StrType isEqualToString:@"tag"]) {
        _concentLabel.text = [NSString stringWithFormat:@"   %@", topicStr];
    }else{
        _concentLabel.text = [NSString stringWithFormat:@"   #%@", topicStr];
    }
}
@end

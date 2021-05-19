//
//  BXDynTopicSearchCell.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicSearchCell.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"

@interface BXDynTopicSearchCell()
@property(nonatomic, strong)UILabel *concentLabel;
@end
@implementation BXDynTopicSearchCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    _concentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _concentLabel.backgroundColor = sl_subBGColors;
    _concentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    _concentLabel.textColor = [UIColor blackColor];
    _concentLabel.layer.masksToBounds = YES;
    _concentLabel.layer.cornerRadius = 19;
    _concentLabel.textAlignment = 1;
    [self.contentView addSubview:_concentLabel];
    [_concentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
}
-(void)setTopicStr:(NSString *)topicStr{
    if ([_StrType isEqualToString:@"tag"]) {
        _concentLabel.text = [NSString stringWithFormat:@" %@", topicStr];
    }else{
    _concentLabel.text = [NSString stringWithFormat:@"#%@", topicStr];
    }
}
@end

//
//  SLRuleDescriptionView.m
//  BXlive
//
//  Created by sweetloser on 2020/9/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLRuleDescriptionView.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>

@interface SLRuleDescriptionView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SLRuleDescriptionView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __ScaleWidth(272), __ScaleWidth(322))];
        self.contentView.center = CGPointMake(__kWidth / 2, __kHeight / 2);
        [self addSubview:self.contentView];
        
        self.contentView.backgroundColor = sl_BGColors;
        self.contentView.layer.cornerRadius = 12;
        self.contentView.layer.masksToBounds = YES;
        
        UILabel *l = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"规则说明" Font:SLBFont(__ScaleWidth(16)) TextColor:sl_textColors];
        l.textAlignment = 1;
        [self.contentView addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(22));
            make.top.mas_equalTo(__ScaleWidth(30));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        [btn sl_setTitleColor:sl_whiteTextColors];
        [btn setBackgroundImage:[UIImage imageWithColor:sl_normalColors] forState:BtnNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:sl_normalColors] forState:UIControlStateHighlighted];
        [btn setTitle:@"知道了" forState:BtnNormal];
        btn.titleLabel.font = SLBFont(16);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = __ScaleWidth(22);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(44));
            make.width.mas_equalTo(__ScaleWidth(228));
            make.bottom.mas_equalTo(__ScaleWidth(-19));
        }];
        [btn addTarget:self action:@selector(hiddenView) forControlEvents:BtnTouchUpInside];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(btn.mas_top).offset(__ScaleWidth(-19));
            make.top.equalTo(l.mas_bottom).offset(__ScaleWidth(20));
        }];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return self;
}

#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

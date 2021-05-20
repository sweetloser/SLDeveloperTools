//
//  DetailCommendNoPicTableViewCell.m
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailCommendNoPicTableViewCell.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"

@interface DetailCommendNoPicTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *headImage;
@property(nonatomic, strong)UILabel *headNameLabel;
@property(nonatomic, strong)UILabel *headTimeLabel;
@property(nonatomic, strong)UITableView *tableView;

@end
@implementation DetailCommendNoPicTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    _headImage = [[UIImageView alloc]init];
    _headImage.layer.cornerRadius = 19;
    _headImage.layer.masksToBounds = YES;
    
    _headNameLabel = [UILabel new];
    _headNameLabel.textColor = [UIColor blackColor];
    _headNameLabel.textAlignment = 0;
    _headNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    _headTimeLabel = [UILabel new];
    _headTimeLabel.textColor = sl_textSubColors;
    _headTimeLabel.font = [UIFont systemFontOfSize:12];
    
    UIImageView *more = [UIImageView new];
    more.image = [UIImage imageNamed:@"dyn_issue_more"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *piccell = @"morecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableView];
    
    
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

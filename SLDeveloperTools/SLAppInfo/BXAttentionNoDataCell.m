//
//  BXAttentionNoDataCell.m
//  BXlive
//
//  Created by bxlive on 2019/9/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionNoDataCell.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXAttentionNoDataCell()
@property (nonatomic ,strong) UIImageView *noDataView;//
@property (nonatomic ,strong) UILabel *titleLabel;//
@property (nonatomic ,strong) UILabel *descLabel;//

@end

@implementation BXAttentionNoDataCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    BXAttentionNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXAttentionNoDataCell"];
    
    if (cell == nil) {
        cell = [[BXAttentionNoDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXAttentionNoDataCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.noDataView = [UIImageView new];
       
        self.titleLabel = [UILabel initWithFrame:CGRectZero size:16 color:[UIColor blackColor] alignment:0 lines:1];
        
        self.descLabel = [UILabel initWithFrame:CGRectZero size:12 color:[UIColor blackColor] alignment:0 lines:1];
        
        [self.contentView sd_addSubviews:@[self.noDataView,self.titleLabel,self.descLabel]];
        
        self.noDataView.sd_layout.rightSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).widthIs(160).heightIs(107);
        
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).offset(-12).heightIs(16).rightSpaceToView(self.noDataView, 10);
        
        self.descLabel.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).offset(10).heightIs(12).rightSpaceToView(self.noDataView, 10);
        
        self.noDataView.image = CImage(@"icon_no_attention_people");
        self.titleLabel.text = @"暂无关注";
        self.descLabel.text = @"关注的人最新动态会出现在这里";
        
    }
    return self;
}


@end

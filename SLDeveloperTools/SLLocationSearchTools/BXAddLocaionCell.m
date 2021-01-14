//
//  BXAddLocaionCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAddLocaionCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXAddLocaionCell()

@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *addressLabel;
@property (nonatomic , strong) UILabel *distanceLabel;

@end

@implementation BXAddLocaionCell

+ (instancetype)cellWithTableView :(UITableView *)tableView{
    static NSString *cellIdentifier = @"BXAddLocaionCell";
    BXAddLocaionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXAddLocaionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.nameLabel = [UILabel initWithFrame:CGRectZero size:14 color:sl_textColors alignment:0 lines:1];
    self.nameLabel.font = SLBFont(14);
    self.addressLabel = [UILabel initWithFrame:CGRectZero size:12 color:sl_textSubColors alignment:0 lines:1];
    self.addressLabel.font = SLPFFont(12);
    self.distanceLabel = [UILabel initWithFrame:CGRectZero size:14 color:sl_textSubColors alignment:2 lines:1];
    self.distanceLabel.font = SLPFFont(14);
//    UILabel *lineLabel = [UILabel creatLabelLine:CGRectZero backgroundColor:UIColorHex(41474B)];
    [self.contentView sd_addSubviews:@[self.nameLabel,self.addressLabel,self.distanceLabel]];
    
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).heightIs(18).topSpaceToView(self.contentView, 11);
    self.distanceLabel.sd_layout.rightSpaceToView(self.contentView, __ScaleWidth(12)).heightIs(18).topSpaceToView(self.nameLabel, 4);
    [self.distanceLabel setSingleLineAutoResizeWithMaxWidth:120.f];
    
    
    self.addressLabel.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.nameLabel, 4).rightSpaceToView(self.distanceLabel, 10).heightIs(18);
    
//    lineLabel.sd_layout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).heightIs(1).bottomSpaceToView(self.contentView, 0);
    
    
}

-(void)setModel:(BXLocation *)model{
    _model = model;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%ld米",model.distance];
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    
    
    if (IsNilString(model.address)) {
        self.nameLabel.sd_resetLayout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView,16).heightIs(18).centerYEqualToView(self.contentView);
        self.addressLabel.hidden = YES;
        self.distanceLabel.hidden = YES;
        
        if (model.distance<=0) {
            self.distanceLabel.hidden = YES;
        }else{
            self.distanceLabel.hidden = NO;
        }
        
    }else{
        self.nameLabel.sd_resetLayout.leftSpaceToView(self.contentView, 16).rightSpaceToView(self.contentView, 16).heightIs(18).topSpaceToView(self.contentView, 11);
        self.addressLabel.hidden = NO;
        self.distanceLabel.hidden = NO;
        
        if (model.distance<=0) {
            self.distanceLabel.hidden = YES;
        }else{
            self.distanceLabel.hidden = NO;
        }
        
    }
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

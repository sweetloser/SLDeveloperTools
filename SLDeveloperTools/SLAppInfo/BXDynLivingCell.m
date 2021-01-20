//
//  BXDynLivingCell.m
//  BXlive
//
//  Created by mac on 2020/7/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynLivingCell.h"
//#import "HHMoviePlayVC.h"
#import "SLMoviePlayVCCoonfig.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "BXSLLiveRoom.h"
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>

@interface BXDynLivingCell()
@property(nonatomic, strong)UIView *backView;
@property(nonatomic, strong)UIButton *playbtn;
@property(nonatomic, strong)UIImageView *coveImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, strong)UILabel *SeeLable;
@property(nonatomic, strong)UILabel *ClickLable;
@property(nonatomic, strong)UIImageView *LiveImageView;
@end
@implementation BXDynLivingCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    
    self.backView = [[UIView alloc]init];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self.concenterBackview sd_addSubviews:@[self.backView]];
    self.backView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(175).bottomSpaceToView(self.concenterBackview, 0);
    
  
    //封面
    self.coveImageView = [UIImageView new];
    self.coveImageView.image = CImage(@"LC_Bgimg");
    self.coveImageView.userInteractionEnabled = YES;
    self.coveImageView.tag = 111;
    self.coveImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *covetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.coveImageView addGestureRecognizer:covetap];
    self.coveImageView.userInteractionEnabled = YES;
    covetap.numberOfTapsRequired = 1;
    covetap.numberOfTouchesRequired = 1;
    
    _SeeLable = [[UILabel alloc]init];
    _SeeLable.textAlignment = 1;
    _SeeLable.text = @"1213观看";
    _SeeLable.font = [UIFont systemFontOfSize:11];
    _SeeLable.textColor = [UIColor whiteColor];

    
    UIImageView *SeeimageView = [[UIImageView alloc]init];
    SeeimageView.image = [UIImage imageNamed:@"icon_dyn_Living_num"];
    
    
    _LiveImageView = [[UIImageView alloc]init];
    _LiveImageView.image = [UIImage imageNamed:@"icon_dyn_Living"];
    
    self.ClickLable = [[UILabel alloc]init];
    self.ClickLable.textAlignment = 1;
    self.ClickLable.text = @"点击观看直播";
    self.ClickLable.textColor = [UIColor whiteColor];
    self.ClickLable.font = [UIFont systemFontOfSize:12];
    

    [self.backView sd_addSubviews:@[self.coveImageView,self.LiveImageView, SeeimageView, self.ClickLable]];
    self.coveImageView.sd_layout.leftEqualToView(self.backView).topEqualToView(self.backView).rightEqualToView(self.backView).bottomSpaceToView(self.backView, 0);
    self.LiveImageView.sd_layout.leftSpaceToView(self.backView, 8).topSpaceToView(self.backView, 8).widthIs(54).heightIs(18);
    SeeimageView.sd_layout.leftSpaceToView(self.LiveImageView, 0).topEqualToView(self.LiveImageView).widthIs(62).heightIs(18);
    [SeeimageView sd_addSubviews:@[self.SeeLable]];
    self.SeeLable.sd_layout.leftEqualToView(SeeimageView).topEqualToView(SeeimageView).rightSpaceToView(SeeimageView, 0).heightIs(18);
    self.ClickLable.sd_layout.centerXEqualToView(self.backView).bottomSpaceToView(self.backView, 8).heightIs(20).widthIs(80);
}
-(void)updateCenterView{

    self.concenterBackview.sd_layout.heightIs(175);
    [_coveImageView sd_setImageWithURL:[NSURL URLWithString:self.model.msgdetailmodel.cover_url] placeholderImage:CImage(@"video-placeholder")];
    _SeeLable.text = [NSString stringWithFormat:@"%@观看", self.model.msgdetailmodel.systemplus[@"comfrom"]];
    NSInteger islive = [self.model.msgdetailmodel.systemplus[@"islive"] intValue];
    if (islive) {
        _LiveImageView.image = [UIImage imageNamed:@"icon_dyn_Living"];
        self.ClickLable.hidden = NO;
    }else{
        _LiveImageView.image = CImage(@"icon_dyn_Living_close");
        self.ClickLable.hidden = YES;
    }
    
    
//    id : 2843,
//    uid : 10004440,
//    islive : 1,
//    comfrom : 480

}

#pragma 点击观看直播
-(void)tapClick{

   
    BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc] init];
    liveRoom.room_id = self.model.msgdetailmodel.systemplus[@"id"];
    liveRoom.jump = [NSString stringWithFormat:@"bx://router.bxtv.com/enter_room?room_id=%@&from=dynamic",liveRoom.room_id];
    
    SLMoviePlayVCCoonfig *config = [SLMoviePlayVCCoonfig shareMovePlayConfig];
    config.loadUrl = nil;
    config.hasMore = NO;
//    [BXLocalAgreement loadUrl:liveRoom.jump fromVc:nil];

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

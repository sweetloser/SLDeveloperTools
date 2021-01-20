//
//  BXDynNewVideoTableViewCell.m
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNewVideoTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "BXInsetsLable.h"
@interface BXDynNewVideoTableViewCell()
@property(nonatomic, strong)UIImageView *coveImageView;
@end
@implementation BXDynNewVideoTableViewCell
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
    
    self.backView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightEqualToView(self.concenterBackview).bottomSpaceToView(self.concenterBackview, 0);
    
  
    //封面
    self.coveImageView = [UIImageView new];
    self.coveImageView.userInteractionEnabled = YES;
    self.coveImageView.tag = 101;
    self.coveImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *covetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    covetap.numberOfTapsRequired = 1;
//    covetap.numberOfTouchesRequired = 1;
    [self.coveImageView addGestureRecognizer:covetap];

    
    //播放
    //播放按钮
    _playBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(12) Color:TextBrightestColor Image:CImage(@"icon_music_pause") Target:self action:@selector(playVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playBtn setImage:CImage(@"icon_music_play") forState:BtnNormal];

   [self.backView sd_addSubviews:@[self.coveImageView, _playBtn]];
    self.coveImageView.sd_layout.leftEqualToView(self.backView).topEqualToView(self.backView).rightEqualToView(self.backView).bottomSpaceToView(self.backView, 0);
    _playBtn.sd_layout.centerYEqualToView(self.backView).centerXEqualToView(self.backView).heightIs(50).widthIs(50);

}
-(void)updateCenterView{

    
    [self.coveImageView sd_setImageWithURL:[NSURL URLWithString:self.model.msgdetailmodel.cover_url] placeholderImage:CImage(@"video-placeholder")];
    if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"3"] || [[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"20"]) {
        
        self.concenterBackview.sd_layout.heightIs(196);
        self.backView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(159).bottomEqualToView(self.concenterBackview);
    }
    if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"4"]) {
        
        self.concenterBackview.sd_layout.heightIs(152);
        self.backView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(256).bottomEqualToView(self.concenterBackview);
    }
    [_playBtn setImage:CImage(@"0") forState:BtnNormal];
    [_playBtn setImage:CImage(@"video_play") forState:BtnSelected];

    if (self.model.isPlay) {
        _playBtn.selected = NO;
    }else{
        _playBtn.selected = YES;
    }
    
    
//    if (self.playBtn.selected) {
//         self.playBtn.selected = NO;
//    }else{
//        self.playBtn.selected = YES;
//    }

}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
-(void)setPlayBtn:(UIButton *)playBtn{
    _playBtn.selected = playBtn.selected;
}

#pragma 播放
-(void)playVideoBtnClick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;

    if (self.DidClickPlay) {
        self.DidClickPlay(self.model, sender, self);
    }
}


#pragma 点击封面
-(void)tapClick{
    if (self.DidCover) {
        self.DidCover(self);
    }

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

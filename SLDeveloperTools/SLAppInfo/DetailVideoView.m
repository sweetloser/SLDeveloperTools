//
//  DetailVideoView.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailVideoView.h"
#import "BXInsetsLable.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>
#import "BXDynClickPlayVC.h"
//#import "BXVideoPlayVC.h"
#import "BXHMovieModel.h"
#import "BXDynTopicCircleVideoVC.h"
@interface DetailVideoView()
@property(nonatomic, strong)UIImageView *coveImageView;

@end
@implementation DetailVideoView
- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    
    self.backView = [[UIView alloc]init];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *covetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.backView addGestureRecognizer:covetap];
    self.backView.userInteractionEnabled = YES;
    
    [self.concenterBackview sd_addSubviews:@[self.backView]];
    
    self.backView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightEqualToView(self.concenterBackview).bottomSpaceToView(self.concenterBackview, 0);
    
  
    //封面
//    self.coveImageView = [UIImageView new];
//    self.coveImageView.backgroundColor = [UIColor randomColor];
//    self.coveImageView.userInteractionEnabled = YES;
//    self.coveImageView.tag = 101;
//    self.coveImageView.backgroundColor = [UIColor cyanColor];
//    self.coveImageView.contentMode = UIViewContentModeScaleAspectFill;




//   [self.backView sd_addSubviews:@[self.coveImageView]];
//    self.coveImageView.sd_layout.leftSpaceToView(self.backView, 0).topSpaceToView(self.backView,0).rightSpaceToView(self.backView,0).bottomSpaceToView(self.backView, 0);
    
        self.playerManager = [[ZFAVPlayerManager alloc] init];
//        self.player = [ZFPlayerController playerWithScrollView:self.tableview playerManager:self.playerManager containerViewTag:101];
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.backView];
        self.player.controlView = self.controlView;
        self.player.WWANAutoPlay = YES;
        self.player.shouldAutoPlay = YES;
    
        self.player.allowOrentitaionRotation = NO;
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesSingleTap;
        self.player.playerDisapperaPercent = 1;
    
    //播放
    //播放按钮
    self.playBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:CFont(12) Color:TextBrightestColor Image:CImage(@"icon_m") Target:self action:@selector(playVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setImage:CImage(@"icon_m") forState:BtnNormal];
    [self.playBtn setImage:CImage(@"video_play") forState:BtnSelected];
    
    [self.concenterBackview sd_addSubviews:@[self.playBtn]];
    self.playBtn.sd_layout.centerYEqualToView(self.concenterBackview).centerXEqualToView(self.backView).heightIs(50).widthIs(50);

}
-(void)updateCenterView{

    
//    [self.coveImageView sd_setImageWithURL:[NSURL URLWithString:self.model.msgdetailmodel.cover_url] placeholderImage:CImage(@"")];
    if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"3"] || [[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"20"]) {
        
        self.concenterBackview.sd_layout.heightIs(196);
        self.backView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(159).bottomEqualToView(self.concenterBackview);
    }
    if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.render_type] isEqualToString:@"4"]) {
        
        self.concenterBackview.sd_layout.heightIs(152);
        self.backView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(256).bottomEqualToView(self.concenterBackview);
    }
    
    self.player.assetURL = [NSURL URLWithString:self.model.msgdetailmodel.video];
    [self.player.currentPlayerManager play];
    
     @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self.player.currentPlayerManager replay];
    };

}
#pragma 播放
-(void)playVideoBtnClick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
//    if (sender.selected) {
//        self.model.isPlay = NO;
//        [self.player.currentPlayerManager pause];
//    }else{
//        self.model.isPlay = YES;
//        [self.player.currentPlayerManager play];
//    }
    if (self.DidPlaybtn) {
        self.DidPlaybtn(sender);
    }

}


#pragma 点击封面
-(void)tapClick{
    if (self.Didamp) {
        self.Didamp();
    }
//    BXDynClickPlayVC *vc = [[BXDynClickPlayVC alloc] initWithVideoModel:self.model];
//    vc.player = self.player;
//    self.controlView.progressView.hidden = YES;
//    @weakify(self);
//    [vc setDetailPlayCallback:^(BXDynamicModel * _Nonnull playVideoModel) {
//        @strongify(self);
//        self.controlView.progressView.hidden = NO;
//        [self.player addPlayerViewToCell];
//        if (playVideoModel.isPlay) {
//            [self playVideoBtnClick:self.playBtn];
////            [self playManagerModel:playVideoModel index:0 button:cell.playBtn cell:cell];
//            self.playBtn.selected = NO;
//            [self.player.currentPlayerManager play];
//        }else{
//
//            [self.player.currentPlayerManager pause];
//            self.playBtn.selected = YES;
//        }
//
//    }];
//    [self.viewController presentViewController:vc animated:YES completion:nil];
    if ([self.model.msgdetailmodel.render_type intValue] == 20) {
//        BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//        BXHMovieModel *moviemodel = [BXHMovieModel new];
//        moviemodel = self.model.msgdetailmodel.MovieModel;
//        NSMutableArray *movieArray = [NSMutableArray arrayWithObject:moviemodel];
//        vc.videos = movieArray;
//        vc.index = 0;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//        return;
    }
    
    BXDynTopicCircleVideoVC *bxvc = [[BXDynTopicCircleVideoVC alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithObject:self.model];
    bxvc.videos = array;
    bxvc.index = 0;
    [self.viewController.navigationController pushViewController:bxvc animated:YES];
}

- (BXNormalControllView *)controlView {
    if (!_controlView) {
        _controlView = [BXNormalControllView new];
    }
    return _controlView;
}
@end

//
//  BXMusicTableViewCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicTableViewCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYWebImage/YYWebImage.h>
#import "SLMusicToolsMacro.h"
@interface BXMusicTableViewCell()

@end

@implementation BXMusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMusic:) name:@"SelectMusicNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:kDidMusicPlayFinishNotification object:nil];

}

- (void)createUI{
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 56, 56)];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4;
    _playPauseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17, 22, 22)];
    _playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
    [_iconImageView addSubview:_playPauseImageView];
    _musicLabel = [UILabel initWithFrame:CGRectZero size:15 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1];
    _musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55, 19);
    _nameLabel = [UILabel initWithFrame:CGRectZero size:12 color:MinorColor alignment:NSTextAlignmentLeft lines:1];
    _nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55, 16);
    _collectBtn = [[UIButton alloc]init];
    _collectBtn.frame = CGRectMake(SCREEN_WIDTH-39, 23.5, 23, 21);
    [_collectBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _useBtn = [[BXGradientButton alloc]init];
    _useBtn.frame = CGRectMake(SCREEN_WIDTH, 18, 65, 32);
    [_useBtn setTitle:@"使用" forState:BtnNormal];
    _useBtn.titleLabel.font =  CFont(15);
    [_useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _useBtn.hidden = YES;
    [self.contentView sd_addSubviews:@[_iconImageView,_musicLabel,_nameLabel,_collectBtn,_useBtn]];
}

-(void)setModel:(BXMusicModel *)model{
    _model = model;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:model.image] placeholder:[UIImage imageNamed:@""]];
    self.musicLabel.text = model.title;
    self.nameLabel.text = model.singer;
    if ([model.is_collect integerValue]==0) {
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_music_collect_n"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"icon_music_collect_y"] forState:UIControlStateNormal];
    }
    if (model.isSelect==NO) {
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55, 16);
        self.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(SCREEN_WIDTH, 18, 65, 32);
    }else{
        self.useBtn.hidden = NO;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_pause"];
        self.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55-85, 19);
        self.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55-85, 16);
        self.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39-85, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(SCREEN_WIDTH-11-85+15, 18, 65, 32);
    }
}

- (void)selectMusic:(NSNotification *)notic{
    NSDictionary *info = notic.userInfo;
    BXMusicModel *themodel = info[@"model"];
    if (![themodel isEqual:_model]&&_model.isSelect==YES) {
        _model.isSelect = NO;
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55, 16);
        self.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(SCREEN_WIDTH, 18, 65, 32);
    }
}

- (void)playFinish:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    BXMusicModel *model = info[@"model"];
    if ([model isEqual:_model]&&_model.isSelect == YES) {
        _model.isSelect = NO;
        self.useBtn.hidden = YES;
        self.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
        self.musicLabel.frame = CGRectMake(80, 15, self.contentView.frame.size.width-80-55, 19);
        self.nameLabel.frame = CGRectMake(80, 38, self.contentView.frame.size.width-80-55, 16);
        self.collectBtn.frame = CGRectMake(self.contentView.frame.size.width-39, 23.5, 23, 21);
        self.useBtn.frame = CGRectMake(self.contentView.frame.size.width, 18, 65, 32);
    }
}

#pragma mark - 收藏
-(void)collectionBtnClick:(UIButton *)btn{
    if (self.musicCollectBlock) {
        self.musicCollectBlock();
    }
}
-(void)useBtnClick:(UIButton *)btn{
    if (self.musicUseBlock) {
        self.musicUseBlock();
    }
}

@end

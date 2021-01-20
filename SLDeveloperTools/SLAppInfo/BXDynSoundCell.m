//
//  BXDynSoundCell.m
//  BXlive
//
//  Created by mac on 2020/7/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynSoundCell.h"
#import "FilePathHelper.h"
#import "DynPlayMp3Voice.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
@interface BXDynSoundCell()<playDelegate>
@property(nonatomic, strong)UIImageView *backImageView;

@property(nonatomic, strong)NSString *pathfile;
@property(nonatomic, assign)NSInteger duration;

@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@property(nonatomic, assign)NSInteger playFlag;
@end
@implementation BXDynSoundCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    _backImageView = [[UIImageView alloc]init];
//    _backImageView.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAct)];
    [_backImageView addGestureRecognizer:tap];
    _backImageView.userInteractionEnabled = YES;
    _backImageView.image = [UIImage imageNamed:@"express_sound_backview"];
    [self.concenterBackview sd_addSubviews:@[_backImageView]];
    _backImageView.sd_layout.leftSpaceToView(self.concenterBackview, -8).topSpaceToView(self.concenterBackview, -3).widthIs(204).bottomSpaceToView(self.concenterBackview, -9);
    
    _timeLable = [[UILabel alloc]init];
    _timeLable.textColor = [UIColor whiteColor];
    _timeLable.font = [UIFont systemFontOfSize:14];
    _timeLable.text = @"00:00";
    _timeLable.textAlignment = 2;
    
    _soundImageView = [[UIImageView alloc]init];
    _soundImageView.image = [UIImage imageNamed:@"express_sound_note"];
    [self.backImageView sd_addSubviews:@[_timeLable, _soundImageView]];
    _timeLable.sd_layout.rightSpaceToView(self.backImageView, 20).centerYEqualToView(self.backImageView).offset(-3).widthIs(40).heightIs(20);
    _soundImageView.sd_layout.leftSpaceToView(self.backImageView, 20).centerYEqualToView(self.backImageView).offset(-3).widthIs(86).heightIs(23);
    
//    self.playSound = [[DynPlayMp3Voice alloc]init];
//    self.playSound.delegate =self;
    

    
}
-(void)playAct{
    
    
    if (self.DidSoundIndex) {
        self.DidSoundIndex(self.pathfile, self);
    }


    
}
-(void)updateCenterView{
    self.concenterBackview.sd_layout.heightIs(57);
    
     WS(weakSelf);
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            NSString *urlstr = self.model.msgdetailmodel.voice;

            NSURL *url = [NSURL URLWithString:urlstr];
            NSData *audata = [NSData dataWithContentsOfURL:url];
            weakSelf.pathfile = [self getImageFilePath:audata];

            AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: [NSURL URLWithString:self.pathfile] error:nil];
            weakSelf.duration = avAudioPlayer.duration;

            dispatch_group_leave(group);
        });
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        weakSelf.timeLable.text = [self getFormatString:self.duration];
        weakSelf.originTime = [self getFormatString:self.duration];
    });

}
-(void)setTimeLable:(UILabel *)timeLable{
    _timeLable.text = timeLable.text;
}
-(void)PlaySoundAct{
    if (IsNilString(_pathfile)) {
        return;
    }
    if (_playFlag == 0) {
        [_playSound startPlay];
        [self rotateView];
        _playFlag = 1;
    }else{
        _playFlag = 0;
        [_playSound StopPlay];
        [self.soundImageView.layer removeAllAnimations];
    }
//    [self downAnimation];

}
//-(void)ReturnDuratime:(NSString *)timeString{
//    self.timeLable.text = timeString;
//
//}
//-(void)endPlaySound{
// 
//    [self PlaySoundAct];
//}
-(void)StopPalyVoice{
    
    _playFlag = 0;
    [_playSound StopPlay];
    [self.soundImageView.layer removeAllAnimations];
}

- (void)rotateView{
    [_soundImageView.layer removeAllAnimations];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_soundImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)StoprotateView{
    [_soundImageView.layer removeAllAnimations];
}
- (NSString *)getFormatString:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}
//获取暂时文件路径
-(NSString *)getImageFilePath:(NSData *)Data {
    NSString *path = [[FilePathHelper getCachesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"wd%@.mp3",self.model.fcmid]];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [Data writeToFile:path atomically:YES];
    return path;
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

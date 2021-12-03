//
//  BXRecordingScreenView.m
//  BXlive
//
//  Created by bxlive on 2019/7/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXRecordingScreenView.h"
#import "BXRecordingScreenProcessView.h"
#import <Photos/Photos.h>
#import "FilePathHelper.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>

@interface BXRecordingScreenView ()

@property (nonatomic, weak) UIView *captureView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) BXRecordingScreenProcessView *progressView;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *screenshotBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isGiveUp;

@property (assign, nonatomic) NSInteger duration;

@end

@implementation BXRecordingScreenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static AVAudioPlayer *_audioPlayer = nil;

+ (void)screenCaptureWithView:(UIView *)view {
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"screenCapture" ofType:@"wav"]] error:nil];
        [_audioPlayer prepareToPlay];
    }
    [_audioPlayer play];
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = view.frame;
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                [BGProgressHUD showInfoWithMessage:@"截屏已保存到相册"];
            } else {
                [BGProgressHUD showInfoWithMessage:@"无相册权限，请在设置中打开"];
            }
        });
    }];
}

- (instancetype)initWithCaptureView:(UIView *)captureView {
    if ([super init]) {
        self.frame = CGRectMake(0, 0, __kWidth, __kHeight);
        _captureView = captureView;
        
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(63 + __kBottomAddHeight);
        }];
        
        _progressView = [[BXRecordingScreenProcessView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 3)];
        [_contentView addSubview:_progressView];
        
        UIButton *recordBtn = [[UIButton alloc]init];
        [recordBtn setImage:CImage(@"live_record_0") forState:BtnNormal];
        [recordBtn setImage:CImage(@"live_record_1") forState:BtnSelected];
        [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:BtnTouchUpInside];
        [_contentView addSubview:recordBtn];
        [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(46);
            make.top.mas_equalTo(10);
        }];
        _recordBtn = recordBtn;
        
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *typeBtn = [[UIButton alloc]init];
            typeBtn.tag = i;
            [typeBtn setTitle:i ? @"退出" : @"截屏" forState:BtnNormal];
            if (!i) {
                [typeBtn setTitle:@"重录" forState:BtnSelected];
                _screenshotBtn = typeBtn;
            } else {
                _closeBtn = typeBtn;
            }
            [typeBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            typeBtn.titleLabel.font = CFont(16);
            [typeBtn addTarget:self action:@selector(typeAction:) forControlEvents:BtnTouchUpInside];
            [_contentView addSubview:typeBtn];
            [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.mas_equalTo(recordBtn);
                if (i) {
                    make.right.mas_equalTo(-20);
                } else {
                    make.left.mas_equalTo(20);
                }
            }];
        }
    }
    return self;
}

- (void)setIsRecording:(BOOL)isRecording {
    _isRecording = isRecording;
    _recordBtn.selected = isRecording;
    _screenshotBtn.selected = isRecording;
}

- (void)recordAction {
    if (_isRecording) {
        [self stopRecordAction];
    } else {
        [self startRecordAction];
    }
}

- (void)typeAction:(UIButton *)sender {
    if (sender.tag) {
        if (_isRecording) {
            _isGiveUp = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(giveUpRecordingScreen)]) {
                [self.delegate giveUpRecordingScreen];
            }
            self.isRecording = NO;
        }
        [self endRecordingAction];
    } else {
        if (_isRecording) {
            _isGiveUp = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(giveUpRecordingScreen)]) {
                [self.delegate giveUpRecordingScreen];
            }
            self.isRecording = NO;
            self.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startRecordAction];
                self.userInteractionEnabled = YES;
            });
        } else {
            [BXRecordingScreenView screenCaptureWithView:_captureView];
            [self endRecordingAction];
        }
    }
}

- (void)startRecordAction {
    _isGiveUp = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecordingScreenCompletion:)]) {
        [self.delegate startRecordingScreenCompletion:^(int code) {
            if (code) {
                [BGProgressHUD showInfoWithMessage:@"录屏失败"];
                [self endRecordingAction];
                return;
            }
        }];
    }
    self.isRecording = YES;
}

- (void)stopRecordAction {
    _isGiveUp = NO;
    
    if (_duration <= MIN_RECORD_TIME) {
        NSInteger min = MIN_RECORD_TIME;
        NSString *info = [NSString stringWithFormat:@"录屏时间不低于%ld秒",(long)min];
        [BGProgressHUD showInfoWithMessage:info];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopRecordingScreen)]) {
        [self.delegate stopRecordingScreen];
    }
    self.isRecording = NO;
}

- (void)endRecordingAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordingScreen)]) {
        [self.delegate endRecordingScreen];
    }
    [self removeFromSuperview];
}

#pragma - mark TXLiveRecordListener
- (void)onRecordProgress:(NSInteger)milliSecond {
    _duration = milliSecond / 1000;
    [_progressView updateProgressWithTime:_duration];
    if (_duration >= MAX_RECORD_TIME) {
        [self stopRecordAction];
    }
}

- (void)onRecordComplete:(TXRecordResult*)result {
    if (!_isGiveUp) {
        if (result.retCode == RECORD_RESULT_OK || result.retCode == RECORD_RESULT_OK_INTERRUPT) {
            NSString *fileName = [result.videoPath lastPathComponent];
            NSString *filePath = [FilePathHelper getCachesPath];
            filePath = [filePath stringByAppendingPathComponent:fileName];
            
            [[NSFileManager defaultManager] moveItemAtPath:result.videoPath toPath:filePath error:nil];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetVideoWithFilePath:coverImage:)]) {
                [self.delegate didGetVideoWithFilePath:filePath coverImage:result.coverImage];
            }
            [self endRecordingAction];
        }
    }
}

@end

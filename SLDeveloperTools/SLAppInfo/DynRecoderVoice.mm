//
//  DynRecoderVoice.m
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DynRecoderVoice.h"
#import <AVFoundation/AVFoundation.h>
#import "mp3Encoder.hpp"

//编码队列
static dispatch_queue_t mp3EncodeQueue() {
    static dispatch_queue_t cmdRequestQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cmdRequestQueue =
        dispatch_queue_create("mp3EncodeQueue", DISPATCH_QUEUE_SERIAL);
    });
    return cmdRequestQueue;
}

static dispatch_queue_t localMp3EncodeQueue() {
    static dispatch_queue_t cmdRequestQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cmdRequestQueue =
        dispatch_queue_create("localMp3EncodeQueue", DISPATCH_QUEUE_SERIAL);
    });
    return cmdRequestQueue;
}

static NSString *const MP3SaveFilePath = @"MP3File";
static NSString *const CellReus = @"mp3Cell";


//采样率 44.1khz
#define sampleRate 44100
//边录制边编码的编码器
Mp3Encoder *streamEncoder = new Mp3Encoder();

@interface DynRecoderVoice()<AVAudioRecorderDelegate>
@property(nonatomic, strong)AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) NSString *mp3Path;
@property (nonatomic,strong) NSString *cafPath;
@property (nonatomic,strong)NSTimer *recordTimer;
@property (nonatomic,assign)NSInteger totalRecordSeconds;
@end
@implementation DynRecoderVoice
-(instancetype)init{
    self = [super init];
    if (self) {
        [self createMp3Folder];
            dispatch_async(localMp3EncodeQueue(), ^{

            });
    }
    return self;
}
//开始录音
- (void)recordStart{
    //清除上一次文件
    [self clearCafFile];
//    [self deleteMp3Folder];
    if (![self.audioRecorder isRecording]) {
        //开启会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(sessionError){
            NSLog(@"Set Audio Seesion Error: %@", [sessionError description]);}
        else{
            [session setActive:YES error:nil];
        }
        //录音
        [self.audioRecorder record];
        if ([self.audioRecorder isRecording]) {
            if (self.GetRecoder) {
                self.GetRecoder(YES);
            }
        }else{
            if (self.GetRecoder) {
                self.GetRecoder(NO);
            }
        }
        
        [self startRecordTimer];
        
        //先生成存储的MP3路径
        NSString *mp3Path = [self getCurrentMp3FilePath];
        
        //最重要的一步，要开始进行边录制边转码Mp3
        dispatch_async(mp3EncodeQueue(), ^{
            streamEncoder->Init([self.cafPath cStringUsingEncoding:NSUTF8StringEncoding],[mp3Path cStringUsingEncoding:NSUTF8StringEncoding] , 44100, 2, 128);
            streamEncoder->EncodeStreamFile();
            streamEncoder->Destroy();
            
            //主线程刷新数据
            __weak __typeof(self)weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self getMp3DataSource];
                if (weakSelf.GetMp3Path) {
                    weakSelf.GetMp3Path([weakSelf getCurrentMp3FilePath]);
                }
            });
        });
    }
}

//结束录音
- (void)recordEnd{
    if ([self.audioRecorder isRecording]) {
        //停止录音
        [self.audioRecorder stop];
        
        //设置标志位，编码结束
        streamEncoder->encodeEnd = true;
    }
    [self stopRecordTimer];

}
/**
 下一次录音开始会清除上一次的Caf文件，这里不缓存录音源文件
 */
- (void)clearCafFile {
    if (self.cafPath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.cafPath error:nil];
            NSLog(@"清除上一次的Caf文件");
        }
    }
}
/**
 *  AVAudioRecorder
 */
- (AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(sessionError){
            NSLog(@"Error creating session: %@", [sessionError description]);
        }
        else{
            [session setActive:YES error:nil];
        }
        
        //创建录音文件保存路径
        NSURL *url= [self getCafPath];
        //创建录音参数
        NSDictionary *setting = [self getAudioSetting];
        NSError *error=nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;
        [_audioRecorder prepareToRecord];
        if (error) {
            NSLog(@"创建AVAudioRecorder Error：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  录音参数设置
 */
- (NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(sampleRate) forKey:AVSampleRateKey]; //44.1khz的采样率
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey]; //16bit的PCM数据
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    return dicM;
}
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"录音");
    }
    
}

#pragma mark - Private Methods
- (void)startRecordTimer{
//    if (!self.recordTimer) {
//        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
//        [self.recordTimer setFireDate:[NSDate distantPast]];
//    }
}

- (void)stopRecordTimer{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        _totalRecordSeconds = 0;

    }
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


/**
 创建Mp3保存路径文件夹
 */
- (void)createMp3Folder{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"mp3file"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL createFolderSuc = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(createFolderSuc){
            NSLog(@"创建Mp3保存路径成功");
        }
    }
}
-(void)deleteMp3Folder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"mp3file"];
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if (isDirExist) {
        [fileManager removeItemAtPath:folderPath error:nil];
    }

    

}
-(void)createTMP{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3file"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL createFolderSuc = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(createFolderSuc){
            NSLog(@"创建Mp4保存路径成功");
        }
    }
}
-(NSString *)getTMP{
    NSString *folderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3file"];
    NSString *mp3FileName = @"record.mp3";
    return [folderPath stringByAppendingPathComponent:mp3FileName];
}


#pragma mark - Getter



- (NSString *)getCurrentMp3FilePath{
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"mp3file"];
    NSString *mp3FileName = @"record.mp3";
    return [folderPath stringByAppendingPathComponent:mp3FileName];
}

/**
 获取当前时间戳字符串
 */
-(NSString*)getCurrentTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd_HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

/**
 *  录音caf文件路径
 */
-(NSURL *)getCafPath{
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"mp3file" ];
    self.cafPath = [folderPath stringByAppendingPathComponent:@"record.caf"];
    NSURL *url=[NSURL fileURLWithPath:self.cafPath];
    return url;
}
@end

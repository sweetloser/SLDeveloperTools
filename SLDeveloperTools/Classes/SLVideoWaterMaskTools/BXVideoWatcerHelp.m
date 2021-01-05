//
//  BXliveWatcerHelp.m
//  BXlive
//
//  Created by bxlive on 2019/6/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoWatcerHelp.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "../SLUtilities/TimeHelper.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "FilePathHelper.h"
#import <GPUImage/GPUImage.h>
#import <Aspects/Aspects.h>
#import <YYWebImage/YYWebImage.h>


static  BXVideoWatcerHelp  * _help  = nil;

@interface BXVideoWatcerHelp ()
@property (nonatomic, strong)GPUImageNormalBlendFilter *filter;
@property (nonatomic, strong)GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageMovie *movieFile;

@property (nonatomic, strong)CADisplayLink* dlink;
@property (nonatomic, strong)AVAsset * videoAsset;
@property (nonatomic, strong)AVAssetExportSession *exporter;
@end


@implementation BXVideoWatcerHelp

+ (void)initialize{
    [GPUImageMovie aspect_hookSelector:@selector(endProcessing) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self clearMoveFile];
    } error:NULL];
    
}

+ (void)watermarkingWithVideoUrl:(NSURL *)videoUrl waterImg:(NSString *)waterImg text:(NSString *)text isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion isSystem:(BOOL)isSystem {
    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager loadImageWithURL:[NSURL URLWithString:waterImg] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//    }];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    [manager requestImageWithURL:[NSURL URLWithString:waterImg] options:YYWebImageOptionIgnoreImageDecoding progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSystem) {
                [self systemSaveVideoPath:videoUrl withWaterImg:image withName:text isShow:isSystem completion:completion];
            } else {
                [self avSaveVideoPath:videoUrl withWaterImg:image withName:text isShow:isShow completion:completion];
            }
        });
    }];
}

+ (void)clearMoveFile{
    _help = nil;
}

+ (void)avSaveVideoPath:(NSURL*)videoPath withWaterImg:(UIImage*)waterImg  withName:(NSString*)name isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion {
   BXVideoWatcerHelp *help = [[BXVideoWatcerHelp alloc] init];
    [help saveVideoPath:videoPath withWaterImg:waterImg withName:name isShow:isShow completion:completion];
    _help = help;
}

- (void)saveVideoPath:(NSURL*)videoPath withWaterImg:(UIImage*)waterImg  withName:(NSString*)name isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion{
    if (!videoPath) {
        return;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:videoPath];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize size = asset.naturalSize;
#pragma clang diagnostic pop
    if (!size.width || !size.height) {
        [BGProgressHUD showInfoWithMessage:@"处理视频失败"];
        return;
    }
    
    
    GPUImageNormalBlendFilter *filter = [[GPUImageNormalBlendFilter alloc] init];
    self.filter = filter;
    GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
    
    movieFile.playAtActualSpeed = NO;
    self.movieFile = movieFile;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subView.backgroundColor = [UIColor clearColor];
    
    // 文字水印
    UILabel *label = [UILabel initWithFrame:CGRectZero text:name size:25 color:[UIColor whiteColor] alignment:2 lines:1 shadowColor:nil];
    label.font =CBFont(25);
    [subView addSubview:label];
    [label sizeToFit];
    
    
    //图片水印
    UIImage *coverImage1 = [waterImg copy];
    UIImageView *coverImageView1 = [[UIImageView alloc] initWithImage:coverImage1];

    [subView addSubview:coverImageView1];
    
    CGFloat imgWidth = waterImg.size.width;
    CGFloat imgHeight = waterImg.size.height;
    if (arc4random_uniform(2) == 1) {
         coverImageView1.frame = CGRectMake(subView.width-label.width-30, subView.height-28-30-17-imgHeight, imgWidth,imgHeight);
        label.frame = CGRectMake(subView.width-label.width-30, subView.height-28-30,label.width, 28);
    }else{
//
        coverImageView1.frame = CGRectMake(30, 30, imgWidth, imgHeight);
        label.frame = CGRectMake(30, 30 + 17 + imgHeight,label.width, 28);
//
    }

    
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    
    NSString *fileName = [NSString stringWithFormat:@"%ld%u.mp4",(long)[TimeHelper getTimeSp],arc4random_uniform(1000)];
    NSString *totalPath = [FilePathHelper getTotalPath];
    NSString *folderPath = [totalPath stringByAppendingPathComponent:@"OutputCut"];
    [FilePathHelper createFolder:folderPath];
    NSString *videoFilePath = [folderPath stringByAppendingPathComponent:fileName];
    unlink([videoFilePath UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:videoFilePath];
    
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:size];
    self.movieWriter = movieWriter;
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [progressFilter addTarget:filter];
    [movieFile addTarget:progressFilter];
    [uielement addTarget:filter];
    movieWriter.shouldPassthroughAudio = YES;
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
        movieFile.audioEncodingTarget = movieWriter;
    } else {//no audio
        movieFile.audioEncodingTarget = nil;
    }
    
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    // 显示到界面
    [filter addTarget:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    //渲染
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        //        水印可以移动
        //        CGRect frame = coverImageView1.frame;
        //        frame.origin.x += 1;
        //        frame.origin.y += 1;
        //        coverImageView1.frame = frame;
        //        //第5秒之后隐藏coverImageView2
        //        if (time.value/time.timescale>=5.0) {
        //            [coverImageView2 removeFromSuperview];
        //        }
        
        if (isShow) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BGProgressHUD showProgress:CMTimeGetSeconds(time) / CMTimeGetSeconds([asset duration]) status:@"正在处理视频"];
            });
        }
        [uielement update];
    }];
    
    __weak GPUImageMovieWriter *weakMovieWriter = movieWriter;
    [movieWriter setCompletionBlock:^{
        [filter removeTarget:weakMovieWriter];
        [weakMovieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(videoFilePath);
            }
        });
    }];
}


///**
// 处理水印(系统方法)
//
// @param videoPath 视频本地的路径
// @param waterImg 水印图片
// @param name 水印文字 
// @param isShow 是否显示蒙版
// @param isSavePhotos 是否保存本地相册
// @param isCover 是否得到封面路径
// @param completion 得到本地路径
// */
+ (void)systemSaveVideoPath:(NSURL*)videoPath withWaterImg:(UIImage*)waterImg  withName:(NSString*)name isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion{
    BXVideoWatcerHelp *help = [[BXVideoWatcerHelp alloc] init];
    [help systemSaveVideoPaths:videoPath withWaterImg:waterImg withName:name isShow:isShow completion:completion];
}

- (void)systemSaveVideoPaths:(NSURL *)videoPath withWaterImg:(UIImage *)waterImg withName:(NSString *)name isShow:(BOOL)isShow completion:(void ((^)(NSString * _Nonnull)))completion{
    if (!videoPath) {
        return;
    }
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    self.videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize size = self.videoAsset.naturalSize;
#pragma clang diagnostic pop
    if (!size.width || !size.height) {
        [BGProgressHUD showInfoWithMessage:@"处理视频失败"];
        return;
    }

    
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(self.videoAsset.duration.value/self.videoAsset.duration.timescale-0.2, self.videoAsset.duration.timescale);
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];
    
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeFromTimeToTime(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:waterImg WithQustion:name size:CGSizeMake(renderWidth, renderHeight)];
    
    
    
    // 4 - 输出路径
    NSString *fileName = [NSString stringWithFormat:@"%ld%u.mp4",(long)[TimeHelper getTimeSp],arc4random_uniform(1000)];
    NSString *totalPath = [FilePathHelper getTotalPath];
    NSString *folderPath = [totalPath stringByAppendingPathComponent:@"OutputCut"];
    [FilePathHelper createFolder:folderPath];
    NSString *videoFilePath = [folderPath stringByAppendingPathComponent:fileName];
    
   
    NSLog(@"=======%@",videoFilePath);
    NSURL *movieURL = [NSURL fileURLWithPath:videoFilePath];
    
    self.dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [self.dlink setFrameInterval:15];
    [self.dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    // 5 - 视频文件输出
    
    self.exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                     presetName:AVAssetExportPresetHighestQuality];
    self.exporter.outputURL = movieURL;
    self.exporter.outputFileType = AVFileTypeQuickTimeMovie;
    self.exporter.shouldOptimizeForNetworkUse = YES;
    self.exporter.videoComposition = mainCompositionInst;
    [self.exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            if (self.exporter.status == AVAssetExportSessionStatusCompleted) {
                if (completion) {
                    completion([movieURL path]);
                    NSLog(@"路径:%@",[movieURL path]);
//                    NSArray *arr =[movieURL.absoluteString componentsSeparatedByString:@"file://"];
//                    if (arr.count > 0) {
//                        completion(arr[1]);
//                    }
                    
                }
            }
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img WithQustion:(NSString*)question  size:(CGSize)size {

   
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFontSize:25];
    [subtitle1Text setString:question];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];

    CGSize textSize = [question sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CBFont(25),NSFontAttributeName, nil]];

    



    //图片水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;

    


    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];

    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];

    
    CGSize layerPixelSize = [self layerSizeInPixels:parentLayer];
    NSLog(@"=====%f=====",[UIScreen mainScreen].scale);
    CGFloat imgWidth = img.size.width * [[UIScreen mainScreen] scale];
    CGFloat imgHeight = img.size.height  * [[UIScreen mainScreen] scale];
    
    if (arc4random_uniform(2) == 1) {
        //右下角
        subtitle1Text.frame = CGRectMake(layerPixelSize.width-textSize.width-30, 30, textSize.width, 28);

        imgLayer.frame = CGRectMake(videoLayer.frame.size.width-textSize.width-30, 30+28+15, imgWidth, imgHeight);
    }else{


        imgLayer.frame = CGRectMake(30, layerPixelSize.height-28-30, imgWidth, imgHeight);
        subtitle1Text.frame = CGRectMake(30, layerPixelSize.height-28-30-imgHeight, textSize.width, 28);


    }

    NSLog(@"%@",NSStringFromCGSize(size));

    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

}

- (CGSize)layerSizeInPixels:(CALayer *)layer {
    CGSize pointSize = layer.bounds.size;
    return CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
}

//更新生成进度
- (void)updateProgress {
     [BGProgressHUD showProgress:self.exporter.progress status:@"正在生成视频"];
    if (self.exporter.progress >= 1.0) {
        [BGProgressHUD hidden];
        
        [self.dlink invalidate];
        self.dlink = nil;
    }
}



@end

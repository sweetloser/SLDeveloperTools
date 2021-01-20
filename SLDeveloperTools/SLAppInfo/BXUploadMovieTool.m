
//
//  BXUploadMovieTool.m
//  BXlive
//
//  Created by bxlive on 2018/4/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXUploadMovieTool.h"
#import "FilePathHelper.h"
#import "TimeHelper.h"
#import "BXLiveUser.h"

@interface BXUploadMovieTool() <TXVideoPublishListener>

@property (strong, nonatomic) TXUGCPublish *videoPublish;
@end

@implementation BXUploadMovieTool

- (void)uploadMovie:(BXHMovieModel *)movie {
    _movie = movie;
    
    NSString *coverPath = [self getImageFilePathWithSign:_movie.sign];
    BOOL isSucceed = [self writeImageWithImage:_movie.coverImage filePath:coverPath];
    if (!isSucceed || !_movie.coverImage) {
        coverPath = [[NSBundle mainBundle] pathForResource:@"video-placeholder@2x" ofType:@"png"];
    }

    NSString *videoPath = [FilePathHelper getTotalPath];
    videoPath = [videoPath stringByAppendingPathComponent:@"OutputCut"];
    videoPath = [videoPath stringByAppendingPathComponent:[movie.videoPath lastPathComponent]];
    
    TXPublishParam *videoPublishParams = [[TXPublishParam alloc] init];
    videoPublishParams.signature  = movie.sign;
    videoPublishParams.coverPath = coverPath;
    videoPublishParams.videoPath  = videoPath;
    
    TXUGCPublish *videoPublish = [[TXUGCPublish alloc] initWithUserID:[BXLiveUser currentBXLiveUser].user_id];
    videoPublish.delegate = self;
    [videoPublish publishVideo:videoPublishParams];
    _videoPublish = videoPublish;
}

- (void)cancelUploadMovie {
    if (_videoPublish) {
        [_videoPublish canclePublish];
    }
}

- (NSString *)getImageFilePathWithSign:(NSString *)sign {
    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg",(long)[TimeHelper getTimeSp]];
    NSString *path = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:imageName];
    return path;
}

- (BOOL)writeImageWithImage:(UIImage *)image filePath:(NSString *)filePath {
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, .8);
    BOOL isSucceed = [imageData writeToFile:filePath atomically:YES];
    return isSucceed;
}

#pragma - mark TXVideoPublishListener
- (void)onPublishProgress:(NSInteger)uploadBytes totalBytes: (NSInteger)totalBytes {
    CGFloat progress = uploadBytes * 1.0 / totalBytes;
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadMovieProgress:movie:)]) {
        [self.delegate uploadMovieProgress:progress movie:_movie];
    }
}

-(void)onPublishComplete:(TXPublishResult*)result {
    NSString *coverPath = [self getImageFilePathWithSign:_movie.sign];
    [FilePathHelper removeFileAtPath:coverPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadMovieComplete:movie:)]) {
        [self.delegate uploadMovieComplete:result movie:_movie];
    }
}

@end

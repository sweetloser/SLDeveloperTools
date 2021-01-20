//
//  DynUploadToolModel.m
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DynUploadToolModel.h"
#import "FilePathHelper.h"
#import "TimeHelper.h"

@interface DynUploadToolModel() <TXVideoPublishListener>

@property (strong, nonatomic) TXUGCPublish *videoPublish;
@end

@implementation DynUploadToolModel

- (void)uploadMovie:(BXDynamicModel *)dynmodel {
    _dynmodel = dynmodel;
    
    NSString *coverPath = [self getImageFilePathWithSign:_dynmodel.sign];
    BOOL isSucceed = [self writeImageWithImage:_dynmodel.VideoCoverImage filePath:coverPath];
    if (!isSucceed || !_dynmodel.VideoCoverImage) {
        coverPath = [[NSBundle mainBundle] pathForResource:@"video-placeholder@2x" ofType:@"png"];
    }

    NSString *videoPath = [FilePathHelper getTotalPath];
    videoPath = [videoPath stringByAppendingPathComponent:@"OutputCut"];
    videoPath = [videoPath stringByAppendingPathComponent:[dynmodel.videoPath lastPathComponent]];
    
    TXPublishParam *videoPublishParams = [[TXPublishParam alloc] init];
    videoPublishParams.signature  = dynmodel.sign;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadProgress:dynmodel:)]) {
        [self.delegate uploadProgress:progress dynmodel:_dynmodel];
    }
}

-(void)onPublishComplete:(TXPublishResult*)result {
    NSString *coverPath = [self getImageFilePathWithSign:_dynmodel.sign];
    [FilePathHelper removeFileAtPath:coverPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadComplete:dynmodel:)]) {
        [self.delegate uploadComplete:result dynmodel:_dynmodel];
    }
}
@end

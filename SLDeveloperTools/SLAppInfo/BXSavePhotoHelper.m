//
//  BXSavePhotoHelper.m
//  BXlive
//
//  Created by bxlive on 2019/6/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSavePhotoHelper.h"
#import <Photos/Photos.h>
#import "../SLUtilities/SLUtilities.h"
#import "../SLMaskTools/SLMaskTools.h"

//清除数据, 设置 maxCacheSize 大于 0 即可



static NSUInteger maxCacheSize =  0;

@interface BXSavePhotoHelper ()

@property (nonatomic, copy) void (^completion)(NSError *error);

@end

@implementation BXSavePhotoHelper

+ (void)savePhotos:(NSString *)videoPath completion:(void (^)(NSError *))completion {
    BXSavePhotoHelper *savePhotoHelper = [[BXSavePhotoHelper alloc]init];
    savePhotoHelper.completion = completion;
    if (videoPath) {
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
        if (compatible) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, savePhotoHelper, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

+(void)autoClearCacheWithLimitedToSize:(NSUInteger)mSize{
    maxCacheSize = mSize;
}

static inline NSString *cachePath() {
    
    NSString *totalPath = [FilePathHelper getTotalPath];
    NSString *folderPath = [totalPath stringByAppendingPathComponent:@"OutputCut"];
    [FilePathHelper createFolder:folderPath];
    
    return folderPath;
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"缓存error: %@", error);
        } else {
            NSLog(@"清理成功");
        }
    }
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}


//保存视频完成之后的回调
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [BGProgressHUD showInfoWithMessage:@"视频保存失败"];
    } else {
        [BGProgressHUD showInfoWithMessage:@"视频保存成功"];

    }
    
    if (_completion) {
        _completion(error);
    }
}

@end

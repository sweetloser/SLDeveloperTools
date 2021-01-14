//
//  BXMusicDownloadManager.m
//  BXlive
//
//  Created by bxlive on 2019/4/29.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicDownloadManager.h"
#import "FilePathHelper.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
@interface BXMusicDownloadManager ()

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation BXMusicDownloadManager
- (instancetype)init {
    self = [super init];
    if (self) {
        _modelArray = [NSMutableArray array];
    }
    return self;
}

+ (void)load {
    NSString *folderName = @"SelectMusic";
    NSString *filePath = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:folderName];
    [FilePathHelper removeFileAtPath:filePath];
}

+ (BXMusicDownloadManager *)shareMusicDownloadManager {
    static dispatch_once_t onceToken;
    static BXMusicDownloadManager *_downloadManager = nil;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[BXMusicDownloadManager alloc]init];
    });
    return _downloadManager;
}

+ (void)downloadMusic:(BXMusicModel *)music isDownLyric:(BOOL)isDownLyric completion:(void (^)(BXMusicModel *music))completion {
    BOOL musicIsExists = [FilePathHelper fileIsExistsAtPath:[music allFilePath]];
    BOOL lyricIsExists = [FilePathHelper fileIsExistsAtPath:[music lyricFilePath]];
    
    if (musicIsExists) {
        if (isDownLyric) {
            if (lyricIsExists) {
                if (completion) {
                    completion(music);
                }
                return;
            }
        } else {
            if (completion) {
                completion(music);
            }
            return;
        }
    }
    BXMusicDownloadManager *musicDownloadManager = [BXMusicDownloadManager shareMusicDownloadManager];
    if (musicDownloadManager.modelArray.count >= 10) {
        BXMusicModel *theMusic = musicDownloadManager.modelArray[0];
        [FilePathHelper removeFileAtPath:[theMusic allFilePath]];
        [FilePathHelper removeFileAtPath:[theMusic lyricFilePath]];
        [musicDownloadManager.modelArray removeObjectAtIndex:0];
    }
    [BGProgressHUD showLoadingWithMessage:nil];
    dispatch_group_t group = nil;
    if (isDownLyric) {
        group = dispatch_group_create();
    }
    
    if (!musicIsExists) {
        if (group) {
            dispatch_group_enter(group);
        }
        [SLUpLoadAndDownloadTools downloadFileWithUrlString:music.link filePath:[music allFilePath] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            if (flag) {
                if (![musicDownloadManager.modelArray containsObject:music]) {
                    [musicDownloadManager.modelArray addObject:music];
                }
                if (!group) {
                    [BGProgressHUD hidden];
                    if (completion) {
                        completion(music);
                    }
                }
            } else {
                if (!group) {
                    [BGProgressHUD showInfoWithMessage:@"下载音乐失败，请重试"];
                }
            }
            if (group) {
                dispatch_group_leave(group);
            }
        } failure:^(NSError *error) {
            if (group) {
                dispatch_group_leave(group);
            }else{
                [BGProgressHUD showInfoWithMessage:@"下载音乐失败，请重试"];
            }
        }];
    }
    
    if (!lyricIsExists) {
        if (group) {
            dispatch_group_enter(group);
            [SLUpLoadAndDownloadTools downloadFileWithUrlString:music.lrc filePath:[music lyricFilePath] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
                if (flag) {
                    if (![musicDownloadManager.modelArray containsObject:music]) {
                        [musicDownloadManager.modelArray addObject:music];
                    }
                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                 dispatch_group_leave(group);
            }];
        }
    }
    
    if (group) {
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [BGProgressHUD hidden];
            BOOL musicIsExists2 = [FilePathHelper fileIsExistsAtPath:[music allFilePath]];
//            BOOL lyricIsExists2 = [FilePathHelper fileIsExistsAtPath:[music lyricFilePath]];
            if (musicIsExists2) {
                if (completion) {
                    completion(music);
                }
            } else {
                [BGProgressHUD showInfoWithMessage:@"下载音乐失败，请重试"];
            }
        });
    }
}

@end

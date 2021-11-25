//
//  BXDeluxeGiftTool.m
//  BXlive
//
//  Created by bxlive on 2019/7/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXDeluxeGiftTool.h"
#import "BXGift.h"
#import "FilePathHelper.h"
#import <SSZipArchive/SSZipArchive.h>
#import "BXGiftSqliteTool.h"
#import "UIDevice+Kit.h"
#import "NewHttpManager.h"
#import "SLDeveloperTools.h"


@interface BXDeluxeGiftTool ()<SSZipArchiveDelegate>

@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic, strong) NSMutableArray *needDownloadGifts;
@property (nonatomic, strong) NSMutableArray *failDownloadGifts;

@end

@implementation BXDeluxeGiftTool

- (void)setIsDownloading:(BOOL)isDownloading {
    _isDownloading = isDownloading;
    if (!isDownloading) {
        _retryCount = 0;
    }
}

+ (BXDeluxeGiftTool *)sharedDeluxeGiftTool {
    static BXDeluxeGiftTool *_deluxeGiftTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deluxeGiftTool = [[BXDeluxeGiftTool alloc]init];
    });
    return _deluxeGiftTool;
}

+ (BOOL)giftIsExistWithGiftId:(NSString *)giftId {
    BOOL isExist = [self giftIsExistInLocationWithGiftId:giftId];
    if (!isExist) {
        NSString *path = [BXDeluxeGiftTool getGiftPathWithGiftId:giftId];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator =[fileManager enumeratorAtPath:path];
        while([enumerator nextObject]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

+ (BOOL)giftIsExistInLocationWithGiftId:(NSString *)giftId {
    return NO;
}

+ (NSString *)getGiftPathWithGiftId:(NSString *)giftId {
    NSString *path = [self getGiftPath];
    path = [path stringByAppendingPathComponent:giftId];
    [FilePathHelper createFolder:path];
    return path;
}

+ (void)downloadGiftImages {
    BXDeluxeGiftTool *deluxeGiftTool = [BXDeluxeGiftTool sharedDeluxeGiftTool];
    if (deluxeGiftTool.isDownloading) {
        return;
    }
    deluxeGiftTool.isDownloading = YES;
    
    [NewHttpManager onlineGiftsWithSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSArray *dataArr = jsonDic[@"data"];
            if (dataArr && [dataArr isArray] && dataArr.count) {
                NSMutableArray *gifts = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    BXGift *gift = [[BXGift alloc]init];
                    [gift updateWithJsonDic:dic];
                    if (![self giftIsExistInLocationWithGiftId:gift.giftId]) {
                        [gifts addObject:gift];
                    }
                }
                [self eliminateGiftImagesWithInitialGifts:gifts];
            } else {
                deluxeGiftTool.isDownloading = NO;
            }
        } else {
            deluxeGiftTool.isDownloading = NO;
        }
    } failure:^(NSError *error) {
        deluxeGiftTool.isDownloading = NO;
    }];
}

+ (void)updatePriorityWithGiftId:(NSString *)giftId {
    if (giftId) {
        BXDeluxeGiftTool *deluxeGiftTool = [BXDeluxeGiftTool sharedDeluxeGiftTool];
        NSInteger index = -1;
        for (NSInteger i = 0; i < deluxeGiftTool.needDownloadGifts.count; i++) {
            BXGift *gift = deluxeGiftTool.needDownloadGifts[i];
            if ([gift.giftId integerValue] == [giftId integerValue]) {
                index = i;
                break;
            }
        }
        if (index > 0) {
            [deluxeGiftTool.needDownloadGifts exchangeObjectAtIndex:index withObjectAtIndex:0];
        }
    }
}

#pragma - mark private
+ (void)eliminateGiftImagesWithInitialGifts:(NSArray *)initialGifts {
    NSArray *didDownloadGiftIds = [self getDidDownloadGiftIds];
    if (!didDownloadGiftIds.count) {
        [FilePathHelper removeFileAtPath:[self getGiftPath]];
    }
    
    NSMutableSet *willRemoveGiftIds = [NSMutableSet set];
    NSMutableArray *needDownloadGifts = [NSMutableArray array];
    
    NSMutableArray *tempGiftIds = [NSMutableArray array];
    for (BXGift *gift in initialGifts) {
        BOOL isDownload = NO;
        if ([didDownloadGiftIds containsObject:gift.giftId]) {
            if ([self giftIsExistWithGiftId:gift.giftId]) {
                isDownload = YES;
            } else {
                [willRemoveGiftIds addObject:gift.giftId];
            }
        }
        if (!isDownload) {
            [needDownloadGifts addObject:gift];
        }
        [tempGiftIds addObject:gift.giftId];
    }
    for (NSString *giftId in didDownloadGiftIds) {
        if (![tempGiftIds containsObject:giftId]) {
            [willRemoveGiftIds addObject:giftId];
        }
    }
    
    if (willRemoveGiftIds.count) {
        for (NSString *giftId in willRemoveGiftIds) {
            [self removeGiftWithGiftId:giftId];
            [BXGiftSqliteTool deleteGiftWithGiftId:giftId tableName:@"t_downloadGift"];
        }
    }
    if (needDownloadGifts.count) {
        [self downloadGiftImagesWithGifts:needDownloadGifts];
    } else {
        [BXDeluxeGiftTool sharedDeluxeGiftTool].isDownloading = NO;
    }
}

+ (NSArray *)getDidDownloadGiftIds {
    __block NSMutableArray *ids = [NSMutableArray array];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [BXGiftSqliteTool queryGiftsWithTableName:@"t_downloadGift" block:^(NSArray <BXGift *>*gifts) {
        for (BXGift *gift in gifts) {
            [ids addObject:gift.giftId];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return ids;
}

+ (void)downloadGiftImagesWithGifts:(NSArray *)gifts {
    BXDeluxeGiftTool *deluxeGiftTool = [BXDeluxeGiftTool sharedDeluxeGiftTool];
    deluxeGiftTool.totalZipCount = gifts.count;
    deluxeGiftTool.remainingZipCount = gifts.count;
    deluxeGiftTool.needDownloadGifts = [NSMutableArray arrayWithArray:gifts];
    deluxeGiftTool.failDownloadGifts = [NSMutableArray array];
    [self beginDownloadGifts];
}

+ (void)beginDownloadGifts {
    BXDeluxeGiftTool *deluxeGiftTool = [BXDeluxeGiftTool sharedDeluxeGiftTool];
    NSMutableArray *gifts = [NSMutableArray array];
    CGFloat totalSize = 0;
    CGFloat freeSize = [[UIDevice freeDiskSpace] floatValue];
    
    for (BXGift *gift in deluxeGiftTool.needDownloadGifts) {
        [gifts addObject:gift];
        totalSize += [gift.size floatValue];
        if (gifts.count >= 2) {
            break;
        }
    }
    if (gifts.count) {
        if (freeSize < totalSize) {
            deluxeGiftTool.isDownloading = NO;
            [BGProgressHUD showInfoWithMessage:@"礼物下载失败，请清理手机空间后重启App"];
            return;
        }
        
        [deluxeGiftTool.needDownloadGifts removeObjectsInArray:gifts];
        
        NSString *folderPath = [[FilePathHelper getCachesPath] stringByAppendingPathComponent:@"tempGift"];
        NSString *unzipFolderPath = [folderPath stringByAppendingPathComponent:@"unzip"];
        [FilePathHelper createFolder:unzipFolderPath];
       
        dispatch_group_t group = dispatch_group_create();
        for (NSInteger i = 0; i < gifts.count; i++) {
            dispatch_group_enter(group);
            BXGift *gift = gifts[i];
            NSString *resource = gift.file;
            NSString *tempFilePath = [folderPath stringByAppendingPathComponent:[resource lastPathComponent]];
            
            dispatch_async(dispatch_queue_create("downloadGift", DISPATCH_QUEUE_CONCURRENT), ^{
                [SLUpLoadAndDownloadTools downloadFileWithUrlString:resource filePath:tempFilePath success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
                    if (flag) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            if ([SSZipArchive unzipFileAtPath:tempFilePath toDestination:unzipFolderPath]) {
                            }else {
                                // NSSLog(@"解压失败");
                            }
                
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [BXGiftSqliteTool insertGift:gift tableName:@"t_downloadGift"];
                                [FilePathHelper removeFileAtPath:tempFilePath];
                                deluxeGiftTool.remainingZipCount--;
                                [[NSNotificationCenter defaultCenter] postNotificationName:kRemainingZipCountNotification object:nil userInfo:@{@"total": [NSString stringWithFormat:@"%ld",(long)deluxeGiftTool.totalZipCount],@"count":[NSString stringWithFormat:@"%ld",(long)deluxeGiftTool.remainingZipCount]}];
                                NSLog(@"=================:下载进度：%d/%ld",deluxeGiftTool.totalZipCount - deluxeGiftTool.remainingZipCount,(long)deluxeGiftTool.totalZipCount);
                                dispatch_group_leave(group);
                            });
                        });
                    } else {
                        [deluxeGiftTool.failDownloadGifts addObject:gift];
                        dispatch_group_leave(group);
                    }
                } failure:^(NSError *error) {
                    [deluxeGiftTool.failDownloadGifts addObject:gift];
                    dispatch_group_leave(group);
                }];
            });
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self didDownloadCompletedWithFolderPaths:unzipFolderPath];
            [self beginDownloadGifts];
        });
    } else {
        if (deluxeGiftTool.failDownloadGifts.count) {
            deluxeGiftTool.retryCount++;
            if (deluxeGiftTool.retryCount < 3) {
                [self downloadGiftImagesWithGifts:deluxeGiftTool.failDownloadGifts];
            } else {//部分失败，下载结束
                deluxeGiftTool.isDownloading = NO;
            }
        } else {//全部成功，下载结束
            deluxeGiftTool.isDownloading = NO;
        }
    }
}

+ (void)didDownloadCompletedWithFolderPaths:(NSString *)unzipFolderPath {
    NSString *path = [self getGiftPath];
    [FilePathHelper createFolder:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *thePath = nil;
    NSDirectoryEnumerator *enumerator =[fileManager enumeratorAtPath:unzipFolderPath];
    while(thePath = [enumerator nextObject]) {
        NSString *toPath = [path stringByAppendingPathComponent:thePath];
        [fileManager moveItemAtPath:[unzipFolderPath stringByAppendingPathComponent:thePath] toPath:toPath error:nil];
    }
    
    NSString *folderPath = [[FilePathHelper getCachesPath] stringByAppendingPathComponent:@"tempGift"];
    [FilePathHelper removeFileAtPath:folderPath];
}


+ (NSString *)getGiftPath {
    NSString *path = [FilePathHelper getCachesPath];
    path = [path stringByAppendingPathComponent:@"Gift"];
    [FilePathHelper createFolder:path];
    return path;
}

+ (void)removeGiftWithGiftId:(NSString *)giftId {
    NSString *giftPath = [self getGiftPathWithGiftId:giftId];
    [FilePathHelper removeFileAtPath:giftPath];
}

@end

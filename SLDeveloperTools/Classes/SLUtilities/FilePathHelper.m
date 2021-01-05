//
//  FilePathHelper.m
//  信云课堂
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import "FilePathHelper.h"

@implementation FilePathHelper


/// 创建文件夹
/// @param path 文件夹绝对路径
+(void)createFolder:(NSString*)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(void)removeFileAtPath:(NSString*)path{
    if ([self fileIsExistsAtPath:path]) {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:nil];
    }
}

+(BOOL)fileIsExistsAtPath:(NSString *)path
{
    if (!path || !path.length) {
        return NO;
    }else{
        return  [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
}

+(NSString*)getFilePathWithFolderPath:(NSString*)folderPath fileName:(NSString*)fileName{
    [FilePathHelper createFolder:folderPath];
    NSString *filePath=[folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}


/// 获取 cache 路径
+(NSString*)getCachesPath{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cacPath firstObject];
}

/// 返回沙盒 document 路径
+(NSString*)getDocumentsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(NSString*)getTotalPath{
    NSString *path=[FilePathHelper getCachesPath];
    path=[path stringByAppendingPathComponent:@"TotalFolder"];
    [FilePathHelper createFolder:path];
    return path;
}

+(NSString *)getTotalPathForImage:(NSString *)filePath{
    
    NSString *path=[FilePathHelper getTotalPath];
    path=[path stringByAppendingPathComponent:@"CacheImage"];
    [FilePathHelper createFolder:path];
    path = [path stringByAppendingPathComponent:filePath];
    return path;
}
//把图片写入沙盒
+(NSString *)writeToFilePath:(UIImage *)fileImage{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,((arc4random() % 501) + 500)];
    [UIImagePNGRepresentation(fileImage) writeToFile:[FilePathHelper getTotalPathForImage:fileName] atomically:YES];
    return fileName;
}




/// 获取文件大小
/// @param filePath 文件的绝对路径
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/// 获取文件夹 的 大小
/// @param folderPath 文件夹的绝对路径
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        BOOL isFile;
        [manager fileExistsAtPath:fileAbsolutePath isDirectory:&isFile];
        if (!isFile && ![[fileName lastPathComponent] isEqualToString:@".DS_Store"]) {
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    return folderSize/(1024.0*1024.0);
}

@end

//
//  FilePathHelper.h
//  信云课堂
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FilePathHelper : NSObject
//检测文件  是否 存在
+(BOOL)fileIsExistsAtPath:(NSString *)path;

//根据路径 创建文件夹
+(void)createFolder:(NSString*)path;

//删除文件
+(void)removeFileAtPath:(NSString*)path;

//获取文件路径
+(NSString*)getFilePathWithFolderPath:(NSString*)folderPath fileName:(NSString*)fileName;

//获取caches路径
+(NSString*)getCachesPath;

//获取Documents路径
+(NSString*)getDocumentsPath;

//获取总文件夹路径
+(NSString*)getTotalPath;

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;

//获取总文件夹下面的图片缓存路径
+(NSString*)getTotalPathForImage:(NSString *)filePath;

//把图片写入沙盒
+(NSString *)writeToFilePath:(UIImage *)fileImage;



@end

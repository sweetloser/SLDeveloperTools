//
//  DSSavePhotoHelper.h
//  BXlive
//
//  Created by bxlive on 2019/6/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXSavePhotoHelper : NSObject

//保存x到相册
+ (void)savePhotos:(NSString *)videoPath completion:(void (^)(NSError *error))completion;

//自动清理缓存
+ (void)autoClearCacheWithLimitedToSize:(NSUInteger)mSize;
//
//
////清理缓存
+ (void)clearCaches;

@end


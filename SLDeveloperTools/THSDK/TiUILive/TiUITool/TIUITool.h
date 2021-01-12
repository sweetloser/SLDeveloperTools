//
//  TIUITool.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/4.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TIUITool : NSObject
//更具路径获取对应的json文件数据
+(id)getJsonDataForPath:(NSString *)path;

//更具路径将对应的字典写入json
+(void)setWriteJsonDic:(NSDictionary *)dic toPath:(NSString *)path;

//下载图片并缓存的公共方法
+(void)getImageFromeURL:(NSString *)fileURL WithFolder:(NSString *)folder downloadComplete:(void(^) (UIImage *image))completeBlock;

@end

NS_ASSUME_NONNULL_END

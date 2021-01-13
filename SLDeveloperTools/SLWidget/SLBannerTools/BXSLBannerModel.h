//
//  BXSLBannerModel.h
//  BXlive
//
//  Created by bxlive on 2018/1/30.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXSLBannerModel : NSObject
//图片
@property (nonatomic,copy) NSString  *imageNormal;
//图片
@property (nonatomic,copy) NSString  *imageX;
//url
@property (nonatomic,copy) NSString *url;
//名字
@property (nonatomic,copy) NSString *title;
//选中
@property (nonatomic,assign) NSInteger isSelect;


- (instancetype)initWithDict:(NSDictionary *)dict;

/**工厂方法*/
+ (instancetype)appInfoWithDict:(NSDictionary *)dict;

@end

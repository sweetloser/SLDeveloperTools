//
//  BXBannerModel.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXBannerModel : NSObject
//图片
@property (nonatomic,copy) NSString  *imageNormal;
//图片
@property (nonatomic,copy) NSString  *imageX;
//url
@property (nonatomic,copy) NSString *url;
//名字
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;

/**工厂方法*/
+ (instancetype)appInfoWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

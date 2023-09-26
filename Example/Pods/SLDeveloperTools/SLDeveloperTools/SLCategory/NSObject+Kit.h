//
//  NSObject+Kit.h
//  BXlive
//
//  Created by bxlive on 2016/10/18.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 用法: 直接在模型中使用,具体可以查看balanceOfBillModel 这个模型
 
 */
@protocol KeyValue <NSObject>

@optional
/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)objectClassInArray;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)replacedKeyFromPropertyName;

@end


@interface NSObject (Kit)<KeyValue>

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary;


+(NSArray *)getAllMethods;
+(NSArray *)getAllProperties;
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj;

@end

//
//  PredCheck.h
//  BXlive
//
//  Created by bxlive on 16/4/7.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredCheck : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;


//用户名
+ (BOOL) validateUserName:(NSString *)name;


//密码
+ (BOOL) validatePassword:(NSString *)passWord;


//昵称
+ (BOOL) validateNickname:(NSString *)nickname;


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;


/**
 *  判断是否为整形
 *
 *  @param string 字符串
 *
 *  @return 是返回YES
 */
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  判断是否为浮点形
 *
 *  @param string 字符串
 *
 *  @return 是返回YES
 */
+ (BOOL)isPureFloat:(NSString*)string;

/**
 *  判断是否为英文和数字
 *
 *  @param string 字符串
 *
 *  @return 是返回YES
 */
+ (BOOL)isEnglishOrNumber:(NSString*)string;


/**
 *  判断是否为中文或者英文和数字
 *
 *  @param string 字符串
 *
 *  @return 是返回YES
 */
+ (BOOL)isChineseOrWordOrNumber:(NSString *)string;



/**
 *  判断是否为中文或者英文
 *
 *  @param string 字符串
 *
 *  @return 是返回YES
 */
+ (BOOL)isChineseOrWord:(NSString *)string;

@end

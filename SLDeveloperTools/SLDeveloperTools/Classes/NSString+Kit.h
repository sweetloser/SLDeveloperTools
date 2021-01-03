//
//  NSString+Kit.h
//  BXlive
//
//  Created by bxlive on 16/7/19.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Kit)

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *__nullable)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;


/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end;

/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end;

/**
 *  创建一个MD5字符串
 */
- (NSString *)MD5;

/**
 *  检查自身是否追加字符串
 */
- (BOOL)hasString:(NSString *)substring;

/**
 *  字符串转换为UTF8
 */
+ (NSString *)convertToUTF8Entities:(NSString *)string;

/**
 *  编码给定的字符串成Base64
 */
+ (NSString *)encodeToBase64:(NSString *)string;

/**
 *  编码自身成Base64
 */
- (NSString *)encodeToBase64;

/**
 *  解码给定的字符串成Base64
 */
+ (NSString *)decodeBase64:(NSString *)string;

/**
 *  解码自身成Base64
 */
- (NSString *)decodeBase64;

/**
 *  转换自身为开头大写字符串.
 *  例如: "This is a Test" 将返回 "This is a test"
 "this is a test"  将返回 "This is a test"
 */
- (NSString *)sentenceCapitalizedString;

/**
 *  返回一个从时间戳人类易读的字符串
 */
- (NSString *)dateFromTimestamp;

/**
 *  自编码成编码的URL字符串
 */
- (NSString *)urlEncode;



#pragma mark - *****  数字处理 类
/*! 判断是否为整形 */
- (BOOL)ZZLisPureInt:(nullable NSString*)string;

/*! 判断是否为浮点形 */
- (BOOL)ZZLisPureFloat:(nullable NSString*)string;


#pragma mark - *****  特殊字符串处理 类

/*! 重复字符串N次 */
+ (nullable NSString *)getText:(nullable NSString *)text withRepeat:(int)repeat;

/*! 去掉字符串中的html标签的方法 */
- (nullable NSString *)ZZLfilterHTML:(nullable NSString *)html;

/*! 十六进制转换为普通字符串 */
- (nullable NSString *)ZZLstringFromHexString:(nullable NSString *)hexString;

/**
 *   Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 *
 *  @param name The file name (in main bundle).
 *
 *  @return A new string create from the file in UTF-8 character encoding.
 */
+ (nullable NSString *)stringNamed:(nullable NSString *)name;

/*!
 *  去除字符串的特殊字符
 *
 *  @param string 需要处理的字符串（如：NSString *string = @"<f7091300 00000000 830000c4 00002c00 0000c500>";）
 *
 *  @return 去除字符串的特殊字符
 */
- (nullable NSString *)ZZLtrimmedString:(nullable NSString *)string;

/*!
 *  判断字符串是否为空
 *
 *  @param aStirng aStirng
 *
 *  @return 判断字符串是否为空
 */
+ (BOOL)ZZLNSStringIsNULL:(nullable NSString *)aStirng;

/*!
 *  判断字符串是否为url
 *
 *  @param url url description
 *
 *  @return 判断字符串是否为url
 */
+ (BOOL)ZZLurl_isURL:(nullable NSString *)url;



/*! 获取字符串的长度 */
+ (NSUInteger)ZZLgetLengthOfStr:(nullable NSString *)str;



/*! 特殊字符串处理：改变部分字符串的字体颜色 */
+ (nullable NSMutableAttributedString *)ZZLcreatMutableAttributedString:(nullable NSString *)text textColor:(nullable UIColor *)textColor bgColor:(nullable UIColor *)bgColor font:(CGFloat)fontSize range:(NSRange)range;

#pragma mark - *****  获取软件沙盒路径 类

/*! 获取软件沙盒路径 */
+ (nullable NSString *)ZZLpath_getApplicationSupportPath;

/*! 获取软件沙盒Documents路径 */
+ (nullable NSString *)ZZLpath_getDocumentsPath;

/*! 获取软件沙盒cache路径 */
+ (nullable NSString *)ZZLpath_getCachePath;

/*! 获取软件沙盒cachesDic路径 */
+ (nullable NSString *)ZZLpath_getTemPath;

/*! 在软件沙盒指定的路径创建一个目录 */
+ (BOOL)ZZLpath_createDirectory:(nullable NSString *)newDirectory;

/*! 在软件沙盒指定的路径删除一个目录 */
+ (BOOL)ZZLpath_deleteFilesysItem:(nullable NSString*)strItem;

/*! 在软件沙盒路径移动一个目录到另一个目录中 */
+ (BOOL)ZZLpath_moveFilesysItem:(nullable NSString *)srcPath toPath:(nullable NSString *)dstPath;

/*! 在软件沙盒路径中查看有没有这个路径 */
+ (BOOL)ZZLpath_fileExist:(nullable NSString*)strPath;

/*! 在软件沙盒路径中获取指定userPath路径 */
- (nullable NSString *)ZZLpath_getUserInfoStorePath:(nullable NSString *)userPath;



/**
 *  拨打电话
 *
 *  @param num 电话号码
 */
+ (void)callPhoneWithNum:(NSString *__nullable)num;


- (NSString *)MD5Hash;

/**
 *  拼些所需图片尺寸
 *
 *  @param height 图片高
 *  @param width 图片宽
 */
- (NSString *)appendImageSringWithHeight:(NSString *)height Width:(NSString *)width;



- (NSString *)sha1;


@end

NS_ASSUME_NONNULL_END


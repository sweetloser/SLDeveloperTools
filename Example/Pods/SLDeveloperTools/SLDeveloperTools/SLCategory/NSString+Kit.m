//
//  NSString+Kit.m
//  BXlive
//
//  Created by bxlive on 16/7/19.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "NSString+Kit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Kit)

/* 搜索两个字符之间的字符串 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end
{
    int inizio = 0, stop = 0;
    for(int i = 0; i < [string length]; i++)
    {
        // 定位起点索引字符
        if([string characterAtIndex:i] == start)
        {
            inizio = i+1;
            i += 1;
        }
        // 定位结束索引字符
        if([string characterAtIndex:i] == end)
        {
            stop = i;
            break;
        }
    }
    stop -= inizio;
    // 裁剪字符串
    NSString *string2 = [[string substringFromIndex:inizio-1] substringToIndex:stop+1];
    return string2;
}

/* 搜索两个字符之间的字符串 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end
{
    int inizio = 0, stop = 0;
    for(int i = 0; i < [self length]; i++)
    {
        if([self characterAtIndex:i] == start)
        {
            inizio = i+1;
            i += 1;
        }
        if([self characterAtIndex:i] == end)
        {
            stop = i;
            break;
        }
    }
    stop -= inizio;
    NSString *string = [[self substringFromIndex:inizio-1] substringToIndex:stop+1];
    
    return string;
}

/* 创建一个MD5字符串 */
- (NSString *)MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/* 检查自身是否追加字符串 */
- (BOOL)hasString:(NSString *)substring
{
    return !([self rangeOfString:substring].location == NSNotFound);
}

/* 字符串转换为UTF8 */
+ (NSString *)convertToUTF8Entities:(NSString *)string
{
    NSString *isoEncodedString = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
                                                                  [string stringByReplacingOccurrencesOfString:@"%27" withString:@"'"]
                                                                  stringByReplacingOccurrencesOfString:[@"%e2%80%99" capitalizedString] withString:@"’"]
                                                                 stringByReplacingOccurrencesOfString:[@"%2d" capitalizedString] withString:@"-"]
                                                                stringByReplacingOccurrencesOfString:[@"%c2%ab" capitalizedString] withString:@"«"]
                                                               stringByReplacingOccurrencesOfString:[@"%c2%bb" capitalizedString] withString:@"»"]
                                                              stringByReplacingOccurrencesOfString:[@"%c3%80" capitalizedString] withString:@"À"]
                                                             stringByReplacingOccurrencesOfString:[@"%c3%82" capitalizedString] withString:@"Â"]
                                                            stringByReplacingOccurrencesOfString:[@"%c3%84" capitalizedString] withString:@"Ä"]
                                                           stringByReplacingOccurrencesOfString:[@"%c3%86" capitalizedString] withString:@"Æ"]
                                                          stringByReplacingOccurrencesOfString:[@"%c3%87" capitalizedString] withString:@"Ç"]
                                                         stringByReplacingOccurrencesOfString:[@"%c3%88" capitalizedString] withString:@"È"]
                                                        stringByReplacingOccurrencesOfString:[@"%c3%89" capitalizedString] withString:@"É"]
                                                       stringByReplacingOccurrencesOfString:[@"%c3%8a" capitalizedString] withString:@"Ê"]
                                                      stringByReplacingOccurrencesOfString:[@"%c3%8b" capitalizedString] withString:@"Ë"]
                                                     stringByReplacingOccurrencesOfString:[@"%c3%8f" capitalizedString] withString:@"Ï"]
                                                    stringByReplacingOccurrencesOfString:[@"%c3%91" capitalizedString] withString:@"Ñ"]
                                                   stringByReplacingOccurrencesOfString:[@"%c3%94" capitalizedString] withString:@"Ô"]
                                                  stringByReplacingOccurrencesOfString:[@"%c3%96" capitalizedString] withString:@"Ö"]
                                                 stringByReplacingOccurrencesOfString:[@"%c3%9b" capitalizedString] withString:@"Û"]
                                                stringByReplacingOccurrencesOfString:[@"%c3%9c" capitalizedString] withString:@"Ü"]
                                               stringByReplacingOccurrencesOfString:[@"%c3%a0" capitalizedString] withString:@"à"]
                                              stringByReplacingOccurrencesOfString:[@"%c3%a2" capitalizedString] withString:@"â"]
                                             stringByReplacingOccurrencesOfString:[@"%c3%a4" capitalizedString] withString:@"ä"]
                                            stringByReplacingOccurrencesOfString:[@"%c3%a6" capitalizedString] withString:@"æ"]
                                           stringByReplacingOccurrencesOfString:[@"%c3%a7" capitalizedString] withString:@"ç"]
                                          stringByReplacingOccurrencesOfString:[@"%c3%a8" capitalizedString] withString:@"è"]
                                         stringByReplacingOccurrencesOfString:[@"%c3%a9" capitalizedString] withString:@"é"]
                                        stringByReplacingOccurrencesOfString:[@"%c3%af" capitalizedString] withString:@"ï"]
                                       stringByReplacingOccurrencesOfString:[@"%c3%b4" capitalizedString] withString:@"ô"]
                                      stringByReplacingOccurrencesOfString:[@"%c3%b6" capitalizedString] withString:@"ö"]
                                     stringByReplacingOccurrencesOfString:[@"%c3%bb" capitalizedString] withString:@"û"]
                                    stringByReplacingOccurrencesOfString:[@"%c3%bc" capitalizedString] withString:@"ü"]
                                   stringByReplacingOccurrencesOfString:[@"%c3%bf" capitalizedString] withString:@"ÿ"]
                                  stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    return isoEncodedString;
}

/* 编码给定的字符串成Base64 */
+ (NSString *)encodeToBase64:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/* 编码自身成Base64 */
- (NSString *)encodeToBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/* 解码给定的字符串成Base64 */
+ (NSString *)decodeBase64:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/* 解码自身成Base64 */
- (NSString *)decodeBase64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/* 转换自身为开头大写字符串 */
- (NSString *)sentenceCapitalizedString
{
    if(![self length])
    {
        return [NSString string];
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    
    return [uppercase stringByAppendingString:lowercase];
}

/* 返回一个从时间戳人类易读的字符串 */
- (NSString *)dateFromTimestamp
{
    NSString *year = [self substringToIndex:4];
    NSString *month = [[self substringFromIndex:5] substringToIndex:2];
    NSString *day = [[self substringFromIndex:8] substringToIndex:2];
    NSString *hours = [[self substringFromIndex:11] substringToIndex:2];
    NSString *minutes = [[self substringFromIndex:14] substringToIndex:2];
    
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@", day, month, year, hours, minutes];
}

/* 自编码成编码的URL字符串 */
- (NSString *)urlEncode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for(int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        
        if(thisChar == ' ')
        {
            [output appendString:@"+"];
        }
        else if(thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || (thisChar >= 'a' && thisChar <= 'z') || (thisChar >= 'A' && thisChar <= 'Z') || (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}


+ (NSString *)stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}


- (NSString *)ZZLtrimmedString:(NSString *)string
{
    // 去除字符串的特殊字符
    //    NSString *string = @"<f7091300 00000000 830000c4 00002c00 0000c500>";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、<>[]{}#%-*+=_\\|~＜＞$?^?'@#$%^&*()_+'\""];
    NSString*trimmedString = [string stringByTrimmingCharactersInSet:set];
    // 去除字符串的空格
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    return trimmedString;
}



+ (BOOL)ZZLNSStringIsNULL:(NSString *)aStirng
{
    if([aStirng isKindOfClass:[NSNull class]]) return YES;
    if(![aStirng isKindOfClass:[NSString class]]) return YES;
    
    if(aStirng == nil) return YES;
    
    NSUInteger len = aStirng.length;
    if (len <= 0) return YES;
    return NO;
}

+ (BOOL)ZZLurl_isURL:(NSString *)url
{
    if([self ZZLNSStringIsNULL:url]) return NO;
    
    if([url rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES;
    return NO;
}

#pragma mark - *****  数字处理 类
/*! 判断数字为2.1千，3.4万（点赞数处理） */
+ (NSString *)ZZLstringHandleWithString:(NSString *)string
{
    float number = [string integerValue];
    
    NSString *numberString = @"";
    if (number<1000)
    {
        numberString = [NSString stringWithFormat:@"%.0f", number];
    }
    else
        if (number/1000 && number/10000 <1)
        {
            numberString = [NSString stringWithFormat:@"%.1f千", number/1000];
        }
        else
        {
            numberString = [NSString stringWithFormat:@"%.1f万", number/10000];
        }
    
    return numberString;
}

/*! 判断是否为整形 */
- (BOOL)ZZLisPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/*! 判断是否为浮点形 */
- (BOOL)ZZLisPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - *****  特殊字符串处理 类
/*! 去掉字符串中的html标签的方法 */
- (NSString *)ZZLfilterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];    //去掉html里面的空格
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];    //去掉换行
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];  //去掉前后两边空白
    return html;
}

/*! 十六进制转换为普通字符串 */
- (NSString *)ZZLstringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];

    return unicodeString;
}

/*! 获取软件沙盒路径 */
+ (NSString *)ZZLpath_getApplicationSupportPath
{
    //such as:../Applications/9A425424-645E-4337-8730-8A080DF086F4/Library/Application Support
    
    NSArray* libraryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSAllDomainsMask, YES);
    
    NSString *path = nil;
    if ([libraryPaths count] > 0) {
        path = [libraryPaths objectAtIndex:0];
    }
    
    if (![self ZZLpath_fileExist:path]) {
        [self ZZLpath_createDirectory:path];
    }
    
    return path;
}

/*! 获取软件沙盒Documents路径 */
+ (NSString *)ZZLpath_getDocumentsPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    
    //such as:../Applications/9A425424-645E-4337-8730-8A080DF086F4/Documents
    return documentPath;
}

/*! 获取软件沙盒cache路径 */
+ (NSString *)ZZLpath_getCachePath
{
    // such as : ../Applications/9A425424-645E-4337-8730-8A080DF086F4/Library/Caches
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    return cachePath;
}

/*! 获取软件沙盒cachesDic路径 */
+ (NSString *)ZZLpath_getTemPath
{
    NSString *cachesDic = NSTemporaryDirectory();
    return cachesDic;
}

/*! 在软件沙盒指定的路径创建一个目录 */
+ (BOOL)ZZLpath_createDirectory:(NSString *)newDirectory
{
    if([self ZZLpath_fileExist:newDirectory]) return YES;
    
    NSError * error = nil;
    BOOL finished = [[NSFileManager defaultManager] createDirectoryAtPath:newDirectory
                                              withIntermediateDirectories:YES
                                                               attributes:nil
                                                                    error:&error];
    return finished;
}

/*! 在软件沙盒指定的路径删除一个目录 */
+ (BOOL)ZZLpath_deleteFilesysItem:(NSString*)strItem
{
    if ([strItem length] == 0) {
        return YES;
    }
    
    NSError * error = nil;
    
    BOOL finished = [[NSFileManager defaultManager] removeItemAtPath:strItem error:&error];
    return finished;
}

/*! 在软件沙盒路径移动一个目录到另一个目录中 */
+ (BOOL)ZZLpath_moveFilesysItem:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if (![self ZZLpath_fileExist:srcPath]) return NO;
    
    NSError * error = nil;
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath
                                                   toPath:dstPath
                                                    error:&error];
}

/*! 在软件沙盒路径中查看有没有这个路径 */
+ (BOOL)ZZLpath_fileExist:(NSString*)strPath
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    BOOL finded = [file_manager fileExistsAtPath:strPath];
    return finded;
}

/*! 在软件沙盒路径中获取指定userPath路径 */
- (NSString *)ZZLpath_getUserInfoStorePath:(NSString *)userPath
{
    NSString *destPath = [NSString ZZLpath_getDocumentsPath];
    NSString *userInfoPath = [destPath stringByAppendingString:[NSString stringWithFormat:@"/%@", userPath]];
    return userInfoPath;
}


/*! 获取字符串的长度 */
+ (NSUInteger)ZZLgetLengthOfStr:(NSString*)str
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [str dataUsingEncoding:enc];
    return [da length];
}



/*! 特殊字符串处理：改变部分字符串的字体颜色 */
+ (NSMutableAttributedString *)ZZLcreatMutableAttributedString:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(CGFloat)fontSize range:(NSRange)range
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:textColor,NSBackgroundColorAttributeName:bgColor, NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} range:range];
    return attributedStr;
}

/*! 重复字符串N次 */
+ (NSString *)getText:(NSString *)text withRepeat:(int)repeat
{
    NSMutableString *String = [NSMutableString new];
    
    for (int i = 0; i < repeat; i++) {
        [String appendString:text];
    }
    
    return String;
}

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  拨打电话
 *
 *  @param num 电话号码
 */
+ (void)callPhoneWithNum:(NSString *)num
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",num];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


/**
 MD5加密

 @return 返回一个MD5加密的字符串
 */
- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]].lowercaseString;
}

/**
 *  拼些所需图片尺寸
 *
 *  @param height 图片高
 *  @param width 图片宽
 */
- (NSString *)appendImageSringWithHeight:(NSString *)height Width:(NSString *)width
{
    if ([self rangeOfString:@"."].length!=0) {
        NSArray *arr = [self componentsSeparatedByString:@"."];
        
        return [NSString stringWithFormat:@"%@@160_160.%@",arr[0],arr[1]];
    }
    
    return self;

}

- (NSString *)sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


@end

//
//  NSString+Extension.m
//  BXlive
//
//  Created by sweetloser on 2020/5/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
 
+(BOOL)urlValidation:(NSString *)string {
 
    NSError *error;
 
    // 正则1
 
//    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
 
    // 正则2
 
    NSString *regulaStr =@"(http[s]{0,1}://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
 
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
 
                                                                          options:NSRegularExpressionCaseInsensitive
 
                                                                            error:&error];
 
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:match.range];
         NSLog(@"匹配%@",substringForMatch);
        return YES;
    }
 
    return NO;
 
}

+(NSString *)SLNONullorNil:(NSString *)maybe{
    if (!maybe) {
//        是nil
        return @"";
    }
    if ([maybe isKindOfClass:[NSNull class]]) {
//        NSNull
        return @"";
    }
    return maybe;
}

-(NSDictionary *)jsonStringToDictionary{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSArray *)jsonString2Array{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

@end

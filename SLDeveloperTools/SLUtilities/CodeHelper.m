//
//  CodeHelper.m
//  BXlive
//
//  Created by bxlive on 2019/7/30.
//  Copyright © 2019 cat. All rights reserved.
//

#import "CodeHelper.h"

@implementation CodeHelper

//16进制转换成字符串
+ (NSString *)stringFromHexString:(NSString *)hexString {
    if (!hexString.length) {
        return hexString;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for(int i = 0; i < [hexString length] - 1; i += 2){
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

@end

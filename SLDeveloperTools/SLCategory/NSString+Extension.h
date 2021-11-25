//
//  NSString+Extension.h
//  BXlive
//
//  Created by sweetloser on 2020/5/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

+(BOOL)urlValidation:(NSString *)string;
+(NSString *)SLNONullorNil:(NSString *)maybe;

-(NSDictionary *)jsonStringToDictionary;
-(NSArray *)jsonString2Array;

//传入 秒  得到 xx:xx:xx
+(NSString *)sl_HHMMSSFromSSString:(NSString *)totalTime;
+(NSString *)sl_HHMMSSFromSS:(NSTimeInterval)totalTime;
@end

NS_ASSUME_NONNULL_END

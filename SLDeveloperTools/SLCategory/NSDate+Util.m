//
//  NSDate+Util.m
//  iosapp
//
//  Created by AeternChan on 10/15/15.
//  Copyright © 2015 oschina. All rights reserved.
//

#import "NSDate+Util.h"
#import "NSDateFormatter+Singleton.h"


static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";


@implementation NSDate (Util)

+ (instancetype)dateFromString:(NSString *)string
{
    return [[NSDateFormatter sharedInstance] dateFromString:string];
}



@end

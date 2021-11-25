//
//  BXDeluxeGiftTool.h
//  BXlive
//
//  Created by bxlive on 2019/7/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRemainingZipCountNotification   @"RemainingZipCountNotification"

@interface BXDeluxeGiftTool : NSObject

@property (nonatomic, assign) BOOL isDownloading;

@property (nonatomic, assign) NSInteger totalZipCount;
@property (nonatomic, assign) NSInteger remainingZipCount;

+ (BXDeluxeGiftTool *)sharedDeluxeGiftTool;
+ (BOOL)giftIsExistWithGiftId:(NSString *)giftId;
+ (BOOL)giftIsExistInLocationWithGiftId:(NSString *)giftId;
+ (NSString *)getGiftPathWithGiftId:(NSString *)giftId;

+ (void)downloadGiftImages;
+ (void)updatePriorityWithGiftId:(NSString *)giftId;

@end


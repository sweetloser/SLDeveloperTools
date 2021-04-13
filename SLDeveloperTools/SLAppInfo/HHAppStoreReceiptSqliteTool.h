//
//  HHAppStoreReceiptSqliteTool.h
//  BXlive
//
//  Created by bxlive on 2018/10/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAppStoreReceipt.h"

@interface HHAppStoreReceiptSqliteTool : NSObject

+ (void)insertAppStoreReceipt:(HHAppStoreReceipt *)appStoreReceipt;
+ (void)deleteAppStoreReceipt:(HHAppStoreReceipt *)appStoreReceipt;
+ (void)queryAppStoreReceiptsBlock:(void(^)(NSArray *appStoreReceipts))block;

@end

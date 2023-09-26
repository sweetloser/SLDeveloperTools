//
//  KeyChainStore.h
// 
//
//  Created by bxlive on 2017/12/26.
//  Copyright © 2017年 cat. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end



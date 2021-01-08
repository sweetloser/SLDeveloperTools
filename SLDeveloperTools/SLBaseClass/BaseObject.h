//
//  BaseObject.h
//  QianJiHuDong
//
//  Created by lifuyong on 13-9-29.
//  Copyright (c) 2013年 lifuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObject : NSObject <NSCoding>

- (void)updateWithJsonDic:(NSDictionary*)jsonDic;

@end

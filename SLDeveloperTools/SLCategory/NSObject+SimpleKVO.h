//
//  NSObject+SimpleKVO.h
//  BXlive
//
//  Created by bxlive on 2019/8/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SimpleKVO)

- (void)addKVOForPath:(NSString*)path withBlock:(void (^)(id newValue))block;

- (void)removeKVOForPath:(NSString *)path;

- (void)removeAllKVOs;

@end

NS_ASSUME_NONNULL_END

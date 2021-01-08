//
//  NSObject+VariableType.h
//  BXlive
//
//  Created by bxlive on 2018/10/11.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VariableType)

- (BOOL)isString;
- (BOOL)isNumber;
- (BOOL)isArray;
- (BOOL)isDictionary;

@end

//
//  NSObject+PDDCheck.m
//  BXlive
//
//  Created by sweetloser on 2020/6/16.
//  Copyright © 2020 cat. All rights reserved.
//

#import "NSObject+PDDCheck.h"

@implementation NSObject (PDDCheck)

-(BOOL)PDDCheck{
        NSString* scheme =   @"pinduoduo";
        return [[UIApplication   sharedApplication] canOpenURL:[NSURL URLWithString:[NSString   stringWithFormat:@"%@://",scheme]]];
}

@end

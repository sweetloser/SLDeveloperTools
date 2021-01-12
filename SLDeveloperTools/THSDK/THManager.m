//
//  THManager.m
//  BXlive
//
//  Created by sweetloser on 2020/4/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "THManager.h"
//#import "TiSDKInterface.h"
#import <TiSDK/TiSDKInterface.h>
@interface THManager()
@property(nonatomic,strong)TiSDKManager *sdkManager;

@end

@implementation THManager

+(THManager *)shareManager{
    static THManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[THManager alloc] init];
    });
    return manager;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

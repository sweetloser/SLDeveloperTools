//
//  BXBannerModel.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXBannerModel.h"

@implementation BXBannerModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"%@",dict[@"title"]];
        self.imageNormal = [NSString stringWithFormat:@"%@",dict[@"image"][@"common"]];
        self.imageX = [NSString stringWithFormat:@"%@",dict[@"image"][@"iphone2x"]];
        self.url = [NSString stringWithFormat:@"%@",dict[@"url"]];
    }
    return self;
}

+ (instancetype)appInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

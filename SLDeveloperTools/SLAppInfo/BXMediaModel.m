//
//  BXMediaModel.m
//  BXlive
//
//  Created by bxlive on 2019/8/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMediaModel.h"

@implementation BXMediaModel

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    
    NSDictionary *dataDic = jsonDic[@"data"];
    if ([_type isEqualToString:@"live"]) {
        _liveRoom = [[BXSLLiveRoom alloc]init];
        [_liveRoom updateWithJsonDic:dataDic];
    } else {
        _video = [[BXHMovieModel alloc]init];
        [_video updateWithJsonDic:dataDic];
    }
}

@end

//
//  BXShortVideoConfigure.m
//  BXlive
//
//  Created by sweetloser on 2020/4/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXShortVideoConfigure.h"

@implementation BXShortVideoConfigure
-(instancetype)init
{
    self = [super init];
    if (self) {
        _videoRatio = VIDEO_ASPECT_RATIO_9_16;
    }
    return self;
}

@end

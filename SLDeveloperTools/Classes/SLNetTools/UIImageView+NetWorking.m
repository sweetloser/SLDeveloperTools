//
//  UIImageView+NetWorking.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "UIImageView+NetWorking.h"
#import <SDWebImage/SDWebImage.h>
@implementation UIImageView (NetWorking)


-(void)zzl_setImageWithURLString:(NSURL *)urlString placeholder:(UIImage *)placeholder{
    
//    [self yy_setImageWithURL:urlString placeholder:placeholder];
    [self sd_setImageWithURL:urlString placeholderImage:placeholder];
    
}


@end

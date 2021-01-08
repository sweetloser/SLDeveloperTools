//
//  UIImageView+NetWorking.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <UIImageView+YYWebImage.h>
//#import <UIButton+YYWebImage.h>

@interface UIImageView (NetWorking)


/**
 *  设置网络图片，可以设置占位图
 *
 *  @param urlString 图片地址
 */
- (void)zzl_setImageWithURLString:(NSURL *)urlString placeholder:(UIImage *)placeholder;









@end

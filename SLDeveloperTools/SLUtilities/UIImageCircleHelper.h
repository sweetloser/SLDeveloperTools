//
//  UIImageCircleHelper.h
//  BXlive
//
//  Created by bxlive on 2019/5/5.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYWebImage/YYWebImage.h>


@interface UIImageCircleHelper : NSObject





/// 圆角头像的 manager
+ (YYWebImageManager *)avatarImageManagerCornerRadius:(CGFloat)radius
                                          borderWidth:(CGFloat)borderWidth
                                          borderColor:(UIColor *)borderColor;




@end



//
//  BXHHEmoji.h
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseObject.h"

@interface BXHHEmoji : BaseObject

@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *image;

+ (UIImage *)imageWithEmojiString:(NSString *)emojiString;

@end

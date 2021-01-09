//
//  NSAttributedString+DSText.h
//  BXlive
//
//  Created by bxlive on 2019/5/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (DSText)

+ (NSMutableAttributedString *)ds_attachmentStringWithEmojiImage:(UIImage *)image
                                                        fontSize:(NSInteger)fontSize;

@end

NS_ASSUME_NONNULL_END

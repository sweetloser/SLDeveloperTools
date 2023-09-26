//
//  NSAttributedString+DSText.m
//  BXlive
//
//  Created by bxlive on 2019/5/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import "NSAttributedString+DSText.h"
#import <YYText/YYText.h>
@implementation NSAttributedString (DSText)

+ (NSMutableAttributedString *)ds_attachmentStringWithEmojiImage:(UIImage *)image
                                                  fontSize:(NSInteger)fontSize {
    if (!image) return nil;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize attachmentSize = CGSizeMake(font.lineHeight, font.lineHeight);
    
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat yOffset = font.ascender - fontHeight * 0.5;
    
    CGFloat ascent = attachmentSize.height * 0.5 + yOffset;
    CGFloat descent = attachmentSize.height - ascent;
    if (descent < 0) {
        descent = 0;
        ascent = attachmentSize.height;
    }

    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.content = image;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

@end

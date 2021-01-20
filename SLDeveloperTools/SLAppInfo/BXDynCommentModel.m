//
//  BXDynCommentModel.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCommentModel.h"
#import "BXHHEmoji.h"
#import "../SLCategory/SLCategory.h"
#import <YYText/YYText.h>
#import "../SLMacro/SLMacro.h"
#import <YYCategories/YYCategories.h>
//#import "BXPersonHomeVC.h"
#import "NSAttributedString+DSText.h"
@implementation BXDynCommentModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"contentid":@"id"};
}
-(void)updateWithJsonDic:(NSDictionary *)jsonDic{
    [super updateWithJsonDic:jsonDic];
    _contentid = jsonDic[@"id"];
    if (jsonDic[@"userdetail"] && [jsonDic[@"userdetail"] isDictionary]) {
        NSDictionary *dic = jsonDic[@"userdetail"];
        _user_id = dic[@"user_id"];
        _nickname = dic[@"nickname"];
        _avatar = dic[@"avatar"];
    }
    if (jsonDic[@"touserdetail"] && [jsonDic[@"touserdetail"] isDictionary]) {
        NSDictionary *dic = jsonDic[@"touserdetail"];
        _reply_user_id = dic[@"user_id"];
        _reply_nickname = dic[@"nickname"];
        _reply_avatar = dic[@"avatar"];
    }
    
//    NSString *contentstring = @"";
//    if (self.reply_user_id && ![[NSString stringWithFormat:@"%@", self.reply_user_id] isEqualToString:@""]) {
//        contentstring = [NSString stringWithFormat:@"%@ 回复 %@: %@", self.nickname, self.reply_nickname, self.content];
//    }else{
//
//        if (self.user_id && ![[NSString stringWithFormat:@"%@", self.user_id]isEqualToString:@""]) {
//            contentstring = [NSString stringWithFormat:@"%@:%@", self.nickname, self.content];
//        }else{
//            contentstring = jsonDic[@"content"];
//        }
//    }
    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:jsonDic[@"content"]];
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentstring];
//    attrString.yy_font  = CFont(14);
//    self.headerHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH- 58 - 40];
//    [self processAttributedStringWithIsChild:YES];
}

- (void)processAttributedString{
    WS(weakSelf);
    if (!_DetailChildattatties) {
        UIColor *foregroundColor = [UIColor blackColor];
        NSMutableAttributedString *replyAttri = nil;
        if (self.reply_user_id && ![[NSString stringWithFormat:@"%@", self.reply_user_id] isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"回复 %@: ", self.reply_nickname];
            replyAttri = [[NSMutableAttributedString alloc] initWithString:string];
            replyAttri.yy_font  = SLBFont(14);
            [replyAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
            [replyAttri yy_setTextHighlightRange:NSMakeRange(3, self.reply_nickname.length) color:[UIColor blackColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [weakSelf userDetail:weakSelf.reply_user_id];
            }];
        }

        
        NSString *string = [NSString stringWithFormat:@"%@",self.content];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        attrString.yy_font  = CFont(14);
        [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
        
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[BXDynCommentModel regexEmoticon] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        NSUInteger emoClipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= emoClipLength;
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
            if ([attrString yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [attrString.string substringWithRange:range];
            UIImage *image = [BXHHEmoji imageWithEmojiString:emoString];
            if (!image) continue;
            NSMutableAttributedString *emoText = [NSAttributedString ds_attachmentStringWithEmojiImage:image fontSize:14];
            [attrString replaceCharactersInRange:range withAttributedString:emoText];
            emoClipLength += range.length - 1;
        }
        
        if (replyAttri) {
            [replyAttri appendAttributedString:attrString];
        } else {
            replyAttri = attrString;
        }
        attrString = replyAttri;
        attrString.yy_lineSpacing = 3;
        self.DetailChildattatties  = attrString;
        self.ChildheaderHeight = [self getAttributedTextHeightWithAttributedText:attrString width:__kWidth- 116];
    }
}
- (void)processAttributedStringWithIsChild:(BOOL)isChild {
    WS(weakSelf);
    [self processAttributedString];
    if (!_attatties) {
        UIColor *foregroundColor = [UIColor blackColor];
        NSMutableAttributedString *replyAttri = nil;
        if (self.reply_user_id && ![[NSString stringWithFormat:@"%@", self.reply_user_id] isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"%@ 回复 %@: ", self.nickname, self.reply_nickname];
            replyAttri = [[NSMutableAttributedString alloc] initWithString:string];
            replyAttri.yy_font  = SLBFont(14);
            [replyAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
            [replyAttri yy_setTextHighlightRange:NSMakeRange(0, self.nickname.length) color:[UIColor blackColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [weakSelf userDetail:weakSelf.user_id];
            }];
            [replyAttri yy_setTextHighlightRange:NSMakeRange(self.nickname.length + 4, self.reply_nickname.length) color:[UIColor blackColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [weakSelf userDetail:weakSelf.reply_user_id];
            }];
        }else{
  
            if (isChild && self.user_id && ![[NSString stringWithFormat:@"%@", self.user_id]isEqualToString:@""]) {
                
                NSString *string = [NSString stringWithFormat:@"%@: ", self.nickname];
                replyAttri = [[NSMutableAttributedString alloc] initWithString:string];
                replyAttri.yy_font  = SLBFont(14);
                [replyAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
                [replyAttri yy_setTextHighlightRange:NSMakeRange(0, self.nickname.length) color:[UIColor blackColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [weakSelf userDetail:weakSelf.user_id];
                }];
            }
        }
        
        NSString *string = [NSString stringWithFormat:@"%@",self.content];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        attrString.yy_font  = CFont(14);
        [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:UIColorHex(A8AFAF) range:NSMakeRange(self.content.length, string.length - self.content.length)];
//        [attrString addAttribute:NSFontAttributeName value:CFont(13) range:NSMakeRange(self.content.length, string.length - self.content.length)];
        
//        for (BXLiveUser *liveUser in self.friend_group) {
//            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
//            NSArray *rangeLocations = [self getRangeLocationsWithText:string subText:nickname];
//            for (NSNumber *rangeLocation in rangeLocations) {
//                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
//                NSLog(@"%ld,%ld",[rangeLocation integerValue],nickname.length);
//                [attrString yy_setTextHighlightRange:range color:ContentHighlightColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                    [ws userDetail:liveUser.user_id];
//                }];
//            }
//        }
        
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[BXDynCommentModel regexEmoticon] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
        NSUInteger emoClipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= emoClipLength;
            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
            if ([attrString yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [attrString.string substringWithRange:range];
            UIImage *image = [BXHHEmoji imageWithEmojiString:emoString];
            if (!image) continue;
            NSMutableAttributedString *emoText = [NSAttributedString ds_attachmentStringWithEmojiImage:image fontSize:14];
            [attrString replaceCharactersInRange:range withAttributedString:emoText];
            emoClipLength += range.length - 1;
        }
        
        if (replyAttri) {
            [replyAttri appendAttributedString:attrString];
        } else {
            replyAttri = attrString;
        }
        attrString = replyAttri;
        attrString.yy_lineSpacing = 3;
        self.attatties  = attrString;
//        self.content = [NSString stringWithFormat:@"%@", attrString];
        
        if (isChild) {

            self.headerHeight = [self getAttributedTextHeightWithAttributedText:attrString width:__kWidth- 116];
        } else {
            self.headerHeight = [self getAttributedTextHeightWithAttributedText:attrString width:__kWidth- 116];
        }
    }
}
- (void)userDetail:(NSString *)userId {
    if (_toPersonHome) {
        _toPersonHome(userId);
    }
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}
- (NSMutableArray *)getRangeLocationsWithText:(NSString *)text subText:(NSString *)subText {
    NSMutableArray *rangeLocations=[NSMutableArray new];
    NSArray *array=[text componentsSeparatedByString:subText];
    NSInteger d = 0;
    for (NSInteger i = 0; i<array.count-1; i++) {
        NSString *string = array[i];
        NSNumber *number = @(d += string.length);
        d += subText.length;
        [rangeLocations addObject:number];
    }
    return rangeLocations;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}


@end

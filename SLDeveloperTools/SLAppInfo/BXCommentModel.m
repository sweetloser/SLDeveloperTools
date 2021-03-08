//
//  BXCommentModel.m
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXCommentModel.h"
#import "BXHHEmoji.h"
#import "NSAttributedString+DSText.h"
#import "BXLiveUser.h"
#import "../SLMacro/SLMacro.h"
#import <YYText/YYText.h>
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoMacro.h"

@implementation BXCommentModel

-(NSMutableArray *)childCommentArray{
    if (_childCommentArray==nil) {
        _childCommentArray = [NSMutableArray array];
    }
    return _childCommentArray;
}

-(NSMutableArray *)friend_group{
    if (_friend_group==nil) {
        _friend_group = [NSMutableArray array];
    }
    return _friend_group;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.user_id = dict[@"user_id"];
        self.comment_id = dict[@"comment_id"];
        self.avatar = dict[@"avatar"];
        self.nickname = dict[@"nickname"];
        self.content = dict[@"content"];
        self.publish_time = dict[@"publish_time"];
        self.is_anchor = dict[@"is_anchor"];
        self.is_like = dict[@"is_like"];
        self.like_count = dict[@"like_count"];
        self.reply_count = dict[@"reply_count"];
        self.reply_count_str = dict[@"reply_count_str"];
        NSArray *friends = dict[@"friend_group"];
        if (friends && friends.count) {
            for (NSDictionary *dic in friends) {
                BXLiveUser *liveUser = [[BXLiveUser alloc]init];
                liveUser.user_id = dic[@"user_id"];
                liveUser.nickname = dic[@"nickname"];
                [self.friend_group addObject:liveUser];
            }
        }
        self.is_reply = dict[@"is_reply"];
        self.reply_uid = dict[@"reply_uid"];
        self.reply_nickname = dict[@"reply_nickname"];
        
        WS(ws);
        for (NSDictionary *childDic in dict[@"child_list"] ) {
            BXCommentModel *model = [[BXCommentModel alloc]initWithDict:childDic];
            model.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws userDetail:userId];
            };
            [self.childCommentArray addObject:model];
        }
    }
    return self;
}

- (void)processAttributedStringWithIsChild:(BOOL)isChild {
    if (!_attatties) {
        WS(ws);
        
        for (BXCommentModel *model in self.childCommentArray) {
            [model processAttributedStringWithIsChild:YES];
        }
        
        UIColor *foregroundColor = MainTitleColor;
        NSMutableAttributedString *replyAttri = nil;
        if (isChild && [self.is_reply integerValue] == 1) {
            NSString *string = [NSString stringWithFormat:@"回复 %@ :  ",self.reply_nickname];
            replyAttri = [[NSMutableAttributedString alloc] initWithString:string];
            replyAttri.yy_font  = CFont(15);
            [replyAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
            [replyAttri yy_setTextHighlightRange:NSMakeRange(3, self.reply_nickname.length) color:SubTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [ws userDetail:ws.reply_uid];
            }];
        }
        
        NSString *string = [NSString stringWithFormat:@"%@   %@",self.content,self.publish_time];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        attrString.yy_font  = CFont(15);
        [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor sl_colorWithHex:0xA8AFAF] range:NSMakeRange(self.content.length, string.length - self.content.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor sl_colorWithHex:0xA8AFAF] range:NSMakeRange(self.content.length, string.length - self.content.length)];
        [attrString addAttribute:NSFontAttributeName value:CFont(13) range:NSMakeRange(self.content.length, string.length - self.content.length)];
        
        for (BXLiveUser *liveUser in self.friend_group) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:string subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                NSLog(@"%ld,%ld",[rangeLocation integerValue],nickname.length);
                [attrString yy_setTextHighlightRange:range color:ContentHighlightColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[BXCommentModel regexEmoticon] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
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
            NSMutableAttributedString *emoText = [NSAttributedString ds_attachmentStringWithEmojiImage:image fontSize:15];
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
        
        if (isChild) {
            self.rowHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH-141] +35;
        } else {
            self.headerHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH-110] +45;
        }
    }
}

-(void)processAttributedStringWithAttaties{
    WS(ws);
        UIColor *foregroundColor = sl_textSubColors;
    if ([self.nickname isKindOfClass:[NSNull class]]) {
         return;
     }
        NSMutableAttributedString *replyAttri = [[NSMutableAttributedString alloc] initWithString:self.nickname];
        replyAttri.yy_font  = CBFont(15);
        [replyAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, replyAttri.length)];
    [replyAttri yy_setTextHighlightRange:[[replyAttri string] rangeOfString:self.nickname] color:_isAttention ?sl_blacktextColors : MainTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [ws userDetail:ws.user_id];
        }];

        if ([_is_anchor integerValue]) {
            [replyAttri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            UIImage *autoImage = CImage(@"icon_attention_auto");
            NSMutableAttributedString *attachAttri = [NSMutableAttributedString yy_attachmentStringWithContent:autoImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:autoImage.size alignToFont:CFont(15) alignment:YYTextVerticalAlignmentCenter];
            [replyAttri appendAttributedString:attachAttri];
            [replyAttri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
    
        if ( [_is_reply integerValue] == 1) {
            NSString *string = [NSString stringWithFormat:@"回复 %@ :  ",self.reply_nickname];
            NSMutableAttributedString *attachAttri =[[NSMutableAttributedString alloc] initWithString:string];
            attachAttri.yy_font  = CBFont(15);
            [attachAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
            [replyAttri yy_setTextHighlightRange:[[replyAttri string] rangeOfString:self.reply_nickname] color:_isAttention ?sl_blacktextColors : MainTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [ws userDetail:ws.reply_uid];
            }];
            [replyAttri appendAttributedString:attachAttri];
        }else{
            NSString *string = @" : ";
            NSMutableAttributedString *attachAttri =[[NSMutableAttributedString alloc] initWithString:string];
            attachAttri.yy_font  = CFont(15);
            [attachAttri addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
            [replyAttri appendAttributedString:attachAttri];
        }
        
        NSString *string = [NSString stringWithFormat:@"%@   ",self.content];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        attrString.yy_font  = CFont(15);
        [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
    
    
        for (BXLiveUser *liveUser in self.friend_group) {
            NSString *nickname = [NSString stringWithFormat:@"@%@ ",liveUser.nickname];
            NSArray *rangeLocations = [self getRangeLocationsWithText:string subText:nickname];
            for (NSNumber *rangeLocation in rangeLocations) {
                NSRange range = NSMakeRange([rangeLocation integerValue], nickname.length);
                [attrString yy_setFont:CBFont(15) range:range];
                [attrString yy_setTextHighlightRange:range color:ContentHighlightColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [ws userDetail:liveUser.user_id];
                }];
            }
        }
        
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[BXCommentModel regexEmoticon] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
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
            NSMutableAttributedString *emoText = [NSAttributedString ds_attachmentStringWithEmojiImage:image fontSize:15];
            [attrString replaceCharactersInRange:range withAttributedString:emoText];
            emoClipLength += range.length - 1;
        }
        [replyAttri appendAttributedString:attrString];
         replyAttri.yy_lineSpacing = 4;
    

        self.attentionAttatties  = replyAttri;
        self.attentionHight = [self getAttributedTextHeightWithAttributedText:replyAttri width:SCREEN_WIDTH-58];
}



- (void)userDetail:(NSString *)userId {
    if (_toPersonHome) {
        _toPersonHome(userId);
    }
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

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
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

//
//  BXDynMsgDetailModel.m
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynMsgDetailModel.h"
#import "BXHHEmoji.h"
#import "NSAttributedString+DSText.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <YYText/YYText.h>
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
#import <YYCategories/YYCategories.h>
@implementation BXDynMsgDetailModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"dynID":@"id",@"issueType":@"type"};
}
- (instancetype)init {
    if ([super init]) {
//        _privatemsg = [NSMutableArray array];
        _titleArray = [NSMutableArray array];
        _imgs_detail = [NSMutableArray array];
        _extend_circledetailArray = [NSMutableArray array];
        _circle_recomedArray = [NSMutableArray array];
        _systemplusArray = [NSMutableArray array];
        _privatemsg = [NSMutableArray array];
        _privateDic = [NSMutableDictionary dictionary];
        _AiTeFriendmsg = [NSMutableArray array];
        _picture_long = [NSMutableArray array];
        _sysModel = [[BXdynSystemplusModel alloc]init];
    }
    return self;
}

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _dynID = jsonDic[@"id"];
    _issueType = jsonDic[@"type"];
    
    
    _usermsg = jsonDic[@"usermsg"];
    if (_usermsg && [_usermsg isDictionary]) {
        _user_id = _usermsg[@"user_id"];
        _avatar = _usermsg[@"avatar"];
        _nickname = _usermsg[@"nickname"];
        _gender = _usermsg[@"gender"];
        _liveuserModel = [[BXLiveUser alloc]init];
        [_liveuserModel updateWithJsonDic:_usermsg];
    }
    
    _privateDic = jsonDic[@"privatemsg"];
    if (_privateDic && [_privateDic isDictionary]) {
        _friend_user_id = _privateDic[@"user_id"];
        _friend_avatar = _privateDic[@"avatar"];
        _friend_nickname = _privateDic[@"nickname"];
        _friend_gender = _privateDic[@"gender"];
    }
    
    NSArray *cirdetail = jsonDic[@"extend_circledetail"];
    if (cirdetail && [cirdetail isArray]) {
        for (NSDictionary *dic in cirdetail) {
            _circle_recModel = [[BXDynCircleModel alloc]init];
            [_circle_recModel updateWithJsonDic:dic];
            [_extend_circledetailArray addObject:_circle_recModel];
            
        }
    }
    
    NSArray *titleArray = jsonDic[@"title"];
    if (titleArray && [titleArray isArray]) {
        for (NSDictionary *dic in titleArray) {
            _topic_model = [[BXDynTopicModel alloc]init];
            _topic_model.topic_id = dic[@"topic_id"];
            _topic_model.topic_name = dic[@"topic_name"];
            [_titleArray addObject:_topic_model];
        }
    }
    NSArray *circle_reco= jsonDic[@"circle_recomed"];
    if (circle_reco && [circle_reco isArray]) {
        for (NSDictionary *dic in circle_reco) {
            _circle_recModel = [[BXDynCircleModel alloc]init];
            [_circle_recModel updateWithJsonDic:dic];
            [_circle_recomedArray addObject:_circle_recModel];
            
        }
      }
    NSArray * msgdetailArray = jsonDic[@"imgs_detail"];
    if (msgdetailArray && [msgdetailArray isArray]) {
        _imgs_detail = [NSMutableArray arrayWithArray:msgdetailArray];
    }
//    NSArray *recommendsArray = dataDic[@"recommends"];
//    if (recommendsArray && [recommendsArray isArray]) {
//        for (NSDictionary *dic in recommendsArray) {
//            BXHMovieModel *video = [[BXHMovieModel alloc]init];
//            [video updateWithJsonDic:dic];
//            [self.videos addObject:video];
//        }
//    }
    NSDictionary *dic = jsonDic[@"systemplus"];
    if (dic && [dic isDictionary]) {
        _sysModel = [[BXdynSystemplusModel alloc]init];
        [_sysModel updateWithJsonDic:dic];
    }
    NSDictionary *movie_dic = jsonDic[@"small_video"];
    if (movie_dic && [movie_dic isDictionary]) {
        _MovieModel = [BXHMovieModel new];
        [_MovieModel updateWithJsonDic:movie_dic];
    }
    
 
    
}

- (void)processAttributedString{
    if ([_imgs_detail isArray] && _imgs_detail.count) {
        for (int i = 0; i < _imgs_detail.count; i++) {
            CGFloat width = [[_imgs_detail[i] objectForKey:@"width"] floatValue];
            CGFloat height = [[_imgs_detail[i] objectForKey:@"height"] floatValue];
            if ( height > width && (height / width > __kHeight / __kWidth)) {
                [_picture_long addObject:@"1"];
            }else{
                [_picture_long addObject:@"0"];
            }
        }
    }
    
    
    if (!_attatties) {
        UIColor *foregroundColor = [UIColor blackColor];

        NSString *string = self.content;
        if (IsNilString(string)) {
            return;
        }
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        attrString = [self getAttributedStringWithLineSpace:string lineSpace:5 kern:0.1];
        attrString.yy_font  = CFont(16);
        attrString.yy_color = [UIColor colorWithColor:[UIColor blackColor] alpha:0.6];
        [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, string.length)];
        
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[BXDynMsgDetailModel regexEmoticon] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
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
            NSMutableAttributedString *emoText = [NSAttributedString ds_attachmentStringWithEmojiImage:image fontSize:16];
            [attrString replaceCharactersInRange:range withAttributedString:emoText];
            emoClipLength += range.length - 1;
        }
        
        // 匹配 @
//        NSArray<NSTextCheckingResult *> *AiteResults = [[BXDynMsgDetailModel regexAite] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
//        for (NSTextCheckingResult *at in AiteResults) {
//
//            if (at.range.location == NSNotFound && at.range.length <= 1)
//            {
//                continue;
//            }
//
//            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil)
//            {
//                [attrString yy_setColor:UIColorHex(#91B8F4) range:at.range];
//                NSString *atName = [attrString.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)];
//                NSMutableAttributedString *aiteText = [[NSMutableAttributedString alloc] initWithString:atName];
//                [aiteText yy_setTextHighlightRange:NSMakeRange(0, atName.length - 1) color:SubTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                    [weakSelf toPersonHome:atName index:0];
//                }];
//
//                aiteText.yy_font  = CFont(15);
//                aiteText.yy_color = UIColorHex(#91B8F4);
//                NSRange atrange = NSMakeRange(at.range.location + 1, at.range.length - 1);
//                [attrString replaceCharactersInRange:atrange withAttributedString:aiteText];
//            }
//        }

        if (self.privatemsg && [self.privatemsg isArray]) {
            for (int i = 0; i<self.privatemsg.count; i++) {
                NSRange range;
                if ([attrString.string isKindOfClass:[NSNull class]]) {
                     return;
                 }
                if ([attrString.string containsString:[self.privatemsg[i] objectForKey:@"nickname"]]) {
                    range = [attrString.string rangeOfString:[self.privatemsg[i] objectForKey:@"nickname"]];
                    if (range.location != NSNotFound ){
                        NSString *atName = [attrString.string substringWithRange:NSMakeRange(range.location - 1, range.length + 1)];
                        NSMutableAttributedString *aiteText = [[NSMutableAttributedString alloc] initWithString:atName];
                        [aiteText yy_setTextHighlightRange:NSMakeRange(0, atName.length) color:SubTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":[self.privatemsg[i] objectForKey:@"user_id"],@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
                            
//                            [BXPersonHomeVC toPersonHomeWithUserId:[self.privatemsg[i] objectForKey:@"user_id"] isShow:nil nav:[[UIApplication sharedApplication] activityViewController].navigationController handle:nil];
                        }];

                        aiteText.yy_font  = CFont(16);
                        aiteText.yy_color = [UIColor sl_colorWithHex:0x91B8F4];
                        NSRange atrange = NSMakeRange(range.location - 1, range.length + 1);
                        [attrString replaceCharactersInRange:atrange withAttributedString:aiteText];
                    }
                }

            }
        }
        
        //匹配#话题#
        
//        NSArray<NSTextCheckingResult *> *TopicResults = [[BXDynMsgDetailModel regexTopic] matchesInString:attrString.string options:kNilOptions range:attrString.yy_rangeOfAll];
//
//        for (NSTextCheckingResult *topic in TopicResults)
//        {
//            if (topic.range.location == NSNotFound && topic.range.length <= 1)
//            {
//                continue;
//            }
//            if ([attrString yy_attribute:YYTextHighlightAttributeName atIndex:topic.range.location] == nil)
//            {
//                [attrString yy_setColor:UIColorHex(#91B8F4) range:topic.range];
//                NSString *topicName = [attrString.string substringWithRange:NSMakeRange(topic.range.location, topic.range.length - 1)];
//                NSMutableAttributedString *topicText = [[NSMutableAttributedString alloc] initWithString:topicName];
//                [topicText yy_setTextHighlightRange:NSMakeRange(0, topicName.length - 1) color:SubTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                    [weakSelf toTopicHome:topicName index:0];
//                }];
//                topicText.yy_font  = CFont(15);
//                topicText.yy_color = UIColorHex(#91B8F4);
//                NSRange topicrange = NSMakeRange(topic.range.location, topic.range.length - 1);
//                [attrString replaceCharactersInRange:topicrange withAttributedString:topicText];
//
//            }
//        }
        
        if (self.titleArray && [self.titleArray isArray]) {
            WS(weakSelf);
             for (int i = 0; i<self.titleArray.count; i++) {
                 NSRange range;
                 if ([[self.titleArray[i] topic_name] isKindOfClass:[NSNull class]]) {
                     return;
                 }
                 if ([attrString.string containsString:[NSString stringWithFormat:@"#%@#",[self.titleArray[i] topic_name]]]) {
                     range = [attrString.string rangeOfString:[NSString stringWithFormat:@"#%@#",[self.titleArray[i] topic_name]]];
                     if (range.location != NSNotFound ){
                         NSString *atName = [attrString.string substringWithRange:NSMakeRange(range.location, range.length)];
                         NSMutableAttributedString *aiteText = [[NSMutableAttributedString alloc] initWithString:atName];
                         [aiteText yy_setTextHighlightRange:NSMakeRange(0, atName.length) color:SubTitleColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             if (weakSelf.goToTopic) {
                                 weakSelf.goToTopic([NSString stringWithFormat:@"%@", [weakSelf.titleArray[i] topic_id]]);
                                 return;
                             }
                             
                             void(^didClickTopic)(BXDynTopicModel * _Nonnull bmodel) = ^(BXDynTopicModel * _Nonnull model) {};
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2TopicCategory object:nil userInfo:@{@"model":self.titleArray[i],@"DidClickTopic":didClickTopic}];
                         }];

                         aiteText.yy_font  = CFont(16);
                         aiteText.yy_color = [UIColor sl_colorWithHex:0x91B8F4];
                         NSRange atrange = NSMakeRange(range.location , range.length );
                         [attrString replaceCharactersInRange:atrange withAttributedString:aiteText];
                     }
                 }

             }
         }
        self.attatties  = attrString;
        self.contentHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH- 116];
        self.dyncontentHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH- 24];
        self.PersondyncontentHeight = [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH- 48];
    }
}
- (void)toPersonHome:(NSString *)user_name index:(NSInteger)index{
    user_name = [user_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.privatemsg && [self.privatemsg isArray]) {
        for (int i = 0; i<self.privatemsg.count; i++) {
            
            if ([user_name isEqualToString:[self.privatemsg[i] objectForKey:@"nickname"]]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":[self.privatemsg[i] objectForKey:@"user_id"],@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
                break;
            }
        }
    }
}
- (void)toTopicHome:(NSString *)topic_name index:(NSInteger)index{
    topic_name = [topic_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    topic_name = [topic_name stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (self.titleArray && [self.titleArray isArray]) {
        for (int i = 0; i<self.titleArray.count; i++) {
            
            if ([topic_name isEqualToString:[self.titleArray[i] topic_name]]) {
                
                void(^didClickTopic)(BXDynTopicModel * _Nonnull bmodel) = ^(BXDynTopicModel * _Nonnull model) {};
                [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2TopicCategory object:nil userInfo:@{@"model":self.titleArray[i],@"DidClickTopic":didClickTopic}];
                
                break;
            }
        }
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

+ (NSRegularExpression *)regexAite {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ " options:kNilOptions error:NULL];
    });
    return regex;
}
+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#.*?# " options:kNilOptions error:NULL];
    });
    return regex;
}

- (NSArray<NSTextCheckingResult *> *)atAll
{
    // 找到文本中所有的@
    NSString *string = self.content;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
- (NSArray<NSTextCheckingResult *> *)AllTopic
{
    // 找到文本中所有的##
    NSString *string = self.content;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#.*?#"  options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

+ (NSString *)matchRegularExpress:(NSString *)regularExpress andDesString:(NSString *)desString
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"@%@.*?", regularExpress] options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:desString options:0 range:NSMakeRange(0, [desString length])];
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[desString substringWithRange:resultRange];
            return result;
        }
    }
    return nil;
}
-(NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace; //设置行间距
    paragraphStyle.firstLineHeadIndent = 0;//设置第一行缩进
    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
    
    return attributedString;
}
@end

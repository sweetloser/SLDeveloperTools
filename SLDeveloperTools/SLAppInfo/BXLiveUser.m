//
//  BXLiveUser.m
//  BXlive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "BXLiveUser.h"
#import "MJExtension.h"
#import <UMPush/UMessage.h>
#import "../SLUtilities/CacheHelper.h"
#import "../SLMacro/SLMacro.h"
#import <YYText/YYText.h>
#import "SLAppInfoMacro.h"

static NSString *const kCurrentBXLiveUser = @"CurrentBXLiveUser";

@implementation BXLiveUser

MJCodingImplementation

+ (BOOL)isLogin {
    BOOL isLogin = YES;
    BXLiveUser *liveUser = [BXLiveUser currentBXLiveUser];
    if ([liveUser.user_id isEqualToString:@"-999"]) {
        isLogin = NO;
    }
    return isLogin;
}
- (void)updateWithJsonDic:(NSDictionary *)jsonDic{
    [super updateWithJsonDic:jsonDic];
    [self GetAccountSignContentHeight];
}
+ (BXLiveUser *)currentBXLiveUser {
    BXLiveUser * liveUser = (BXLiveUser *)[CacheHelper objectForKey:kCurrentBXLiveUser];
    if (!liveUser) {
        liveUser = [[BXLiveUser alloc]init];
        liveUser.user_id = @"-999";
        [CacheHelper setObject:liveUser forKey:kCurrentBXLiveUser];
    }
    return liveUser;
}

+ (void)setCurrentBXLiveUser:(BXLiveUser *)liveUser {
    [CacheHelper setObject:liveUser forKey:kCurrentBXLiveUser];
    if ([liveUser.user_id isEqualToString:@"-999"]) {
        NSArray *tags = @[@"login:1",@"login:0"];
        [UMessage deleteTags:[NSSet setWithArray:tags] response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
            [UMessage addTags:[NSSet setWithArray:@[@"login:0"]] response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
        }];
    } else {
        [UMessage addAlias:liveUser.user_id type:@"user_id" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
            
        }];
        [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nonnull error) {
            if (!error) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF BEGINSWITH 'int')"];
                NSSet *tempTags = [responseTags filteredSetUsingPredicate:predicate];
                [UMessage deleteTags:tempTags response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                    NSString *follow_push = [NSString stringWithFormat:@"follow_push:%@",[self changeNum:liveUser.follow_push]];
                    NSString *follow_live_push = [NSString stringWithFormat:@"follow_live_push:%@",[self changeNum:liveUser.follow_live_push]];
                    NSString *msg_push = [NSString stringWithFormat:@"msg_push:%@",[self changeNum:liveUser.msg_push]];
                    NSString *like_push = [NSString stringWithFormat:@"like_push:%@",[self changeNum:liveUser.like_push]];
                    NSString *recommend_push = [NSString stringWithFormat:@"recommend_push:%@",[self changeNum:liveUser.recommend_push]];
                    NSString *comment_push = [NSString stringWithFormat:@"comment_push:%@",[self changeNum:liveUser.comment_push]];
                    NSString *follow_new_push = [NSString stringWithFormat:@"follow_new_push:%@",[self changeNum:liveUser.follow_new_push]];
                    NSString *gender = [NSString stringWithFormat:@"gender:%@",[self changeNum:liveUser.gender]];
                    NSString *vip = [NSString stringWithFormat:@"vip:%@",[self changeNum:liveUser.vip_status]];
                    NSArray *tags = @[follow_push,follow_live_push,msg_push,like_push,recommend_push,comment_push,follow_new_push,gender,vip,@"login:1"];
                    [UMessage addTags:[NSSet setWithArray:tags] response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                        
                    }];
                }];
            }
        }];
    }
}

+ (NSString *)changeNum:(NSString *)num {
    if (!num || !num.length) {
        return @"0";
    }
    return num;
}

-(void)GetAccountSignContentHeight{
    if (IsNilString(_sign)) {
        _sign = @"";
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_sign];
    attrString.yy_font  = SLPFFont(14);
    _AccountSignContentHeight =  [self getAttributedTextHeightWithAttributedText:attrString width:SCREEN_WIDTH- 100];
}
- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}
@end

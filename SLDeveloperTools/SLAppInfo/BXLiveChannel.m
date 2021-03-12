//
//  BXLiveChannel.m
//  BXlive
//
//  Created by bxlive on 2018/4/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXLiveChannel.h"
#import <YYText/YYText.h>
#import <YYCategories/YYCategories.h>
#import <SLMacro.h>
@implementation BXLiveChannel

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _channelId =  jsonDic[@"id"];
    _descriptions = jsonDic[@"description"];
}


- (NSAttributedString *)attatties {
    if (!_attatties) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *msgcontent = [[NSMutableAttributedString alloc] initWithString:_msgContent];
        [attribute yy_setAttribute:NSForegroundColorAttributeName
                             value:UIColorHex(333333)
                             range:attribute.yy_rangeOfAll];
        [attribute addAttribute:NSFontAttributeName value:CFont(14) range:attribute.yy_rangeOfAll];
        [attribute appendAttributedString:msgcontent];
        _attatties  = [attribute copy];
    }
    return _attatties;
}

@end

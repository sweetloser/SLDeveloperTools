//
//  SLToolsSearchKeywordCell.m
//  BXlive
//
//  Created by sweetloser on 2020/11/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLToolsSearchKeywordCell.h"
#import "SLCategory.h"
#import "SLMacro.h"
#import <Masonry/Masonry.h>

@interface SLToolsSearchKeywordCell()

@end

@implementation SLToolsSearchKeywordCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _keywordLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLPFFont(__ScaleWidth(12)) TextColor:[UIColor colorWithHex:0x3F3F3F]];
        [self.contentView addSubview:_keywordLabel];
        [_keywordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(__ScaleWidth(15));
            make.right.mas_equalTo(__ScaleWidth(-15));
        }];
        _keywordLabel.textAlignment = NSTextAlignmentCenter;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2.0f;
        self.backgroundColor = sl_subBGColors;
        
    }
    return self;
}

@end

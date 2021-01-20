//
//  SLSearchHistoryCollectionViewCell.m
//  BXlive
//
//  Created by sweetloser on 2020/7/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLSearchHistoryCollectionViewCell.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"

@interface SLSearchHistoryCollectionViewCell()

@property(nonatomic,strong)UILabel *historyLabel;

@end

@implementation SLSearchHistoryCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _historyLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLPFFont(12) TextColor:[UIColor sl_colorWithHex:0x3F3F3F]];
        
        [self addSubview:_historyLabel];
        
        [_historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.right.mas_equalTo(0);
        }];
        
        _historyLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
        
        self.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = __ScaleWidth(15);
    }
    
    return self;
}

-(void)setHistoryString:(NSString *)str{
    _historyLabel.text = str;
}

@end

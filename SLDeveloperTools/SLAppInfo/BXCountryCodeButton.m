//
//  BXCountryCodeButton.m
//  BXlive
//
//  Created by bxlive on 2019/3/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXCountryCodeButton.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>

@interface BXCountryCodeButton ()

@property (nonatomic, strong) UILabel *textLb;

@end

@implementation BXCountryCodeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        _textLb = [[UILabel alloc]init];
        _textLb.font = CFont(16);
        _textLb.textColor = MainTitleColor;
        [self addSubview:_textLb];
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(5);
        }];
        
        UIImageView *bottomIv = [[UIImageView alloc]init];
        bottomIv.image = CImage(@"icon_shoujiquhaoxuanzhe");
        [self addSubview:bottomIv];
        [bottomIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLb.mas_right).offset(2);
            make.right.bottom.mas_equalTo(0);
            make.width.height.mas_equalTo(6);
        }];
    }
    return self;
}

- (void)setCountryCode:(NSString *)countryCode {
    _countryCode = countryCode;
    _textLb.text = [NSString stringWithFormat:@"+%@",countryCode];
}

@end

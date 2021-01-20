//
//  SLSeachHeaderView.m
//  BXlive
//
//  Created by sweetloser on 2020/7/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLSeachHeaderView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
@interface SLSeachHeaderView()


@end

@implementation SLSeachHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"历史" Font:SLPFFont(__ScaleWidth(14)) TextColor:sl_textSubColors];
        [self addSubview:label];
        _titleL = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo((20));
        }];
        label.textAlignment = NSTextAlignmentLeft;
        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_clearBtn];
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(__ScaleWidth(40));
        }];
        [_clearBtn setImage:[UIImage imageNamed:@"clean_history_black"] forState:BtnNormal];
        
        [_clearBtn addTarget:self action:@selector(cleanBtnOnClick) forControlEvents:BtnTouchUpInside];
        
    }
    return self;
}

-(void)cleanBtnOnClick{
    if (self.cleanBtnOnClickBlock) {
        self.cleanBtnOnClickBlock();
    }
}

@end

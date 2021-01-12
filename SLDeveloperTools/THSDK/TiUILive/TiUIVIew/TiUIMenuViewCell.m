//
//  TiUIMenuViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMenuViewCell.h"
#import <YYCategories/YYCategories.h>

@interface TiUIMenuViewCell ()

@property(nonatomic,strong)UILabel *textLabel;
@property (nonatomic,strong)UIView *line;

@end

@implementation TiUIMenuViewCell

-(UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = YES;
        _textLabel.font = TI_Font_Default_Size_Medium;
        _textLabel.textColor = TI_Color_Default_Text_Black;
    }
    return _textLabel;
}

-(UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#FF2D52"];
        _line.layer.cornerRadius = 1.0;
        _line.layer.masksToBounds  = YES;
    }
    return _line;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(2);
        }];
        self.line.hidden = YES;
    }
    return self;
}

-(void)setMenuMode:(TIMenuMode *)menuMode{
    if (menuMode) {
        _menuMode = menuMode;
        
        self.textLabel.text = menuMode.name;
         
        BOOL highlighted = menuMode.selected;
        
        if (highlighted)
        {
            self.textLabel.textColor = [UIColor colorWithHexString:@"#FF2D52"];
            self.line.hidden = NO;
        }
        else
        {
            self.textLabel.textColor = TI_Color_Default_Text_Black;
            self.line.hidden = YES;
        }
    }
}
 

@end

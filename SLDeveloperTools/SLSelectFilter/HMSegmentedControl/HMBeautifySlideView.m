//
//  HMBeautifySlideView.m
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMBeautifySlideView.h"
#import <Masonry/Masonry.h>
#import "../../SLMacro/SLMacro.h"
#import "../../SLCategory/SLCategory.h"

@interface HMBeautifySlideView()<HMSlideViewDelegate>

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *textLabel;

@property(nonatomic,strong)HMSlideView *slideView;


@end


@implementation HMBeautifySlideView

-(instancetype)initWithFrame:(CGRect)frame leftType:(NSInteger)leftType{
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat leftWidth = 0;
        if (leftType%2==0) {
            leftWidth = __ScaleWidth(16);
        }
        
        self.iconImage = [UIImageView new];
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftWidth);
            make.top.mas_equalTo(__ScaleWidth(5));
            if (leftType == 0) {
                make.width.mas_equalTo(__ScaleWidth(23));
                make.height.mas_equalTo(__ScaleWidth(29));
            }else if (leftType == 1) {
                make.width.mas_equalTo(__ScaleWidth(25));
                make.height.mas_equalTo(__ScaleWidth(26));
            }else if (leftType == 2) {
                make.width.mas_equalTo(__ScaleWidth(26));
                make.height.mas_equalTo(__ScaleWidth(24));
            }else if (leftType == 3) {
                make.width.mas_equalTo(__ScaleWidth(24));
                make.height.mas_equalTo(__ScaleWidth(26));
            }else if (leftType == 4) {
                make.width.mas_equalTo(__ScaleWidth(24));
                make.height.mas_equalTo(__ScaleWidth(26));
            }else if (leftType == 5) {
                make.width.mas_equalTo(__ScaleWidth(23));
                make.height.mas_equalTo(__ScaleWidth(29));
            }else if (leftType == 6) {
                make.width.mas_equalTo(__ScaleWidth(25));
                make.height.mas_equalTo(__ScaleWidth(26));
            }else if (leftType == 7) {
                make.width.mas_equalTo(__ScaleWidth(26));
                make.height.mas_equalTo(__ScaleWidth(24));
            }else if (leftType == 8) {
                make.width.mas_equalTo(__ScaleWidth(24));
                make.height.mas_equalTo(__ScaleWidth(25));
            }else if (leftType == 9) {
                make.width.mas_equalTo(__ScaleWidth(26));
                make.height.mas_equalTo(__ScaleWidth(23));
            }else if (leftType == 10) {
                make.width.mas_equalTo(__ScaleWidth(30));
                make.height.mas_equalTo(__ScaleWidth(27));
            }else if (leftType == 11) {
                make.width.mas_equalTo(__ScaleWidth(27));
                make.height.mas_equalTo(__ScaleWidth(24));
            }
        }];
        
        self.textLabel = [UILabel initWithFrame:CGRectZero size:10 color:sl_textSubColors alignment:1 lines:1];
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.iconImage.mas_centerX);
    
            make.top.mas_equalTo(self.iconImage.mas_bottom).offset(5);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(15);
        }];
        
        self.slideView = [[HMSlideView alloc] initWithFrame:CGRectMake(0, 0, self.width, 18)];
        [self addSubview:self.slideView];
        self.slideView.delegate = self;
        [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(__ScaleWidth(20));
            make.right.mas_equalTo(self).offset(-__ScaleWidth(17));
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(__ScaleWidth(20));
        }];
//        self.backgroundColor = [UIColor randomColor];
//        self.textLabel.text = @"大眼";
        
    }
    
    return self;
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    if (IsEquallString(dataDict[@"type"], @"0")) {
        self.textLabel.text = dataDict[@"name"];
        self.iconImage.image = CImage(dataDict[@"skin"]);
    }else{
        self.textLabel.text = dataDict[@"name"];
        self.iconImage.image = CImage(dataDict[@"shape"]);
    }
    self.slideView.type = [dataDict[@"slideType"] integerValue];
    self.slideView.value = [dataDict[@"value"] doubleValue];
    self.slideView.defaultValue = [dataDict[@"defaultValue"] doubleValue];
        
}

-(void)slideViewValueChangedWithType:(HMSliderType)type value:(CGFloat)value{
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideViewValueChangedWithType:value:)]) {
        [self.delegate slideViewValueChangedWithType:type value:value];
    }
}

-(void)resetParams{

    for (int i=0; i<self.dataDict.count; i++ ) {
        self.slideView.value = self.slideView.defaultValue;
    }
}


@end

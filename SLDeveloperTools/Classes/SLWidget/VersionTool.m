//
//  VersionTool.m
//  BXlive
//
//  Created by bxlive on 2018/11/8.
//  Copyright © 2018年 cat. All rights reserved.
//

//版本更新


#import "VersionTool.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLNetTools/SLNetTools.h"

@interface VersionToolView : UIView

@property(nonatomic,strong)UILabel *titleL;

@property(nonatomic,strong)UILabel *contentTitleL;

@property(nonatomic,strong)UILabel *contentL;

@end

@implementation VersionToolView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        
        UIView *maskV  = [UIView new];
        [self addSubview:maskV];
        [maskV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        maskV.backgroundColor = [UIColor sl_colorWithHex:0x000000 alpha:0.6];
        
        UIImageView *imgv = [UIImageView new];
        [self addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(__ScaleWidth(281));
            make.height.mas_equalTo(__ScaleWidth(355));
            make.top.mas_equalTo(__ScaleWidth(163-34) + __kTopAddHeight);
        }];
        [imgv setImage:CImage(@"new_version")];
        
//
        _titleL = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"发现新版本 " Font:SLBFont(__ScaleWidth(18)) TextColor:sl_textColors];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [imgv addSubview:_titleL];
        
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(__ScaleWidth(135));
            make.height.mas_equalTo(__ScaleWidth(25));
        }];
        
        _contentTitleL  = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"更新内容如下" Font:SLBFont(__ScaleWidth(14)) TextColor:sl_textColors];
        _contentTitleL.numberOfLines = 1;
        [imgv addSubview:_contentTitleL];
        [_contentTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(20));
            make.right.mas_equalTo(__ScaleWidth(-20));
            make.height.mas_equalTo(__ScaleWidth(20));
            make.top.mas_equalTo(__ScaleWidth(190));
        }];
        
        _contentL  = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"更新内容如下更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如更新内容如" Font:SLPFFont(__ScaleWidth(14)) TextColor:sl_textColors];
        _contentL.numberOfLines = 0;
        [imgv addSubview:_contentL];
        [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(20));
            make.right.mas_equalTo(__ScaleWidth(-20));
            make.height.mas_equalTo(__ScaleWidth(60));
            make.top.mas_equalTo(__ScaleWidth(225));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgv addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__ScaleWidth(40));
            make.width.mas_equalTo(__ScaleWidth(238));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(__ScaleWidth(-15));
        }];
        btn.backgroundColor = [UIColor sl_colorWithHex:0xE82935];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = __ScaleWidth(20);
        [btn setTitle:@"去更新" forState:BtnNormal];
        [btn setTitleColor:sl_whiteTextColors highlightedColor:sl_whiteTextColors];
        btn.titleLabel.font =  SLBFont(__ScaleWidth(14));
        [btn addTarget:self action:@selector(btnAction) forControlEvents:BtnTouchUpInside];
        imgv.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)btnAction{
    NSString *trackViewUrl = @"https://itunes.apple.com/cn/app/id1400641545?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

@end

@implementation VersionTool

//检测更新
+ (void)getNewVersion:(NSString *)urlString {
    
    [[SLHttpManager sl_sharedNetManager] sl_post:urlString parameters:nil success:^(id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code integerValue] == 0) {
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                NSString *appv = dataDic[@"appv"];
                NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
                if ([version  compare:appv options:NSNumericSearch] == NSOrderedAscending) {                    
                    VersionToolView *tv = [[VersionToolView alloc] initWithFrame:CGRectZero];
                    
                    [tv show];
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end

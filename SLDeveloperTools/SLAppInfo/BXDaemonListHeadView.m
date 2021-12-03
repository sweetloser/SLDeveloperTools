//
//  BXDaemonListHeadView.m
//  BXlive
//
//  Created by 刘超 on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDaemonListHeadView.h"
#import "SLDaemonListHeadGiftView.h"
#import "BXGift.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>

@interface BXDaemonListHeadView ()
@property(nonatomic,strong)NSArray *gifts;
@end

@implementation BXDaemonListHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *desLabel = [[UILabel alloc]init];
        [self addSubview:desLabel];
        desLabel.font = SLBFont(16);
        desLabel.textColor = sl_textColors;
        desLabel.text = @"守护榜单";
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.mas_top).offset(__GenScaleWidth(173));
            make.height.mas_equalTo(22);
        }];
        
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(desLabel);
            make.right.mas_equalTo(desLabel.mas_left).offset(-10);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(1);
        }];
        
        UIView *line2 = [[UIView alloc]init];
        [self addSubview:line2];
        line2.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(desLabel);
            make.left.mas_equalTo(desLabel.mas_right).offset(10);
            make.right.mas_equalTo(12);
            make.height.mas_equalTo(1);
        }];
        
        [self gatGuardGiftData];
    }
    return self;
}

-(void)gatGuardGiftData{
    [NewHttpManager getGuardGiftSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            self.gifts = [NSArray arrayWithArray:models];
            [self didGeGifts];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)didGeGifts{
    NSInteger giftC = self.gifts.count;
    
    CGFloat giftW = __GenScaleWidth(100);
    CGFloat giftH = __GenScaleWidth(160);
    CGFloat giftSpace = __GenScaleWidth((375-100*giftC)/(giftC+1));
    
    WS(weakSelf);
    for (int i=0; i<giftC; i++) {
        BXGift *gift = self.gifts[i];
        SLDaemonListHeadGiftView *giftV = [[SLDaemonListHeadGiftView alloc] initWithFrame:CGRectMake(giftSpace+(giftSpace+giftW)*i, __GenScaleWidth(0), giftW, giftH)];
        giftV.buyBtnOnClickBlock = ^{
            if (weakSelf.buyCallBackBlock) {
                weakSelf.buyCallBackBlock(gift);
            }
        };
        [giftV updateUIForModel:gift];
        [self addSubview:giftV];
    }
}

@end

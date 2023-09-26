//
//  SLNoticeView.m
//  BXlive
//
//  Created by sweetloser on 2020/6/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLNoticeView.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface SLNoticeView ()
@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *msgLabel;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *determineBtn;

@end

@implementation SLNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        self.backgroundColor = [UIColor sl_colorWithHex:0x000000 alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
//            make.height.mas_equalTo(191);
            make.left.offset(__ScaleWidth(47));
        }];
        self.contentView.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"确定从当前分类中移除?" Font:SLBFont(16) TextColor:sl_textColors];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(30);
            make.centerX.offset(0);
            make.height.mas_equalTo(22);
        }];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        
        UILabel *msgLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"商品不会彻底删除，仅从当前分类移除。" Font:SLPFFont(14) TextColor:sl_textColors];
        [self.contentView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(__ScaleWidth(25));
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
            make.centerX.offset(0);
        }];
        msgLabel.numberOfLines = 0;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        self.msgLabel = msgLabel;
        
        UIView *dl1 = [[UIView alloc] initWithFrame:frame];
        [dl1 setBackgroundColor:sl_divideLineColor];
        [self.contentView addSubview:dl1];
        [dl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(msgLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(1);
        }];
        
        NSMutableArray *btnArr = [NSMutableArray new];
        NSArray *titleArr = @[@"取消",@"确定"];
        NSArray *titleColors = @[[UIColor sl_colorWithHex:0x8C8C8C],sl_textColors];
        NSArray *fonts = @[SLPFFont(16),SLBFont(16)];
        for (int i=0; i<2; i++) {
            UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:btn];
            [btnArr addObject:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dl1.mas_bottom);
                make.bottom.offset(0);
                make.height.mas_equalTo(50);
            }];
            [btn setTitle:titleArr[i] forState:BtnNormal];
            [btn setTitleColor:titleColors[i]];
            btn.titleLabel.font = fonts[i];
            btn.tag = 1000+i;
            if (i ==  0) {
                self.cancelBtn = btn;
            }else if (i == 1) {
                self.determineBtn =  btn;
            }
            [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:BtnTouchUpInside];
        }
        
        [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
        
        UIView *dl2 = [[UIView alloc] initWithFrame:frame];
        [dl2 setBackgroundColor:sl_divideLineColor];
        [dl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dl1.mas_bottom);
            make.bottom.offset(0);
            make.width.mas_equalTo(1);
            make.centerX.offset(0);
        }];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}
-(void)setMessage:(NSString *)message{
    _message = message;
    _msgLabel.text = message;
}

-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle =  cancelTitle;
    [_cancelBtn setTitle:cancelTitle forState:BtnNormal];
}

-(void)setDetermineTitle:(NSString *)determineTitle{
    _determineTitle = determineTitle;
    [_determineBtn setTitle:determineTitle forState:BtnNormal];
}

-(void)tap:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        NSLog(@"范围内");
        return;
    }
    [self hiddenView];
}

-(void)btnOnClick:(UIButton *)btn{
    NSLog(@"点击");
    if (btn.tag == 1000) {
        NSLog(@"取消");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBtnOnClick)]) {
            [self.delegate cancelBtnOnClick];
        }
        
    }else if (btn.tag == 1001) {
        
        NSLog(@"确定");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(determineBtnOnClick)]) {
            [self.delegate determineBtnOnClick];
        }
    }
    [self hiddenView];
}

-(void)showWithView:(UIView *)superView{
    self.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

-(void)hiddenView{
    self.hidden = YES;
    [self.contentView removeAllSubViews];
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  SLPopMenuView.m
//  BXlive
//
//  Created by sweetloser on 2020/5/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLPopMenuView.h"
#import <YYCategories/YYCategories.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
@interface SLPopMenuView()
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)NSArray *titleArray;
@end

@implementation SLPopMenuView

+(SLPopMenuView *)popMenuView:(NSArray *)titleArr{
    
    
    UIFont *defaultFont = SLPFFont(14);
    CGFloat w = 0;
    
    //获取最大的
    for (NSString *title in titleArr) {
        CGFloat titleW = [UILabel getWidthWithTitle:title font:defaultFont];
        if (titleW > w) {
            w = titleW;
        }
    }
    SLPopMenuView *popMenu = [[SLPopMenuView alloc] initWithFrame:CGRectMake(0, 0, 110, 40 * titleArr.count+titleArr.count-1) titleArr:titleArr];
    return popMenu;
}

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
        [self.maskView addSubview:self];
        self.maskView.userInteractionEnabled = YES;
        WS(weakSelf);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf hidden];
        }];
        [self.maskView addGestureRecognizer:tap];
        self.titleArray = titleArr;
        [self initButtonWithtitleArray:titleArr];
        self.layer.borderColor = [UIColor sl_colorWithHex:0xAAAAAA].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        
    }
    return self;
}
-(void)initButtonWithtitleArray:(NSArray *)titleArr{
    for (int i=0;i<titleArr.count;i++) {
        NSString *title = titleArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, i*((self.height-titleArr.count+1)/titleArr.count+1), self.width, ((self.height-titleArr.count+1)/titleArr.count))];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTag:i];
        [btn addTarget:self action:@selector(menuItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor sl_colorWithHex:0x282828]];
        [btn.titleLabel setFont:SLPFFont(14)];
        [self addSubview:btn];
        
        if (i!=titleArr.count-1) {
            SLDivideLineView *dv = [SLDivideLineView DivideLineView:CGRectMake(0, (self.height-titleArr.count+1)/titleArr.count+i*(self.height/titleArr.count), self.width, 1) Color:[UIColor sl_colorWithHex:0xEAEAEA]];
            [self addSubview:dv];
        }
    }
}
-(void)menuItemOnClick:(UIButton *)sender{
    if (self.itemCallBack) {
        self.itemCallBack(sender.titleLabel.text);
    }
    [self hidden];
}

-(void)showWithView:(UIView *)view direction:(SLPopMenuDirection)direction{
    CGRect startRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    switch (direction) {
        case SLPopMenuDirectionTop:
        {
            self.center =CGPointMake(startRect.origin.x+startRect.size.width/2, startRect.origin.y-self.height/2-5);
        }
            break;
        case SLPopMenuDirectionLeft:
        {
            self.center =CGPointMake(startRect.origin.x-self.width/2-5, startRect.origin.y+self.height/2);
        }
            break;
        case SLPopMenuDirectionBottom:
        {
            self.center =CGPointMake(startRect.origin.x+startRect.size.width/2, startRect.origin.y+self.height/2+5+startRect.size.height);
        }
            break;
        case SLPopMenuDirectionRight:
        {
            self.center =CGPointMake(startRect.origin.x+startRect.size.width+5+self.width, startRect.origin.y+self.height/2);
        }
            break;
        default:
            break;
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.maskView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.maskView];
}

-(void)hidden{
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
    self.titleArray = nil;
    self.maskView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

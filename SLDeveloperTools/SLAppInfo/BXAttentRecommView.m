//
//  BXAttentRecommView.m
//  BXlive
//
//  Created by bxlive on 2019/2/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentRecommView.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXAttentRecommView()

@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIButton *changeBtn;
@end

@implementation BXAttentRecommView

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = sl_BGColors;
//        self.nameLabel = [UILabel initWithFrame:CGRectZero size:16 color:[UIColor blackColor] alignment:0 lines:1];
//        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.nameBtn setTitle:@"推荐关注" forState:UIControlStateNormal];
        self.nameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.nameBtn setImage:[UIImage imageNamed:@"icon_hot_recommend_att"] forState:UIControlStateNormal];
        [self.nameBtn setImagePosition:0 spacing:5];

        self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeBtn addTarget:self action:@selector(changeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.changeBtn setTitle:@"换一换" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.changeBtn setImage:[UIImage imageNamed:@"follow_icon_huanyihuan"] forState:UIControlStateNormal];
        [self sd_addSubviews:@[self.nameBtn,self.changeBtn]];
    
        self.changeBtn.sd_layout.rightSpaceToView(self, 0).centerYEqualToView(self).widthIs(75).heightIs(40);
        self.nameBtn.sd_layout.leftSpaceToView(self, 16).heightIs(20).centerYEqualToView(self).widthIs(100);
        self.changeBtn.titleLabel.font = CFont(11);
        [self.changeBtn setImagePosition:0 spacing:5];
        
//
        
        
        
    }
    return self;
}
-(void)changeBtnBtnClick{
    
    if (self.changeConnentPeople) {
        self.changeConnentPeople();
    }
    
}

@end

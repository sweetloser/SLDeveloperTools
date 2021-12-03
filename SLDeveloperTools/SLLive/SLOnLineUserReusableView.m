//
//  SLOnLineUserReusableView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLOnLineUserReusableView.h"
#import "SLMacro.h"
#import <YYWebImage/YYWebImage.h>
#import "SLCategory.h"

@interface SLOnLineUserReusableView()
@property(nonatomic,strong)UIImageView *fGuardImg;
@property(nonatomic,strong)UIImageView *sGuardImg;
@property(nonatomic,strong)UIImageView *tGuardImg;
@end

@implementation SLOnLineUserReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i=0; i<3; i++) {
            UIImageView *guardImage =[[UIImageView alloc] initWithFrame:CGRectMake(40*i+(3.5), (4), (33), (33))];
            guardImage.layer.masksToBounds = YES;
            guardImage.layer.cornerRadius = 35 / 2.0;
//            [guardImage setImage:[UIImage imageNamed:@"守护背景"]];
            [guardImage yy_setImageWithURL:nil placeholder:[UIImage imageNamed:@"守护背景"]];
            [self addSubview:guardImage];
            
            if (i==0) {
                _fGuardImg = guardImage;
            }else if (i==1){
                _sGuardImg = guardImage;
            }else if(i == 2){
                _tGuardImg = guardImage;
            }
            
            UIButton *guardBtn = [UIButton buttonWithFrame:CGRectMake(40*i, 0, 40, 40) Title:nil Font:CFont(9) Color:nil Image:[UIImage imageNamed:@"守护"] Target:self action:@selector(guardAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:guardBtn];
        }
    }
    return self;
}

-(void)guardAction{
    if (self.guardActionBlock) {
        self.guardActionBlock();
    }
}


-(void)updateGuardData:(NSArray *)guardData;{
//    先全部置为初始位置
    
    [self.fGuardImg yy_setImageWithURL:nil placeholder:[UIImage imageNamed:@"守护背景"]];
    [self.sGuardImg yy_setImageWithURL:nil placeholder:[UIImage imageNamed:@"守护背景"]];
    [self.tGuardImg yy_setImageWithURL:nil placeholder:[UIImage imageNamed:@"守护背景"]];
    
    
    NSInteger count = MIN(guardData.count, 3);
    for (int i=0; i<count; i++) {
        NSDictionary *guard = guardData[i];
        if (i==0) {
            [self.fGuardImg yy_setImageWithURL:[NSURL URLWithString:guard[@"guard_avatar"]] placeholder:[UIImage imageNamed:@"守护背景"]];
        }else if (i==1){
            [self.sGuardImg yy_setImageWithURL:[NSURL URLWithString:guard[@"guard_avatar"]] placeholder:[UIImage imageNamed:@"守护背景"]];
        }else if (i==2){
            [self.tGuardImg yy_setImageWithURL:[NSURL URLWithString:guard[@"guard_avatar"]] placeholder:[UIImage imageNamed:@"守护背景"]];
        }
    }
}

@end

//
//  HuaTiItemView.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "HuaTiItemView.h"
@interface HuaTiItemView()
@property(nonatomic, strong)UILabel *itemLabel;
@end
@implementation HuaTiItemView
-(instancetype)initWithFrame:(CGRect)frame ItemType:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

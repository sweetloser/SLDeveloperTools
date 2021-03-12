//
//  SLDivideLineView.m
//  BXlive
//
//  Created by sweetloser on 2020/4/25.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLDivideLineView.h"

@implementation SLDivideLineView

+(SLDivideLineView *)DivideLineView:(CGRect)frame Color:(UIColor *)color{
    SLDivideLineView *dView = [[self alloc] initWithFrame:frame];
    [dView setBackgroundColor:color];
    
    return dView;
}

@end

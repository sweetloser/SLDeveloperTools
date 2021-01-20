//
//  BXInsetsLable.m
//  BXlive
//
//  Created by mac on 2020/6/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXInsetsLable.h"

@implementation BXInsetsLable
- (instancetype)init {
    
    if (self = [super init]) {
        
        _textInsets = UIEdgeInsetsZero;
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _textInsets = UIEdgeInsetsZero;
        
    }
    
    return self;
    
}

- (void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
    
}
@end

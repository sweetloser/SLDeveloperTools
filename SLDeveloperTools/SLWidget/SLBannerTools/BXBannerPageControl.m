//
//  BXBannerPageControl.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXBannerPageControl.h"

@implementation BXBannerPageControl

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    if (_width > 0) {
        for (NSInteger index = 0; index < self.subviews.count; index++) {
            UIImageView* subview = self.subviews[index];
            subview.layer.cornerRadius = _width / 2.0;
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         _width,_width)];
        }
    }
}


@end

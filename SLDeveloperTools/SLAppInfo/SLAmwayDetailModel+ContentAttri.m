//
//  SLAmwayDetailModel+ContentAttri.m
//  BXlive
//
//  Created by sweetloser on 2020/12/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLAmwayDetailModel+ContentAttri.h"
#import <objc/runtime.h>

@implementation SLAmwayDetailModel (ContentAttri)

-(void)setContentAttri:(NSMutableAttributedString *)contentAttri{
    objc_setAssociatedObject(self, @selector(contentAttri), contentAttri, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableAttributedString *)contentAttri {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setContentHeight:(CGFloat)contentHeight{
    objc_setAssociatedObject(self, @selector(contentHeight), @(contentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)contentHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end

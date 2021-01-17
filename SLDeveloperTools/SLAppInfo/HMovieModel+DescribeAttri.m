//
//  HMovieModel+DescribeAttri.m
//  BXlive
//
//  Created by bxlive on 2019/2/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMovieModel+DescribeAttri.h"
#import <objc/runtime.h>

@implementation BXHMovieModel (DescribeAttri)

- (void)setDescribeAttri:(NSMutableAttributedString *)describeAttri {
    objc_setAssociatedObject(self, @selector(describeAttri), describeAttri, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableAttributedString *)describeAttri {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDescribeHeight:(CGFloat)describeHeight {
    objc_setAssociatedObject(self, @selector(describeHeight), @(describeHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)describeHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

-(void)setSelectStatus:(NSInteger)selectStatus{
    objc_setAssociatedObject(self, @selector(selectStatus), @(selectStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger)selectStatus{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setTapStatus:(NSInteger)tapStatus{
    objc_setAssociatedObject(self, @selector(tapStatus), @(tapStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger)tapStatus{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end

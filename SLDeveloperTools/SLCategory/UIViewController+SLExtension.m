//
//  UIViewController+SLExtension.m
//  BXlive
//
//  Created by sweetloser on 2020/5/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UIViewController+SLExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (SLExtension)

+(void)load{
    Method m_origin = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method m_sl = class_getInstanceMethod(self, @selector(sl_presentViewController:animated:completion:));
    method_exchangeImplementations(m_origin, m_sl);
}

-(void)sl_presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void(^)(void))complate{
    [self sl_presentViewController:vc animated:animated completion:complate];
}

@end

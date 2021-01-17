//
//  BXSLPopupController.m
//  BXlive
//
//  Created by bxlive on 2019/1/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLPopupController.h"

@implementation BXSLPopupController

- (instancetype)init {
    if ([super init]) {
        [self setValue:@(YES) forKey:@"_didOverrideSafeAreaInsets"];
    }
    return self;
}

- (void)bgViewDidTap {
    [self.containerView endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillDismissPopupController object:self];
    [self dismiss];
}

@end

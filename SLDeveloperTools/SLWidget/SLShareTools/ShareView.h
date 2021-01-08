//
//  ShareView.h
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareObject.h"

@interface ShareView : UIView

@property (copy, nonatomic) void (^shareTo)(ShareObjectType type);
@property (copy, nonatomic) void (^shareDynamic)(void);

- (instancetype)initWithShareObjects:(NSArray *)shareObjects;

- (void)show;

@end

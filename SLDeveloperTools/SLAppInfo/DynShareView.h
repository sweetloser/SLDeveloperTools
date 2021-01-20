//
//  ShareView.h
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynShareObject.h"

@interface DynShareView : UIView

@property (copy, nonatomic) void (^shareTo)(DynShareObjectType type);

- (instancetype)initWithShareObjects:(NSArray *)shareObjects;

- (void)show;

@end

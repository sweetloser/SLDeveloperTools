//
//  SLShareView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLShareObjs.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLShareView : UIView

@property (copy, nonatomic) void (^shareTo)(SLShareObjsType type);
@property (copy, nonatomic) void (^shareDynamic)(void);

- (instancetype)initWithShareObjects:(NSArray <SLShareObjs *> *)shareObjects;

- (void)show;

@end

NS_ASSUME_NONNULL_END

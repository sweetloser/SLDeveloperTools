//
//  BXActivityView.h
//  BXlive
//
//  Created by bxlive on 2019/3/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXActivity.h"

@interface BXActivityView : UIView

@property (nonatomic, strong) BXActivity *activity;
@property (nonatomic, copy) void (^toDetail)(NSString *url, CGFloat height);
@property (nonatomic, copy) void (^toWebVC)(NSString *url);

@end



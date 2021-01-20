//
//  BXRewardTopThreeView.h
//  BXlive
//
//  Created by bxlive on 2019/4/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXRewardTopThreeView : UIView

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, strong) NSArray *liveUsers;
@property (nonatomic, copy) void (^didSelectedUser)(NSString *user_id);

- (void)startAnimation;

@end



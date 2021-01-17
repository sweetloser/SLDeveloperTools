//
//  BXTwistingMachineView.h
//  BXlive
//
//  Created by bxlive on 2019/1/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXTwistingMachineView : UIView

@property (copy, nonatomic) void (^toDetail)(NSString *url, CGFloat height);

- (instancetype)initWithUrl:(NSString *)url roomId:(NSString *)roomId vc:(UINavigationController *)nav;

@end

NS_ASSUME_NONNULL_END

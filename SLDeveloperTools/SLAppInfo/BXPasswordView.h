//
//  BXPasswordView.h
//  BXlive
//
//  Created by bxlive on 2019/6/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXPasswordView : UIView

@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, copy) NSString *initialPassword;
@property (nonatomic, copy)  void (^didInputPassword)(NSString *password);
@property (nonatomic, copy)  void (^cancelBlock)();

- (instancetype)initWithTitle:(NSString *)title;
- (void)showWithSuperView:(UIView *)superView;

@end



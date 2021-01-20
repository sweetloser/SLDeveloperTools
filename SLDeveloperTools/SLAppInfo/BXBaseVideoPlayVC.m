//
//  BXBaseVideoPlayVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/24.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXBaseVideoPlayVC.h"

@interface BXBaseVideoPlayVC ()


@end

@implementation BXBaseVideoPlayVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseVideoPlayVCViewAppearState" object:nil userInfo:@{@"state":@"1"}];
    
    if (self.commentView) {
        [self.commentView showInView:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseVideoPlayVCViewAppearState" object:nil userInfo:@{@"state":@"0"}];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

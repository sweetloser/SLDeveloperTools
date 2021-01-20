//
//  BXSLPageListVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLPageListVC.h"

@interface BXSLPageListVC ()

@end

@implementation BXSLPageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    self.scrollCallback = nil;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
    
}

- (void)listDidDisappear {
    
}

@end

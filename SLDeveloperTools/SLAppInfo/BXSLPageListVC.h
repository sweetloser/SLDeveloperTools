//
//  BXSLPageListVC.h
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXPagerView.h"

@interface BXSLPageListVC : BaseVC <JXPagerViewListViewDelegate>

@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end



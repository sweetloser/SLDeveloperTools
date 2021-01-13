//
//  BXBannerView.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXBannerView : UIView
@property (strong, nonatomic) NSArray *banners;
@property (assign, nonatomic) BOOL isEvent;
@property (copy, nonatomic) void (^selectedBanner)(NSInteger index);

- (void)stopScroll;

@end

NS_ASSUME_NONNULL_END

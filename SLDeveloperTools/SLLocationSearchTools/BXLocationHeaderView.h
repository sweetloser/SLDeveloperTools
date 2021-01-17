//
//  BXLocationHeaderView.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXLocationHeaderViewDelegate <NSObject>

- (void)locationHeaderViewDidTap;

@end

@interface BXLocationHeaderView : UIView

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, weak) id<BXLocationHeaderViewDelegate> delegate;

@end



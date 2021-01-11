//
//  BXliveSelectFilterView.h
//  BXlive
//
//  Created by bxlive on 2019/4/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXVideoSelectFilterViewDelegate <NSObject>

- (void)didSelectedFilter:(NSInteger)index;
- (void)didRemoveFromSuperview;

@end

@interface BXVideoSelectFilterView : UIView

@property (nonatomic, weak) id<BXVideoSelectFilterViewDelegate> delegate;

- (instancetype)initWithIndex:(NSInteger)index filterArr:(NSArray *)filterArr;
- (void)show;

@end



//
//  HMFilterView.h
//  BXlive
//
//  Created by bxlive on 2019/4/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

//滤镜


@protocol HMFilterViewDelegate <NSObject>

// 开启滤镜
- (void)filterViewDidSelectedFilter:(NSString *)filterName  selectedIndex:(NSInteger)selectedIndex;
@end


@interface HMFilterView : UICollectionView


@property (nonatomic, weak) id<HMFilterViewDelegate>mDelegate ;

@property (nonatomic, strong) NSArray *filtersName;

@property (nonatomic, assign) NSInteger selectedIndex ;

- (instancetype)initWithFrame:(CGRect)frame filtersName:(NSArray *)filtersName;

-(void)resetParams;

@end

@interface HMFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end






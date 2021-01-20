//
//  BXDynNearHeaderView.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class BXDynTopicModel;
@protocol DynNearHeaderDelegate <NSObject>

- (void)DidIndexClick:(NSInteger)index topicModel:(BXDynTopicModel *)model;

@end
@interface BXDynNearHeaderView : UIView
- (id)initWithFrame:(CGRect)frame DataArray:(NSArray *)array;
@property(nonatomic, strong)BXDynTopicModel *model;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic , strong) NSArray * huatiArray;
@property (nonatomic , weak)id<DynNearHeaderDelegate>delegate;

@property (copy, nonatomic) void (^isHeaderData)();

@end

NS_ASSUME_NONNULL_END

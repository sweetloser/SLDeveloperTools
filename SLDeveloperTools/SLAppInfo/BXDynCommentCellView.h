//
//  BXDynCommentView.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BXDynCommentViewDelegate <NSObject>
@optional
- (void)didClickMoreButtonInView;
- (void)didClickcCommentButtonInView;
- (void)didClickSelfInView:(BXCommentModel *)model;
@end


@interface BXDynCommentCellView : UIView

@property (nonatomic , weak) id<BXDynCommentViewDelegate>delegate;


- (void)setupWithLikeItemsCount:(NSInteger )likeItemsCount commentCount:(NSInteger)commentCount commentItemsArray:(NSArray *)commentItemsArray;





@end
NS_ASSUME_NONNULL_END

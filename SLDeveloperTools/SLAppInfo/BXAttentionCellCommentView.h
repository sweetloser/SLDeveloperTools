//
//  BXAttentionCellCommentView.h
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DSAttentionCellCommentViewDelegate <NSObject>
@optional
- (void)didClickMoreButtonInView;
- (void)didClickcCommentButtonInView;
- (void)didClickSelfInView:(BXCommentModel *)model;
@end


@interface BXAttentionCellCommentView : UIView

@property (nonatomic , weak) id<DSAttentionCellCommentViewDelegate>delegate;


- (void)setupWithLikeItemsCount:(NSInteger )likeItemsCount commentCount:(NSInteger)commentCount commentItemsArray:(NSArray *)commentItemsArray;





@end

NS_ASSUME_NONNULL_END

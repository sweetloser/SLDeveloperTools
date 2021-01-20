//
//  DetailSowComentView.h
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"
@protocol DetailShowComentViewDelegate <NSObject>
@optional
- (void)didClickMoreButtonInView;
- (void)didClickcCommentButtonInView;
- (void)didClickSelfInView:(BXCommentModel *)model;
@end


@interface DetailShowComentView : UIView

@property (nonatomic , weak) id<DetailShowComentViewDelegate>delegate;


- (void)setupWithLikeItemsCount:(NSInteger )likeItemsCount commentCount:(NSInteger)commentCount commentItemsArray:(NSArray *)commentItemsArray;




@end


//
//  BXDynPlayVideoCell.h
//  BXlive
//
//  Created by mac on 2020/8/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHMovieModel.h"
#import "BXActivity.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BXVideoShowCellDelegate;
typedef void (^AdClickBack)(void);
@interface BXDynPlayVideoCell : UITableViewCell
@property (nonatomic, assign) NSInteger moreType;
@property (strong, nonatomic) BXHMovieModel *video;
@property (weak, nonatomic) id<BXVideoShowCellDelegate> delegate;
@property(nonatomic, copy)AdClickBack skip;

//type：0 有底部 1：无底部
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type;

@end

//@protocol BXVideoShowCellDelegate <NSObject>
//
//- (void)videoLikeWithCell:(BXDynPlayVideoCell *)cell;
//- (void)videolLookWithCell:(BXDynPlayVideoCell *)cell;
//- (void)videoRewardWithVideo:(BXHMovieModel *)video;
//@end

NS_ASSUME_NONNULL_END

//
//  BXMusicCategoryCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 歌单分类 */

@protocol DSMusicCategoryCellDelegate <NSObject>

- (void)pushCategoryDetailWithCategoryID:(NSString *)categoryID Title:(NSString *)title;

@optional

@end

@interface BXMusicCategoryCell : UITableViewCell

@property (nonatomic , weak) id<DSMusicCategoryCellDelegate>delegate;

@property (nonatomic , strong) NSMutableArray *dataArray;

@end



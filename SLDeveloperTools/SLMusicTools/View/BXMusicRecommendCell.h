//
//  BXMusicRecommendCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 推荐 */

@interface BXMusicRecommendCell : UITableViewCell

@property (nonatomic , strong) NSMutableArray *dataArray;

@property(nonatomic,copy)void(^musicCollectBlock)(NSInteger index);

@end


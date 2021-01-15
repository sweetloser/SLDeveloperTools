//
//  BXKSongCell.h
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXKSongCell : UITableViewCell

@property (nonatomic , strong) NSMutableArray *dataArray;

@property(nonatomic,copy)void(^likeSongBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END

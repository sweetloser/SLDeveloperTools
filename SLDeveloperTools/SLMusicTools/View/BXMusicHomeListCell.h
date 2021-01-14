//
//  BXMusicHomeListCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 首页列表数据 */
@interface BXMusicHomeListCell : UITableViewCell
@property (nonatomic , strong) NSMutableArray *dataArray;
@property(nonatomic,copy)void(^musicCollectBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END

//
//  BXAttentionPeopleCell.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 显示(关注的人)
 */
@interface BXAttentionPeopleCell : UITableViewCell


@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *is_live_dataArr;


-(void)reloadData;

@end

NS_ASSUME_NONNULL_END

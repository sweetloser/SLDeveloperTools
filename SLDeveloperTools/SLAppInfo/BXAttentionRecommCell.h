//
//  BXAttentionRecommCell.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 (推荐的人)
 */
@interface BXAttentionRecommCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray *recArr;


@property(nonatomic,copy)void(^attentRecommBlock)(NSInteger index);

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END

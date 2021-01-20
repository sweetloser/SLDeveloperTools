//
//  BXDynTopicSquareCell.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicSquareCell : UITableViewCell
@property (copy, nonatomic) void (^CreateHuaTi)(NSString *text);
@property(nonatomic, strong)UILabel *huatiLabel;
@property(nonatomic, strong)UILabel *huatiNumLabel;
@end

NS_ASSUME_NONNULL_END

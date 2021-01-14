//
//  AddHuaTiCell.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddHuaTiCell : UITableViewCell
@property (copy, nonatomic) void (^CreateHuaTi)(NSString *text);
@property(nonatomic, strong)UILabel *huatiLabel;
@property(nonatomic, strong)UILabel *topicNumLabel;
@property(nonatomic, strong)UILabel *createLabel;
@property(nonatomic, assign)BOOL isSearch;

@property(nonatomic, strong)NSString *topicNum;
@property(nonatomic, strong)NSString *topicname;
@end

NS_ASSUME_NONNULL_END

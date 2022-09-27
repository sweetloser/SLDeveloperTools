//
//  HHPhoneAccountCell.h
//  BXlive
//
//  Created by bxlive on 2018/5/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPhoneAccountCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setTitle:(NSString *)title icon:(NSString *)icon phone:(NSString *)phone;

@end

//
//  BXSLSearchHistoryCell.h
//  BXlive
//
//  Created by bxlive on 2019/3/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXSLSearchHistoryCell : UITableViewCell

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void (^removeText)(NSString *text);

@end



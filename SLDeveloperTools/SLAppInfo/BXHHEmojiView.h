//
//  BXHHEmojiView.h
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHHEmoji.h"

@interface BXHHEmojiView : UIView

@property (copy, nonatomic) void (^didGetEmoji)(BXHHEmoji *emoji);
@property (copy, nonatomic) void (^delEmoji)();

- (void)reloadView;

@end

//
//  BXCommentFooterView.h
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"

@protocol BXCommentFooterViewDelegate;

@interface BXCommentFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) BXCommentModel *comment;
@property (nonatomic, weak) id<BXCommentFooterViewDelegate> delegate;

@end

@protocol BXCommentFooterViewDelegate <NSObject>

- (void)showChildCommentWithComment:(BXCommentModel *)comment isOpen:(BOOL)isOpen view:(BXCommentFooterView *)view;

@end

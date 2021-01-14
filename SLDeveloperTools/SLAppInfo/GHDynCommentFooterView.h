//
//  BXCommentFooterView.h
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCommentModel.h"

@protocol BXCommentFooterViewDelegate;

@interface GHDynCommentFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) BXDynCommentModel *comment;
@property (nonatomic, assign) NSInteger listNum;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, weak) id<BXCommentFooterViewDelegate> delegate;
@property(nonatomic,copy)void (^toListform)(void);
@end

@protocol BXCommentFooterViewDelegate <NSObject>

- (void)showChildCommentWithComment:(BXDynCommentModel *)comment isOpen:(BOOL)isOpen view:(GHDynCommentFooterView *)view;

@end

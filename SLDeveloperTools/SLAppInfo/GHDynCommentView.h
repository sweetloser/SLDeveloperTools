//
//  BXCommentView.h
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHMovieModel.h"

#define CommentViewTag 10099

@protocol DynCommentViewDelegate <NSObject>

//关闭
- (void)deleteCommentView;
//点击头像和昵称跳转个人主页
- (void)toPersonHomeWithUserID:(NSString *)userID;

@end

@interface GHDynCommentView : UIView

@property (nonatomic, copy) void (^commentNumChanged)(BOOL isAdd, BXCommentModel *comment);
@property (nonatomic ,weak) id<DynCommentViewDelegate>delegate;

- (instancetype)initWitBXHMovieModel:(BXHMovieModel *)model;

- (void)showInView:(UIView *)view;

- (void)showInView:(UIView *)view isWrite:(BOOL)isWrite topComment:(BXCommentModel *)topComment;

- (void)commentViewhidden;

@end


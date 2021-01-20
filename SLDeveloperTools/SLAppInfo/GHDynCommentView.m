//
//  GHDynCommentView.m
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "GHDynCommentView.h"
#import "GHDynCommentCell.h"
#import "BXCommentModel.h"
#import "GHDynCommentHeaderView.h"
#import "BXAiteFriendVC.h"
#import "ZZLActionSheetView.h"
#import "BaseNavVC.h"
#import "BXSendCommentView.h"
#import "BXLoadingView.h"
#import "NSObject+Tag.h"
#import "UIGestureRecognizer+Time.h"
#import "TimeHelper.h"
#import "GHDynCommentFooterView.h"
#import "UIApplication+ActivityViewController.h"
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import "NewHttpRequestHuang.h"
#import "NewHttpRequestPort.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>
#import "BXLiveUser.h"
@interface GHDynCommentView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, BXCommentFooterViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UILabel * titleLabel;

@property (nonatomic , strong) UILabel * noDataLabel;

@property (nonatomic , strong) NSString * lastCommentID;
@property (nonatomic , strong) BXHMovieModel * movieModel;
@property (nonatomic , strong) NSMutableArray * commentArray;

@property (nonatomic , assign) NSInteger offset;

@property (nonatomic, strong) BXCommentModel *topComment;
@property (nonatomic, assign) BOOL isNeedSendComment;

@end

@implementation GHDynCommentView

-(NSMutableArray *)commentArray{
    if (_commentArray==nil) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (instancetype)initWitBXHMovieModel:(BXHMovieModel *)model {
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        self.tag = CommentViewTag;
        
        _movieModel = model;
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:maskView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tapGestureRecognizer];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 486 +__kBottomAddHeight)];
        [self addSubview:_contentView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame =_contentView.bounds;
        [_contentView addSubview:visualEffectView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [_contentView addGestureRecognizer:pan];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        self.offset = 0;
        [self createHeadFootViewWithCommentCount:model.comment_sum];
        [self createTableView];
        self.noDataLabel = [UILabel initWithFrame:CGRectZero text:@"暂无评论,还不快抢沙发" size:12 color:MinorColor alignment:NSTextAlignmentCenter lines:1 shadowColor:[UIColor clearColor]];
        [_contentView addSubview:self.noDataLabel];
        self.noDataLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(44, 0, 49+__kBottomAddHeight, 0));
        
        self.noDataLabel.hidden = [model.comment_sum integerValue];
    }
    return self;
}

- (void)createHeadFootViewWithCommentCount:(NSString *)commentCount{
    UIView *headerView = [[UIView alloc]init];
    [_contentView addSubview:headerView];
    headerView.sd_layout.leftSpaceToView(_contentView, 0).topSpaceToView(_contentView, 0).rightSpaceToView(_contentView, 0).heightIs(44);
    
    self.titleLabel = [UILabel initWithFrame:CGRectZero text:[NSString stringWithFormat:@"%@条评论",commentCount] size:16 color:TextBrightestColor alignment:NSTextAlignmentCenter lines:1 shadowColor:[UIColor clearColor]];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_comment_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView sd_addSubviews:@[self.titleLabel, deleteBtn]];
    self.titleLabel.sd_layout.centerXEqualToView(headerView).centerYEqualToView(headerView).widthIs(200).heightIs(44);
    deleteBtn.sd_layout.rightSpaceToView(headerView, 16).topSpaceToView(headerView, 10).widthIs(24).heightIs(24);
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = TabBarColor;
    [_contentView addSubview:footerView];
    footerView.sd_layout.leftSpaceToView(_contentView, 0).bottomSpaceToView(_contentView, 0).rightSpaceToView(_contentView, 0).heightIs(49+__kBottomAddHeight);

    UIButton *textFieldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textFieldBtn.sd_cornerRadius = @(16);
    textFieldBtn.backgroundColor = UIColorHex(1E1E20);
    [textFieldBtn setTitle:@"我来说一说..." forState:UIControlStateNormal];
    [textFieldBtn setTitleColor:MinorColor forState:UIControlStateNormal];
    textFieldBtn.titleLabel.font = CFont(16);
    textFieldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textFieldBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [textFieldBtn addTarget:self action:@selector(textFieldBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *aiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aiteBtn setImage:CImage(@"icon_comment_aite") forState:UIControlStateNormal];
    [aiteBtn addTarget:self action:@selector(aiteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setImage:CImage(@"icon_comment_emoji") forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(emojiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView sd_addSubviews:@[textFieldBtn,aiteBtn,emojiBtn]];
    aiteBtn.sd_layout.topSpaceToView(footerView, 7.5).rightSpaceToView(footerView, 16).widthIs(34).heightIs(34);
    emojiBtn.sd_layout.topSpaceToView(footerView, 7.5).rightSpaceToView(aiteBtn, 16).widthIs(34).heightIs(34);
    textFieldBtn.sd_layout.topSpaceToView(footerView, 7.5).leftSpaceToView(footerView, 16).rightSpaceToView(emojiBtn, 16).heightIs(34);
}

- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:self.tableView];
    [self.tableView registerClass:NSClassFromString(@"BXCommentHeaderView") forHeaderFooterViewReuseIdentifier:@"BXCommentHeaderView"];
    [self.tableView registerClass:[GHDynCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"Footer"];
    [self.tableView registerClass:NSClassFromString(@"BXCommentCell") forCellReuseIdentifier:@"BXCommentCell"];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(44, 0, 49+__kBottomAddHeight, 0));
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    if (_tableView.contentOffset.y > 0) {
        [sender setTranslation:CGPointZero inView:sender.view];
        return;
    } else {
        if (sender.state == UIGestureRecognizerStateBegan) {
            if (!CGRectContainsPoint(_tableView.frame, [sender locationInView:_contentView]) ) {
                sender.ds_Tag = 1;
            }
            sender.beginTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            if (sender.ds_Tag == 1) {
                [self action:sender];
            } else {
                if (_tableView.contentOffset.y <= 0) {
                    [self action:sender];
                }
            }
        } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
            if (sender.ds_Tag == 1) {
                sender.ds_Tag = 0;
            }
            _tableView.scrollEnabled = YES;
            double timeSp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            if (timeSp - sender.beginTime < 1.0 && _contentView.y - self.height + self.contentView.height > 70) {
                [self tapAction];
            } else {
                [self adjustmentContentViewFrame];
            }
        }
    }
    [sender setTranslation:CGPointZero inView:sender.view];
}

- (void)action:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view];
    CGFloat y = _contentView.frame.origin.y + point.y;
    if (y < self.height - self.contentView.height) {
        y = self.height - self.contentView.height;
    }
    _contentView.y = y;
}

- (void)adjustmentContentViewFrame {
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.y = self.height - self.contentView.height;
    }];
}

- (void)tapAction {
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    [self showInView:view isWrite:NO topComment:nil];
}

- (void)showInView:(UIView *)view isWrite:(BOOL)isWrite topComment:(BXCommentModel *)topComment {
    if (view) {
        if (topComment) {
            _topComment = topComment;
        }
        [self createData];
        
        [view addSubview:self];
        [UIView animateWithDuration:.5 animations:^{
            self.contentView.y = self.height - self.contentView.height;
        } completion:^(BOOL finished) {
            if (topComment) {
                if (self.commentArray.count) {
                    [self sendCommentView:0 aites:nil section:0 replyName:topComment.nickname commentId:topComment.comment_id];
                } else {
                    self.isNeedSendComment = YES;
                }
            } else if (isWrite) {
                [self sendCommentView:0 aites:nil section:0 replyName:nil commentId:nil];
            }
        }];
    } else {
        if (self.superview) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.superview bringSubviewToFront:self];
                self.hidden = NO;
                [UIView animateWithDuration:.4 animations:^{
                    self.contentView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self.superview bringSubviewToFront:self];
                }];
            });
            
            NSLog(@"hahahahahaha");
            
            
        }
    }
}

-(void)sendCommentView:(NSInteger)type aites:(NSArray *)aites section:(NSInteger)section replyName:(NSString *)replyName commentId:(NSString *)commentId {
    WS(ws);
    BXSendCommentView *view = [[BXSendCommentView alloc]initWithFrame:CGRectZero array:aites];
    view.replyName = replyName;
    view.sendComment = ^(NSString * _Nonnull text, NSString * _Nonnull jsonString) {
        if (commentId) {
            [ws sendCommentWithText:text jsonString:jsonString section:section commentId:commentId];
        } else {
            [ws sendCommentWithText:text JsonString:jsonString];
        }
        
    };
    [self addSubview:view];
    [view show:type];
}

- (void)commentViewhidden {
    self.hidden = YES;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.height);
}

- (void)createData {
    BXLoadingView *loadingView = nil;
    if (!self.commentArray.count) {
        loadingView = [BXLoadingView showInView:_contentView width:_contentView.width height:_contentView.height];
        loadingView.backgroundColor = [UIColor clearColor];
        self.lastCommentID = @"0";
    }else{
        BXCommentModel *model = self.commentArray[self.commentArray.count-1];
        self.lastCommentID = [NSString stringWithFormat:@"%@",model.comment_id];
    }
    
    NSString *topCommentId = @"";
    if (self.topComment) {
        topCommentId = self.topComment.comment_id;
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentCommentListWithVideoID:_movieModel.movieID topCommentId:topCommentId LastID:self.lastCommentID Offset:[NSString stringWithFormat:@"%ld",(long)self.offset] length:@"20" Success:^(id responseObject) {
        if (loadingView) {
            [loadingView removeFromSuperview];
        }
        if ([responseObject[@"code"] integerValue]==0) {
            NSArray *array = responseObject[@"data"];
            if (array.count) {
                WS(ws);
                BOOL isSendComment = !self.commentArray.count;
                for (NSDictionary *cdict in array) {
                    BXCommentModel *model = [[BXCommentModel alloc] initWithDict:cdict];
                    [model processAttributedStringWithIsChild:NO];
                    model.toPersonHome = ^(NSString * _Nonnull userId) {
                        [ws toPersonHomeWithUserId:userId];
                    };
                    if (model.childCommentArray && model.childCommentArray.count) {
                        model.showChildCount = 1;
                    }
                    [self.commentArray addObject:model];
                }
                [self.tableView reloadData];
                if (isSendComment && self.isNeedSendComment) {
                    [self sendCommentView:0 aites:nil section:0 replyName:self.topComment.nickname commentId:self.topComment.comment_id];
                }
            } else {
                self.tableView.isNoMoreData = YES;
                self.tableView.hh_footerView.hidden = !self.commentArray.count;
            }
            self.tableView.isRefresh = NO;
            self.tableView.isNoNetwork = NO;
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        if (loadingView) {
            [loadingView removeFromSuperview];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

- (void)loadChildCommentDataWithComment:(BXCommentModel *)comment Section:(NSInteger)section view:(GHDynCommentFooterView *)view {
    view.userInteractionEnabled = NO;
    
    NSInteger tempRow = comment.childCommentArray.count;
    BXCommentModel *replyModel = comment.childCommentArray[comment.childCommentArray.count-1];
    
    NSString *topCommentId = @"";
    if (self.topComment) {
        topCommentId = self.topComment.comment_id;
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentSubCommentListWithVideoID:_movieModel.movieID CommentID:comment.comment_id topCommentId:topCommentId LastID:replyModel.comment_id Offset:[NSString stringWithFormat:@"%d",(int)comment.childCommentArray.count] length:[NSString stringWithFormat:@"%d",(int)(comment.showChildCount - comment.childCommentArray.count)] Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSArray *dataArr = responseObject[@"data"];
            if (dataArr && [dataArr isArray] && dataArr.count) {
                NSMutableArray *indexPaths = [NSMutableArray array];
                WS(ws);
                for (NSInteger i = 0; i < dataArr.count; i++) {
                    NSDictionary *dic = dataArr[i];
                    BXCommentModel *model = [[BXCommentModel alloc]initWithDict:dic];
                    [model processAttributedStringWithIsChild:YES];
                    model.toPersonHome = ^(NSString * _Nonnull userId) {
                        [ws toPersonHomeWithUserId:userId];
                    };
                    [comment.childCommentArray addObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow + i inSection:section];
                    [indexPaths addObject:indexPath];
                }
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                
            }
        } else {
            comment.reply_count = [NSString stringWithFormat:@"%ld",(long)comment.childCommentArray.count];
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        if ([view.comment isEqual:comment]) {
            view.comment = comment;
        }
        view.userInteractionEnabled = YES;
    } Failure:^(NSError *error) {
        view.userInteractionEnabled = YES;
    }];
}

#pragma mark - 关闭
- (void)deleteBtnClick{
    [self tapAction];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCommentView)]) {
        [self.delegate deleteCommentView];
    }
}

#pragma mark - 艾特
- (void)aiteBtnClick{
    WS(weakSelf);
    BXAiteFriendVC *afvc = [[BXAiteFriendVC alloc] init];
    afvc.selectTextArray = ^(NSMutableArray * _Nonnull array) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf sendCommentView:0 aites:array section:0 replyName:nil commentId:nil];
        });
    };
    [[[UIApplication sharedApplication] activityViewController] presentViewController:afvc animated:YES completion:nil];
}

- (void)textFieldBtnClick{
    [self sendCommentView:0 aites:nil section:0 replyName:nil commentId:nil];
}

#pragma mark - 表情
- (void)emojiBtnClick{
    [self sendCommentView:1 aites:nil section:0 replyName:nil commentId:nil];
}

#pragma mark - 发表评论(评论视频)
- (void)sendCommentWithText:(NSString *)string JsonString:(NSString *)jsonString{
    WS(ws);
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentCommentWithVideoID:_movieModel.movieID Comment:string ReplyID:@"" Friends:jsonString Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSDictionary *dic = responseObject[@"data"];
            self.titleLabel.text = [NSString stringWithFormat:@"%@条评论",dic[@"video_comment_count"]];
            self.movieModel.comment_sum = [NSString stringWithFormat:@"%@",dic[@"video_comment_count"]];
            BXCommentModel *model = [[BXCommentModel alloc] initWithDict:dic[@"now_comment_data"]];
            model.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws toPersonHomeWithUserId:userId];
            };
            [model processAttributedStringWithIsChild:NO];
            [self.commentArray insertObject:model atIndex:0];
            [self.tableView insertSection:0 withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidCommentNotification object:nil userInfo:@{@"videoId":self.movieModel.movieID,@"comment":model}];
            if (self.commentNumChanged) {
                self.commentNumChanged(YES, model);
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - 回复评论
- (void)sendCommentWithText:(NSString *)string jsonString:(NSString *)jsonString section:(NSInteger)section commentId:(NSString *)commentId {
    WS(ws);
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentCommentWithVideoID:_movieModel.movieID Comment:string ReplyID:commentId Friends:jsonString Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSDictionary *dic = responseObject[@"data"];
            BXCommentModel *replyModel = [[BXCommentModel alloc]initWithDict:dic[@"now_comment_data"]];
            [replyModel processAttributedStringWithIsChild:YES];
            replyModel.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws toPersonHomeWithUserId:userId];
            };
            BXCommentModel *model = self.commentArray[section];
            model.showChildCount++;
            [model.childCommentArray insertObject:replyModel atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [self.tableView insertRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.commentNumChanged) {
                self.commentNumChanged(YES, replyModel);
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
}


- (void)commentMoreAction:(BXCommentModel *)comment section:(NSInteger)section {
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:@"回复"];
    [titles addObject:@"复制"];
    if (IsEquallString(comment.user_id, [BXLiveUser currentBXLiveUser].user_id)) {
        [titles addObject:@"删除"];
    }else{
        [titles addObject:@"举报"];
    }
    
    WS(ws);
    ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr:titles cancelTitle:@"取消" cancelBlock:^{
    } selectBlock:^(NSInteger index) {
        if (!index) {
            [ws replyComment:comment section:section];
            
        } else if (index == 1) {
            [ws becomeFirstResponder];
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = comment.content;
            [BGProgressHUD showInfoWithMessage:@"复制成功"];
        } else {
            if ([comment.user_id isEqualToString:[BXLiveUser currentBXLiveUser].user_id]) {
                //删除
                [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentDeleteWithCommentID:comment.comment_id Success:^(id responseObject) {
                    if ([responseObject[@"code"]intValue] == 0) {
                        [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                        if ([ws.titleLabel.text integerValue]) {
                            ws.movieModel.comment_sum =[NSString stringWithFormat:@"%ld",(long)[ws.movieModel.comment_sum integerValue]-1];
                            ws.titleLabel.text = [NSString stringWithFormat:@"%@条评论",ws.movieModel.comment_sum];
                        }
                        
                        [ws.commentArray removeObjectAtIndex:section];
                        [ws.tableView deleteSection:section withRowAnimation:UITableViewRowAnimationNone];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCommentNotification object:nil userInfo:@{@"videoId":self.movieModel.movieID}];
                        
                        if (ws.commentNumChanged) {
                            ws.commentNumChanged(NO, comment);
                        }
                    }else{
                        [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                    }
                } Failure:^(NSError *error) {
                    
                }];
            }else{
                //举报
                [[NewHttpRequestPort sharedNewHttpRequestPort] FeedbackreportList:@{@"target":@"comment"} Success:^(id responseObject) {
                    if ([responseObject[@"code"]intValue] == 0) {
                        NSMutableArray *describes = [NSMutableArray array];
                        NSMutableArray *ids = [NSMutableArray array];
                        
                        for (NSDictionary *dict in responseObject[@"data"]) {
                            [describes addObject:dict[@"name"]];
                            [ids addObject:dict[@"id"]];
                        }
                        ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr: describes cancelTitle:@"取消" cancelBlock:^{
                        } selectBlock:^(NSInteger index) {
                            [[NewHttpRequestPort sharedNewHttpRequestPort] Feedbackreport:@{@"id":ids[index],@"target_id":comment.comment_id,@"target_type":@"comment"} Success:^(id responseObject) {
                                if ([responseObject[@"code"]intValue] == 0) {
                                    [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                                }
                            } Failure:^(NSError *error) {
                            }];
                        }];
                        [action show];
                    }
                } Failure:^(NSError *error) {
                    
                }];
            }
        }
    }];
    [action show];
}

- (void)childCommentMoreAction:(BXCommentModel *)replyModel comment:(BXCommentModel *)comment index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    if (!index) {
        [self sendCommentView:0 aites:nil section:indexPath.section replyName:replyModel.nickname commentId:replyModel.comment_id];
    } else if (index == 1) {
        [self becomeFirstResponder];
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = replyModel.content;
        [BGProgressHUD showInfoWithMessage:@"复制成功"];
    } else {
        if ([replyModel.user_id isEqualToString:[BXLiveUser currentBXLiveUser].user_id]) {
            //删除
            [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentDeleteWithCommentID:replyModel.comment_id Success:^(id responseObject) {
                if ([responseObject[@"code"]intValue] == 0) {
                    [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                    comment.showChildCount--;
                    comment.reply_count = [NSString stringWithFormat:@"%ld",(long)[comment.reply_count integerValue]-1];
                    [comment.childCommentArray removeObjectAtIndex:indexPath.row];
                    if (comment.showChildCount > 1) {
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    } else {
                        [CATransaction begin];
                        [CATransaction setDisableActions:YES];
                        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                        [CATransaction commit];
                    }
                    if (self.commentNumChanged) {
                        self.commentNumChanged(NO, replyModel);
                    }
                }else{
                    [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                }
            } Failure:^(NSError *error) {
                
            }];
        }else{
            //举报
            [[NewHttpRequestPort sharedNewHttpRequestPort] FeedbackreportList:@{@"target":@"user"} Success:^(id responseObject) {
                if ([responseObject[@"code"]intValue] == 0) {
                    NSMutableArray *describes = [NSMutableArray array];
                    NSMutableArray *ids = [NSMutableArray array];
                    
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        [describes addObject:dict[@"name"]];
                        [ids addObject:dict[@"id"]];
                    }
                    ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr: describes cancelTitle:@"取消" cancelBlock:^{
                    } selectBlock:^(NSInteger index) {
                        [[NewHttpRequestPort sharedNewHttpRequestPort] Feedbackreport:@{@"id":ids[index],@"target_id":replyModel.user_id,@"target_type":@"user"} Success:^(id responseObject) {
                            if ([responseObject[@"code"]intValue] == 0) {
                                [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                            }
                        } Failure:^(NSError *error) {
                        }];
                    }];
                    [action show];
                }
            } Failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)replyComment:(BXCommentModel *)comment section:(NSInteger)section {
    [self sendCommentView:0 aites:nil section:section replyName:comment.nickname commentId:comment.comment_id];
}

- (void)toPersonHomeWithUserId:(NSString *)userId {
    [self commentViewhidden];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
    
    
//    [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:[[UIApplication sharedApplication] activityViewController].navigationController handle:nil];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.commentArray.count) {
        self.noDataLabel.hidden = YES;
    }else{
        self.noDataLabel.hidden = NO;
    }
    return self.commentArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BXCommentModel *model = self.commentArray[section];
    return MIN(model.showChildCount, model.childCommentArray.count);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXCommentModel *model = self.commentArray[indexPath.section];
    BXCommentModel *replyModel =  model.childCommentArray[indexPath.row];
    return replyModel.rowHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXCommentModel *model = self.commentArray[indexPath.section];
    BXCommentModel *replyModel =  model.childCommentArray[indexPath.row];
    GHDynCommentCell *cell = (GHDynCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"BXCommentCell"];
    cell.model = replyModel;
    WS(ws);
    cell.toPersonHome = ^{
        [ws toPersonHomeWithUserId:replyModel.user_id];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BXCommentModel *model = self.commentArray[indexPath.section];
    BXCommentModel *replyModel =  model.childCommentArray[indexPath.row];
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:@"回复"];
    [titles addObject:@"复制"];
    if (IsEquallString(replyModel.user_id, [BXLiveUser currentBXLiveUser].user_id)) {
        [titles addObject:@"删除"];
    }else{
        [titles addObject:@"举报"];
    }
    WS(ws);
    ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr:titles cancelTitle:@"取消" cancelBlock:^{
    } selectBlock:^(NSInteger index) {
        [ws childCommentMoreAction:replyModel comment:model index:index indexPath:indexPath];
    }];
    [action show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BXCommentModel *model = self.commentArray[section];
    return model.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GHDynCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXCommentHeaderView"];
    WS(ws);
    headerView.toPersonHome = ^(NSString * _Nonnull userID) {
        [ws toPersonHomeWithUserId:userID];
    };
//    headerView.sectionClick = ^(BXCommentModel * _Nonnull model) {
//        NSInteger index = [ws.commentArray indexOfObject:model];
//        [ws commentMoreAction:model section:index];
//    };
//    BXCommentModel *model = self.commentArray[section];
//    headerView.model = model;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    BXCommentModel *model = self.commentArray[section];
    if ([model.reply_count integerValue] > 1 && model.childCommentArray.count) {
        return 25.0f;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BXCommentModel *model = self.commentArray[section];
    if ([model.reply_count integerValue] > 1 && model.childCommentArray.count) {
        GHDynCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Footer"];
        footerView.comment = model;
        footerView.delegate = self;
        return footerView;
    }
    return nil;
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.scrollEnabled && scrollView.contentOffset.y <= 0) {
        scrollView.scrollEnabled = NO;
    }
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
    if (point.y > 0 ) {
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height + kFooterRefreshSpace > scrollView.contentSize.height) {
        if (scrollView.isNoMoreData || scrollView.isNoNetwork) {
            return;
        }
        if (!scrollView.isRefresh) {
            scrollView.isRefresh = YES;
            _offset = _commentArray.count;
            [self createData];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = YES;
}


#pragma - mark BXCommentFooterViewDelegate
- (void)showChildCommentWithComment:(BXCommentModel *)comment isOpen:(BOOL)isOpen view:(GHDynCommentFooterView *)view{
    NSInteger section = [self.commentArray indexOfObject:comment];
    if (isOpen) {
        NSInteger maxTempCount = [comment.reply_count integerValue] - comment.showChildCount;
        NSInteger tempCount = 0;
        NSInteger tempRow = comment.showChildCount;
        if (comment.showChildCount == 1) {
            tempCount = 2;
        } else {
            tempCount = 10;
        }
        if (tempCount > maxTempCount) {
            tempCount = maxTempCount;
        }
        comment.showChildCount += tempCount;
        if (comment.childCommentArray.count >= comment.showChildCount) {
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = 0; i < tempCount; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow + i inSection:section];
                [indexPaths addObject:indexPath];
            }
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            view.comment = comment;
        } else {
            if (comment.childCommentArray.count > tempRow) {
                [comment.childCommentArray removeObjectsInRange:NSMakeRange(tempRow, comment.childCommentArray.count - tempRow)];
            }
            [self loadChildCommentDataWithComment:comment Section:section view:view];
        }
    } else {
//        NSInteger tempCount = MIN(comment.showChildCount - 1, comment.childCommentArray.count - 1) ;
//        comment.showChildCount = 1;
//        if (tempCount > 0) {
//            NSMutableArray *indexPaths = [NSMutableArray array];
//            for (NSInteger i = 0; i < tempCount; i++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:section];
//                [indexPaths addObject:indexPath];
//            }
//            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            view.comment = comment;
//        }
        
        comment.showChildCount = 1;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
        [CATransaction commit];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

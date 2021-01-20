//
//  BXDynamicDetailsVC.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynamicDetailsVC.h"
#import "BXInsetsLable.h"
//#import "BXPersonHomeVC.h"
#import "DetailShowComentView.h"
#import "DetailHeaderView.h"
#import "DetailSendCommentView.h"
#import "GHDynNoPicCommentCell.h"
#import "GHDynHavePicCommentCell.h"
#import "GHDynCommentFooterView.h"
#import "GHDynCommentHeaderView.h"
#import "GHDynCommentPictureHeaderView.h"
#import "BXDynTipOffAlertView.h"
#import "BXDynTipOffVC.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynCommentModel.h"
#import "DetailBaseheaderView.h"
#import "DetailSoundView.h"
#import "DetailVideoView.h"
#import "DetailOnePicView.h"
#import "DetailMorePicView.h"
#import "BXDynCommentDetailVC.h"
#import "NSObject+Tag.h"
#import "BXDynCircelOperAlert.h"
#import "BXDynTopicCircleVideoVC.h"
#import "BXDynAlertRemoveSoundView.h"
#import "SLAppInfoConst.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"

@interface BXDynamicDetailsVC ()<UITableViewDelegate,UITableViewDataSource, DetailShowComentViewDelegate,HeaderDelegate>
@property(nonatomic, strong)UIView *navView;

@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isComment;
@property(nonatomic, strong)NSMutableArray *commentArray;
@property(nonatomic, strong)NSMutableArray *childcommentArray;
@property(nonatomic, strong)NSMutableArray *childcommentListArray;
@property(nonatomic, strong)NSMutableDictionary *childcommentDictionary;
@property (nonatomic ,strong) DetailShowComentView *commentView;

@property (nonatomic ,strong) DetailSoundView *soundHeaderView;
@property (nonatomic ,strong) DetailOnePicView *onePicHeaderView;
@property (nonatomic ,strong) DetailMorePicView *morePicHeaderView;
@property (nonatomic ,strong) DetailVideoView *videoHeaderView;
@end

@implementation BXDynamicDetailsVC

-(void)Didfold:(BXDynamicModel *)model{
    if (_soundHeaderView) {
        _soundHeaderView.model = model;
    }
    if (_onePicHeaderView) {
        _onePicHeaderView.model = model;
    }
    if (_morePicHeaderView) {
        _morePicHeaderView.model = model;
    }
    if (_videoHeaderView) {
        _videoHeaderView.model = model;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (_videoHeaderView) {
        [_videoHeaderView.player.currentPlayerManager play];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_videoHeaderView) {
        if ([_videoHeaderView.player.currentPlayerManager isPlaying]) {
            [_videoHeaderView.player.currentPlayerManager pause];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
    if (_soundHeaderView) {
        [_soundHeaderView.playSound StopPlay];
    }
}
-(instancetype)initWithType:(NSString *)type model:(BXDynamicModel *)model{
    self = [super init];
    if (self) {
        self.dynType = type;
        self.model = model;

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [BGProgressHUD showLoadingAnimation];
    
    self.commentArray = [[NSMutableArray alloc]init];
    self.childcommentArray = [[NSMutableArray alloc]init];
    self.childcommentDictionary = [[NSMutableDictionary alloc]init];
    self.childcommentListArray = [[NSMutableArray alloc]init];
    [self setNavView];
    [self footerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableView endRefreshingWithNoMoreData];
    [self.tableView registerClass:NSClassFromString(@"GHDynCommentHeaderView") forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [self.tableView registerClass:NSClassFromString(@"GHDynCommentPictureHeaderView") forHeaderFooterViewReuseIdentifier:@"picHeaderView"];
    
    [self.tableView registerClass:[GHDynCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"FooterView"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset( - 51 - __kBottomAddHeight);
    }];

    
    [self setHeaderView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.tableView reloadData];
    });

}
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    [self getData];

}
#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.commentArray.ds_Tag;
    [self getData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    if (point.y > 0 ) {
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height + 1 > scrollView.contentSize.height) {
        if (scrollView.isNoMoreData || scrollView.isNoNetwork) {
            return;
        }
        if (!scrollView.isRefresh) {
            scrollView.isRefresh = YES;
            [self loadMoreData];
        }
    }
}
-(void)getData{
    [HttpMakeFriendRequest CommentListWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"20" fcmid:self.model.fcmid Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (!self.page) {
               [self.commentArray removeAllObjects];
               self.commentArray.ds_Tag = 0;
               self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
               self.tableView.isNoMoreData = NO;
           }
        if (flag) {
            NSArray *array = jsonDic[@"data"][@"data"];
            if (array.count) {
                for (NSDictionary *dic in array) {
                    BXDynCommentModel *model = [[BXDynCommentModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [model processAttributedStringWithIsChild:NO];
                    model.toPersonHome = ^(NSString * _Nonnull userId) {
//                        [ws toPersonHomeWithUserId:userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":self.navigationController}];
//                        [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:self.navigationController handle:nil];
                    };
                    [self.commentArray addObject:model];
                }
                [self isHiddenHeaderBottom];
                self.commentArray.ds_Tag++;
                [self getEvaListData];
                
            }
            else {
                self.tableView.isNoMoreData = YES;
            }
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
-(void)getEvaListData{
    if (!self.commentArray.count) {
        return;
    }
//    [BGProgressHUD showLoadingAnimation];
    for (int i = 0; i < self.commentArray.count; i++) {
        [HttpMakeFriendRequest EvaluateListWithcommentid:[self.commentArray[i] contentid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            [BGProgressHUD hidden];
            if (flag) {
                NSArray *array = jsonDic[@"data"][@"data"];
                if (array.count) {
                    self.childcommentArray = [NSMutableArray array];
                    for (NSDictionary *dic in array) {
                        BXDynCommentModel *model = [[BXDynCommentModel alloc]init];
                        [model updateWithJsonDic:dic];
                        [model processAttributedStringWithIsChild:YES];
                        model.toPersonHome = ^(NSString * _Nonnull userId) {
//                            [ws toPersonHomeWithUserId:userId];
                            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":self.navigationController}];
                            
//                             [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:self.navigationController handle:nil];
                        };
                        [self.childcommentArray addObject:model];
                    }
                    [self.childcommentDictionary setValue:self.childcommentArray forKey:[self.commentArray[i] contentid]];
                }
                if (i == self.commentArray.count - 1) {
                    
                    [self.tableView reloadData];
                }
            }else{
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                [BGProgressHUD hidden];
            }
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD hidden];
        }];
    }
}
-(void)isHiddenHeaderBottom{
    if (_onePicHeaderView) {
        _onePicHeaderView.allcommentLabel.hidden = NO;
         _onePicHeaderView.NotCommentLable.hidden = YES;
    }
    if (_soundHeaderView) {
        _soundHeaderView.allcommentLabel.hidden = NO;
        _soundHeaderView.NotCommentLable.hidden = YES;
    }
    if (_morePicHeaderView) {
        _morePicHeaderView.allcommentLabel.hidden = NO;
        _morePicHeaderView.NotCommentLable.hidden = YES;
    }
    if (_videoHeaderView) {
        _videoHeaderView.allcommentLabel.hidden = NO;
        _videoHeaderView.NotCommentLable.hidden = YES;
    }

}
-(void)setHeaderView{
    NSInteger render_type = [self.dynType integerValue];
    if (render_type == 0 || render_type == 5 || render_type == 10 || render_type == 11 || render_type == 13){
        self.onePicHeaderView = [[DetailOnePicView alloc]init];
        self.onePicHeaderView.model = self.model;
        _onePicHeaderView.delegate = self;
//        CGFloat height = [_onePicHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        CGRect headerFrame = self.onePicHeaderView.frame;
//        headerFrame.size.height = height;
//        self.onePicHeaderView.frame = headerFrame;
        self.tableView.tableHeaderView = self.onePicHeaderView;
    }
    if (render_type == 1 || render_type == 2){
        self.morePicHeaderView = [[DetailMorePicView alloc]init];
        self.morePicHeaderView.model = self.model;
        CGFloat height = [self.morePicHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect headerFrame = self.morePicHeaderView.frame;
        headerFrame.size.height = height;
        self.morePicHeaderView.frame = headerFrame;
        _morePicHeaderView.delegate = self;
        self.tableView.tableHeaderView = self.morePicHeaderView;
    }
    if (render_type == 3 || render_type == 4 || render_type == 20){
        WS(weakSelf);
        self.videoHeaderView = [[DetailVideoView alloc]init];
        self.videoHeaderView.model = self.model;
        _videoHeaderView.delegate = self;
        self.videoHeaderView.DidPlaybtn = ^(UIButton * _Nonnull playbtn) {
            if (playbtn.selected) {
                weakSelf.videoHeaderView.model.isPlay = NO;
                [weakSelf.videoHeaderView.player.currentPlayerManager pause];
            }else{
                weakSelf.videoHeaderView.model.isPlay = YES;
                [weakSelf.videoHeaderView.player.currentPlayerManager play];
            }
        };
        self.videoHeaderView.Didamp = ^{
            
        };
        CGFloat height = [self.videoHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect headerFrame = self.videoHeaderView.frame;
        headerFrame.size.height = height;
        self.videoHeaderView.frame = headerFrame;
        _videoHeaderView.delegate = self;
        self.tableView.tableHeaderView = self.videoHeaderView;
    }
    if (render_type == 6){
        self.soundHeaderView = [[DetailSoundView alloc]init];
//        self.soundHeaderView.backgroundColor = [UIColor cyanColor];
        self.soundHeaderView.model = self.model;
//        CGFloat height = [self.soundHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        CGRect headerFrame = self.soundHeaderView.frame;
//        headerFrame.size.height = height;
//        self.soundHeaderView.frame = headerFrame;
        self.tableView.tableHeaderView = self.soundHeaderView;
    }
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
    WS(weakSelf);
    //    标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.navView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(weakSelf.navView.mas_bottom).offset(-22);
    }];
    [titleLabel setText:@"详情"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:CAFont(@"PingFangSC-Medium", 18)];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    

}

-(void)footerView{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.layer.borderWidth = 1;
    footerView.layer.borderColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.1].CGColor;
    footerView.layer.cornerRadius = 5;
    footerView.layer.masksToBounds = YES;
    [self.view addSubview:footerView];
    footerView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(51+__kBottomAddHeight);
    
    UIButton *textFieldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textFieldBtn.sd_cornerRadius = @(16);
    textFieldBtn.backgroundColor = sl_subBGColors;
    [textFieldBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [textFieldBtn setTitleColor:MinorColor forState:UIControlStateNormal];
    textFieldBtn.titleLabel.font = CFont(14);
    textFieldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textFieldBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [textFieldBtn addTarget:self action:@selector(sendComAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [picBtn setImage:CImage(@"dyn_issue_pickPic") forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(sendComAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setImage:CImage(@"dyn_issue_Emoji") forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(sendComAct) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView sd_addSubviews:@[textFieldBtn,picBtn,emojiBtn]];
    picBtn.sd_layout.topSpaceToView(footerView, 12).leftSpaceToView(footerView, 12).widthIs(26).heightIs(22);
    emojiBtn.sd_layout.topSpaceToView(footerView, 12).rightSpaceToView(footerView, 12).widthIs(23).heightIs(23);
    textFieldBtn.sd_layout.topSpaceToView(footerView, 5).leftSpaceToView(picBtn, 20).rightSpaceToView(emojiBtn, 20).heightIs(38);
}
-(void)sendComAct{
    WS(weakSelf);
    
    DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:self.model contentid:self.model.fcmid touid:@""];
    _view.sendComment = ^(BXDynCommentModel * _Nonnull model) {
        [model processAttributedStringWithIsChild:NO];
//        [weakSelf.commentArray insertObject:model atIndex:0];
//        [weakSelf.tableView reloadData];
        self.model.msgdetailmodel.comment_num = [NSString stringWithFormat:@"%d", [self.model.msgdetailmodel.comment_num intValue] + 1];
        [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCommentStatusNotification object:nil userInfo:@{@"model":self.model}];
        [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCommenAddtNumberNotification object:nil userInfo:nil];
        [weakSelf getData];
    };
    [self.view addSubview:_view];

    [_view show:0];
}
-(void)DelComment:(BXDynCommentModel *)model{
    WS(weakSelf);
    BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"删除",@"取消"]];
          OperationAlert.DidOpeClick = ^(NSInteger tag) {
              if (tag == 0) {

                  BXDynAlertRemoveSoundView *view =[[BXDynAlertRemoveSoundView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)Title:@"是否删除此评论" Sure:@"删除" Cancle:@"取消"];
                  view.RemoveBlock = ^{
                      [HttpMakeFriendRequest DelCommentWithcommentid:model.contentid Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                          if (flag) {
                              
                              self.model.msgdetailmodel.comment_num = [NSString stringWithFormat:@"%d", [self.model.msgdetailmodel.comment_num intValue] - 1];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCommentStatusNotification object:nil userInfo:@{@"model":self.model}];
                              [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCommenSubtNumberNotification object:nil userInfo:nil];
                              
                              [weakSelf getData];
                          }
                          [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                      } Failure:^(NSError * _Nonnull error) {
                          [BGProgressHUD showInfoWithMessage:@"操作失败"];
                      }];
                  };
                  [weakSelf.view addSubview:view];
              }
              
          };
          [OperationAlert showWithView:self.view];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return self.commentArray.count;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.childcommentDictionary objectForKey:[self.commentArray[section] contentid]] count] > 2) {
        return 2;
    }
    return [[self.childcommentDictionary objectForKey:[self.commentArray[section] contentid]] count];


}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    BXDynCommentModel *model = [[_childcommentDictionary objectForKey:[self.commentArray[indexPath.section] contentid]] objectAtIndex:indexPath.row];
    //    return [self cellHeightForIndexPath:section cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
        return model.headerHeight +5;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *piccell = @"morecell";
    GHDynNoPicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[GHDynNoPicCommentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }
    cell.model = [[_childcommentDictionary objectForKey:[self.commentArray[indexPath.section] contentid]] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WS(weakSelf);
    BXDynCommentModel *modellist = [[_childcommentDictionary objectForKey:[self.commentArray[indexPath.section] contentid]] objectAtIndex:indexPath.row];
    DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:self.model contentid:modellist.commentid touid:modellist.user_id];
    _view.replyComment = ^(BXDynCommentModel * _Nonnull model) {
//        [model processAttributedStringWithIsChild:YES];
//        [[weakSelf.childcommentDictionary objectForKey:[self.commentArray[indexPath.section] contentid]] insertObject:model atIndex:0];
        [weakSelf getEvaListData];
    };
    _view.replyName = modellist.nickname;
    _view.isReply = YES;
    [self.view addSubview:_view];

    [_view show:0];
    NSLog(@"%ld, %ld", (long)indexPath.section, (long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BXDynCommentModel *model = self.commentArray[section];
    //    return [self cellHeightForIndexPath:section cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
    if ([self.commentArray[section] imgs] && ![[self.commentArray[section] imgs]isEqualToString:@""]) {
        return model.headerHeight + 140;
    }else{
        return model.headerHeight + 60;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WS(weakSelf);
    if ([self.commentArray[section] imgs] && ![[self.commentArray[section] imgs]isEqualToString:@""]) {
        GHDynCommentPictureHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"picHeaderView"];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        BXDynCommentModel *model1 = self.commentArray[section];
        headerView.model = model1;
        headerView.SendMsgClick = ^(BXDynCommentModel * _Nonnull model) {
            
            DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:weakSelf.model contentid:model.contentid touid:@""];
            _view.isReply = YES;
            _view.replyName = model1.nickname;
            _view.replyComment = ^(BXDynCommentModel * _Nonnull model) {
//                [model processAttributedStringWithIsChild:YES];
//                [[weakSelf.childcommentDictionary objectForKey:[self.commentArray[section] contentid]] insertObject:model atIndex:0];
//                [weakSelf.tableView reloadData];
                [weakSelf getEvaListData];
            };
            [weakSelf.view addSubview:_view];
    
            [_view show:0];
        };

        headerView.clicktipoff = ^(BXDynCommentModel * _Nonnull model) {
            
            if ([[NSString stringWithFormat:@"%@", model.uid] isEqualToString:[NSString stringWithFormat:@"%@", [BXLiveUser currentBXLiveUser].user_id]]) {
                [self DelComment:model];
                return;
            }
            
            BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报",@"取消"]];
                   OperationAlert.DidOpeClick = ^(NSInteger tag) {
                       if (tag == 0) {
                           
                           BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
                           BXDynamicModel *dynmodel = [BXDynamicModel new];
                           vc.reporttype = @"7";
                           vc.reportmsg_id = model.contentid;
                           dynmodel.msgdetailmodel.user_id = model.user_id;
                           dynmodel.msgdetailmodel.nickname = model.nickname;
                           dynmodel.msgdetailmodel.content = model.content;
                           vc.model = dynmodel;
                           [self pushVc:vc];
                       }
                   
                   };
               [OperationAlert showWithView:self.view];
        };
        return headerView;
    }
    else{
        GHDynCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
        BXDynCommentModel *model1 = self.commentArray[section];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.model = model1;
        headerView.SendMsgClick = ^(BXDynCommentModel * _Nonnull model) {
            DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:weakSelf.model contentid:model.contentid touid:@""];
            _view.isReply = YES;
            _view.replyName = model1.nickname;
            _view.replyComment = ^(BXDynCommentModel * _Nonnull model) {
//                [model processAttributedStringWithIsChild:YES];
//                [[weakSelf.childcommentDictionary objectForKey:[self.commentArray[section] contentid]] insertObject:model atIndex:0];
//                [weakSelf.tableView reloadData];
                [weakSelf getEvaListData];
            };
            [weakSelf.view addSubview:_view];
            
            [_view show:0];
        };

        headerView.clicktipoff = ^(BXDynCommentModel * _Nonnull model) {
            
            if ([[NSString stringWithFormat:@"%@", model.uid] isEqualToString:[NSString stringWithFormat:@"%@", [BXLiveUser currentBXLiveUser].user_id]]) {
                [self DelComment:model];
                return;
            }
            
            BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报",@"取消"]];
            OperationAlert.DidOpeClick = ^(NSInteger tag) {
                if (tag == 0) {
                    
                    BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
                    vc.reporttype = @"7";
                    vc.reportmsg_id = model.contentid;
                    BXDynamicModel *dynmodel = [BXDynamicModel new];
                    dynmodel.msgdetailmodel.user_id = model.user_id;
                    dynmodel.msgdetailmodel.nickname = model.nickname;
                    dynmodel.msgdetailmodel.content = model.content;
                    
                    vc.model = dynmodel;
                    [self pushVc:vc];
                }
                
            };
            [OperationAlert showWithView:self.view];
        };
        return headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    BXCommentModel *model = self.commentArray[section];
//    if ([model.reply_count integerValue] > 1 && model.childCommentArray.count) {
//        return 25.0f;
//    }
    if ([[_childcommentDictionary objectForKey:[self.commentArray[section] contentid]] count] >= 1 ) {
        return 30;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WS(weakSelf);
    GHDynCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FooterView"];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    footerView.listNum = [[_childcommentDictionary objectForKey:[self.commentArray[section] contentid]] count];
    footerView.toListform = ^{
        BXDynCommentDetailVC *vc = [[BXDynCommentDetailVC alloc]init];
        vc.model = self.commentArray[section];
        vc.dataArray = [weakSelf.childcommentDictionary objectForKey:[self.commentArray[section] contentid]];
        [self pushVc:vc];
    };
    if ([[_childcommentDictionary objectForKey:[self.commentArray[section] contentid]] count] >= 1 ) {
        footerView.hidden = NO;
    }else{
        footerView.hidden = YES;
    }
    return footerView;
    

}



-(void)backClick{
    [self pop];
}
#pragma mark --headerviewDelegate
-(void)DidClickType:(NSInteger)type{
    if (type == 2) {
        BXDynTipOffAlertView *alert = [[BXDynTipOffAlertView alloc]initWithFrame:CGRectMake(0, -84 - __kTopAddHeight, self.view.frame.size.width, self.view.frame.size.height +84 + __kTopAddHeight) user_id:@""];
        alert.determineBlock = ^(NSString * _Nonnull user_id, NSInteger tag) {
            NSLog(@"%ld", (long)tag);
            BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
//            vc.model = [[BXDynNewModel alloc]init];
            vc.reporttype = @"2";
            [self pushVc:vc];
        };
        [alert showWithView:self.view];
    }
}

-(void)guanzhuAct{
    
}
-(void)moreAct:(id)sender{
    BXDynTipOffAlertView *alert = [[BXDynTipOffAlertView alloc]initWithFrame:CGRectMake(0, -84 - __kTopAddHeight, self.view.frame.size.width, self.view.frame.size.height +84 + __kTopAddHeight) user_id:@""];
    alert.determineBlock = ^(NSString * _Nonnull user_id, NSInteger tag) {
        NSLog(@"%ld", (long)tag);
        BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
        vc.reporttype = @"2";
//        vc.model = [[BXDynNewModel alloc]init];
        [self pushVc:vc];
    };
    [alert showWithView:self.view];
}
-(void)dealloc{
    _soundHeaderView = nil;
}
@end

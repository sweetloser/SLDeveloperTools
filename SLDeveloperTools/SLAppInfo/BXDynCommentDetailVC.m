//
//  BXDynCommentDetailVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCommentDetailVC.h"
#import "BXDynDetailNoPicCommentView.h"
#import "BXDynPicDetailCommentView.h"
#import "GHDynCommentHeaderView.h"
#import "DetailSendCommentView.h"
#import "BXDynCircelOperAlert.h"
#import "BXDynTipOffVC.h"
#import "BXDynAlertRemoveSoundView.h"
#import "HttpMakeFriendRequest.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import "../SLUtilities/SLUtilities.h"


@interface BXDynCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@end

@implementation BXDynCommentDetailVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self footerView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.tableView registerClass:NSClassFromString(@"GHDynCommentHeaderView") forHeaderFooterViewReuseIdentifier:@"HeaderView"];
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
-(void)setHeaderView{

    if ([self.model imgs] && ![[self.model imgs]isEqualToString:@""] ){
        BXDynPicDetailCommentView *headerView = [[BXDynPicDetailCommentView alloc]init];
        headerView.model = self.model;
        headerView.clicktipoff = ^(BXDynCommentModel * _Nonnull model) {
            if ([[NSString stringWithFormat:@"%@", model.uid] isEqualToString:[NSString stringWithFormat:@"%@", [BXLiveUser currentBXLiveUser].user_id]]) {
                    [self DelComment:model section:0 isHeaderComment:YES];
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
//        CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        CGRect headerFrame = headerView.frame;
//        headerFrame.size.height = height;
//        headerView.frame = headerFrame;
        self.tableView.tableHeaderView = headerView;
       
    }
    else{
        BXDynDetailNoPicCommentView *headerView = [[BXDynDetailNoPicCommentView alloc]init];
        headerView.model = self.model;
        headerView.clicktipoff = ^(BXDynCommentModel * _Nonnull model) {
            if ([[NSString stringWithFormat:@"%@", model.uid] isEqualToString:[NSString stringWithFormat:@"%@", [BXLiveUser currentBXLiveUser].user_id]]) {
                    [self DelComment:model section:0 isHeaderComment:YES];
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
//        CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        CGRect headerFrame = headerView.frame;
//        headerFrame.size.height = height;
//        headerView.frame = headerFrame;
        self.tableView.tableHeaderView = headerView;
    }
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"评论详情";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.width.mas_equalTo(__ScaleWidth(72/4*6));
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_navView.mas_bottom).offset(-22);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];

}
-(void)backClick{
    [self pop];
}
-(void)DelComment:(BXDynCommentModel *)model section:(NSInteger)section isHeaderComment:(BOOL)headComment{
    NSString *commentid = @"";
    if (headComment) {
        commentid = [NSString stringWithFormat:@"%@", model.contentid];
    }
    else{
        commentid = [NSString stringWithFormat:@"%@", model.contentid];
    }
    WS(weakSelf);
    BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"删除",@"取消"]];
          OperationAlert.DidOpeClick = ^(NSInteger tag) {
              if (tag == 0) {

                  BXDynAlertRemoveSoundView *view =[[BXDynAlertRemoveSoundView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)Title:@"是否删除此评论" Sure:@"删除" Cancle:@"取消"];
                  view.RemoveBlock = ^{
                      [HttpMakeFriendRequest DelEvaluateCommentWithcommentid:commentid Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                              if (flag) {
                                  if (headComment) {
                                      [weakSelf pop];
                                  }else{
                                  [weakSelf.dataArray removeObjectAtIndex:section];
                                  [weakSelf.tableView reloadData];
                                  }
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

    return self.dataArray.count;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
 return 0;


}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableView];
    
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *piccell = @"morecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }
//    cell.model = [[_childcommentDictionary objectForKey:[self.commentArray[indexPath.section] contentid]] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BXDynCommentModel *model = self.dataArray[section];
  
        return model.ChildheaderHeight + 60;
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WS(weakSelf);
    
    GHDynCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    BXDynCommentModel *modellist = self.dataArray[section];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.isChild = YES;
    headerView.model = modellist;
    headerView.SendMsgClick = ^(BXDynCommentModel * _Nonnull model) {
        DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:nil contentid:modellist.commentid touid:modellist.user_id];
        _view.isReply = YES;
        _view.replyName = modellist.nickname;
//        model.isChildAttatties = YES;
//        [model processAttributedStringWithIsChild:NO];
//        [self.dataArray insertObject:model atIndex:0];
        _view.replyComment = ^(BXDynCommentModel * _Nonnull model) {
            model.isChildAttatties = YES;
            [model processAttributedStringWithIsChild:NO];
            [weakSelf.dataArray insertObject:model atIndex:0];
            [weakSelf.tableView reloadData];
        };
        [self.view addSubview:_view];
            [_view show:0];
    };
    headerView.clicktipoff = ^(BXDynCommentModel * _Nonnull model) {
        
        if ([[NSString stringWithFormat:@"%@", model.uid] isEqualToString:[NSString stringWithFormat:@"%@", [BXLiveUser currentBXLiveUser].user_id]]) {
            [self DelComment:model section:section isHeaderComment:NO];
            return;
        }
        
        BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报",@"取消"]];
        OperationAlert.DidOpeClick = ^(NSInteger tag) {
            if (tag == 0) {
                
                BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
                vc.reporttype = @"8";
                vc.reportmsg_id = model.commentid;
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
    textFieldBtn.backgroundColor = UIColorHex(#F5F9FC);
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
    DetailSendCommentView *_view = [[DetailSendCommentView alloc]initWithFrame:CGRectZero array:@[] model:nil contentid:self.model.contentid touid:@""];
    
    _view.isReply = YES;
    _view.replyName = self.model.nickname;
    _view.replyComment = ^(BXDynCommentModel * _Nonnull model) {
        model.isChildAttatties = YES;
        [model processAttributedStringWithIsChild:NO];
        [self.dataArray insertObject:model atIndex:0];
        [self.tableView reloadData];
    };
    [self.view addSubview:_view];

        [_view show:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

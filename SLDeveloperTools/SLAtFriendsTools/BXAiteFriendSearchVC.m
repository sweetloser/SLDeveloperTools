//
//  BXAiteFriendSearchVC.m
//  BXlive
//
//  Created by bxlive on 2019/5/9.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAiteFriendSearchVC.h"
#import "BXAiteFriendCell.h"
#import "BXAttentFollowModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLAppInfo/SLAppInfo.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"

@interface BXAiteFriendSearchVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *followsArray;
@property (nonatomic , strong) NSMutableArray *tempArray;
@property (nonatomic,strong) UITextField *searchField;
@end

@implementation BXAiteFriendSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, __kWidth-80, 34)];
    self.searchField.placeholder = @"搜索ID或昵称";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入占位文字" attributes:@{NSForegroundColorAttributeName:MinorColor,NSFontAttributeName:self.searchField.font}];
    self.searchField.attributedPlaceholder = attrString;
    self.searchField.backgroundColor = PageSubBackgroundColor;
    self.searchField.layer.masksToBounds = YES;
    self.searchField.layer.cornerRadius = 17;
    self.searchField.font = CFont(14);
    self.searchField.textColor = MainTitleColor;
    UIView *left = [[UIView alloc] init];
    left.frame = CGRectMake(0, 0, 35, 34);
    self.searchField.leftView = left;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.navigationItem.titleView = self.searchField;
    self.searchField.delegate = self;
    [self.searchField becomeFirstResponder];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(9, 8, 18, 18)];
    icon.image = [UIImage imageNamed:@"icon_search_1"];
    [self.searchField addSubview:icon];
    UIButton *clearBtn =[self.searchField valueForKey:@"_clearButton"];
    [clearBtn setImage:CImage(@"login_clear") forState:BtnNormal];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 40, 40);
    searchBtn.titleLabel.font = CFont(15);
    [searchBtn setTitleColor:normalColors forState:UIControlStateNormal];
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:bgImageView];
    bgImageView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view);
    self.tempArray = [NSMutableArray array];
    [self createTableView];
    
}

- (void)search
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self TableDragWithDown];
    [textField endEditing:YES];
    return YES;
}

- (NSMutableArray *)followsArray{
    if (!_followsArray) {
        _followsArray = [NSMutableArray array];
    }
    return _followsArray;
}

- (void)TableDragWithDown
{
    [self createData];
}

#pragma mark - 请求数据
- (void)createData{
    [BGProgressHUD showLoadingAnimation];
    [[NewHttpRequestPort sharedNewHttpRequestPort] FriendsSearch:@{@"key_words":self.searchField.text} Success:^(id responseObject) {
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        if([responseObject[@"code"] integerValue] == 0)
        {
            [self.followsArray removeAllObjects];
            NSArray *followArray = responseObject[@"data"];
            if (followArray.count) {
                for (NSDictionary *fdict in followArray) {
                    BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary:fdict];
                    [self.followsArray addObject:model];
                }
            }
            
        } else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        [self.tableView reloadData];
        self.tableView.isNoNetwork = NO;
    } Failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
    
}

#pragma mark - 创建表单视图
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (self.followsArray.count) {
            return 40;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXAiteFriendCell *cell = [BXAiteFriendCell cellWithTableView:tableView];
    cell.model = self.followsArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BXAttentFollowModel *model =  self.followsArray[indexPath.row];
    [self selectModel:model];
}

-(void)selectModel:(BXAttentFollowModel *)model{
    NSLog(@"%@",self.friendArray);
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.friendArray.count>0) {
        BOOL ishave = NO;
        for (NSDictionary *dic in self.friendArray) {
            if (IsEquallString(model.user_id, dic[@"id"])) {
                ishave = YES;
                break;
            }
        }
        if (ishave) {
            [BGProgressHUD showInfoWithMessage:@"您已@过TA了"];
        }else{
            [self.tempArray addObject:@{@"name":[NSString stringWithFormat:@"%@%@",@"@",[NSString stringWithFormat:@"%@ ",model.nickname]],@"id":model.user_id}];
            if (self.selectTextArray) {
                self.selectTextArray(self.tempArray);
            }
           
            
        }
    }else{
        [self.tempArray addObject:@{@"name":[NSString stringWithFormat:@"%@%@",@"@",[NSString stringWithFormat:@"%@ ",model.nickname]],@"id":model.user_id}];
        if (self.selectTextArray) {
            self.selectTextArray(self.tempArray);
        }
//        [self dismissViewControllerAnimated:NO completion:nil];
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"BXFriendViewVCHeader";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
        header.contentView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [UILabel initWithFrame:CGRectZero size:14 color:MainTitleColor alignment:0 lines:1];
        
        [header.contentView addSubview:label];
        label.sd_layout.leftSpaceToView(header.contentView, 16).topSpaceToView(header.contentView, 0).bottomSpaceToView(header.contentView, 0).rightSpaceToView(header.contentView, 16);
        label.text = @"搜索的人";
    }
    return header;
}



#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            [ws TableDragWithDown];
        };
        return noNetworkView;
    }
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"这里还没有内容哦~";
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:MinorColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}


#pragma - mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
@end

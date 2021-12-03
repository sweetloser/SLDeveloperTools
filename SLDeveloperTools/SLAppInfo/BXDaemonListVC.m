//
//  BXDaemonListVC.m
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXDaemonListVC.h"
#import "BXDaemonListModel.h"
#import "BXDaemonFirstCell.h"
#import "BXDaemonSecondCell.h"
#import "BXGift.h"
#import "SLRuleDescriptionView.h"
#import "BXDaemonListHeadView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#import "SLDeveloperTools.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>

#define beishu             MIN(SCREEN_WIDTH,SCREEN_HEIGHT) / 375.0

@interface BXDaemonListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *allArray;


@property (copy, nonatomic) NSString *user_id;

@property (strong, nonatomic) BXDaemonListHeadView *deamonListHeadView;

@property(nonatomic, strong) UIImageView *topImageView;

@property(nonatomic,strong)UIView *navigationView;

@end

@implementation BXDaemonListVC

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = sl_BGColors;


    if (!self.type) {
//        弹框
        self.view.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adminxin:) name:@"daemonList" object:nil];
    }else{
//        全屏页面
        self.fd_prefersNavigationBarHidden = YES;
        [self setupNavigationView];
         [self loadData:[BXLiveUser currentBXLiveUser].user_id];
    }
    [self initView];
}
-(void)setupNavigationView{
    _navigationView = [UIView new];
    [self.view addSubview:_navigationView];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(__kTopAddHeight+64);
    }];
    [_navigationView setBackgroundColor:[UIColor sl_colorWithHex:0xFFFFFF]];
    WS(weakSelf);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [_navigationView addSubview:backBtn];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"守护列表" Font:SLBFont(__GenScaleWidth(18)) TextColor:sl_textColors];
    label.textAlignment = 1;
    [_navigationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-44);
        make.centerY.equalTo(weakSelf.navigationView.mas_bottom).offset(-22);
        make.height.mas_equalTo(25);
    }];
    
}
- (void)initView {
    if (self.type) {
        
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12 , 12)];
//
//        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//        shapeLayer.frame = self.view.bounds;
//        shapeLayer.path = path.CGPath;
//        self.view.layer.mask = shapeLayer;
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.navigationView.mas_bottom);
        }];
    }else{
        
//        弹框
        UIImageView *titleImg = [[UIImageView alloc]init];
        [self.view addSubview:titleImg];
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(__GenScaleWidth(84));
            make.height.mas_equalTo(__GenScaleWidth(97));
        }];
        titleImg.image = [UIImage imageNamed:@"lc_live_guard_title"];
        CGFloat topW = __GenScaleWidth(75);
        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-__GenScaleWidth(0));
            make.centerY.equalTo(titleImg.mas_centerY).offset(__GenScaleWidth(4));
            make.width.height.mas_equalTo(topW);
        }];
        self.topImageView.layer.masksToBounds = YES;
        self.topImageView.layer.cornerRadius = topW / 2;
        
        UIView *temView = [[UIView alloc]init];
        [self.view addSubview:temView];
        temView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12 , 12)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = self.view.bounds;
        shapeLayer.path = path.CGPath;
        temView.layer.mask = shapeLayer;
        [temView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(__GenScaleWidth(45));
            make.height.mas_equalTo(__GenScaleWidth(85));
        }];
//        主播在等你守护TA哦~
        UILabel *waitForYouL = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"主播在等你守护TA哦~" Font:SLPFFont(__GenScaleWidth(12)) TextColor:sl_textColors];
        [temView addSubview:waitForYouL];
        [waitForYouL setTextAlignment:NSTextAlignmentCenter];
        [waitForYouL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__GenScaleWidth(17));
            make.bottom.mas_equalTo(__GenScaleWidth(-10));
        }];
        
//        右边的规则
        UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [temView addSubview:ruleBtn];
        [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(__GenScaleWidth(72));
            make.height.mas_equalTo(__GenScaleWidth(40));
            make.top.mas_equalTo(0);
        }];
        [ruleBtn setTitle:@"规则说明" forState:BtnNormal];
        [ruleBtn setTitleColor:sl_textSubColors forState:BtnNormal];
        ruleBtn.titleLabel.font = SLPFFont(__GenScaleWidth(12));
        [ruleBtn addTarget:self action:@selector(ruleBtnOnClick) forControlEvents:BtnTouchUpInside];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [self.topImageView setImage:[UIImage imageNamed:@"placeholder_guard_82"]];
        [self.view bringSubviewToFront:self.topImageView];
        [self.view bringSubviewToFront:titleImg];
    }
}

-(void)ruleBtnOnClick{
    NSLog(@"规则说明");
    
    SLRuleDescriptionView *view = [[SLRuleDescriptionView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [view show];
}

-(void)adminxin:(NSNotification *)sender {
    _user_id = sender.userInfo[@"user_id"];
    if (!IsNilString(_user_id)) {
        [self loadData:_user_id];
    }
}
-(void)loadData:(NSString *)userId{
    [NewHttpManager guardListWithUserId:userId success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            [self.allArray removeAllObjects];
            NSArray *dataDic = jsonDic[@"data"];
            for (NSDictionary *dic in dataDic) {
                BXDaemonListModel *model = [[BXDaemonListModel alloc]init];
                model.type = self.type;
                [model updateWithJsonDic:dic];
                [self.allArray addObject:model];
            }
            [self.tableView reloadData];
            [self updateTitleImage];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)updateTitleImage{
    if (self.allArray.count > 0) {
//        BXDaemonListModel *m = [self.allArray firstObject];
//        [self.topImageView yy_setImageWithURL:[NSURL URLWithString:m.avatar] placeholder:[UIImage imageNamed:@"placeholder_guard_82"]];
//        UITapGestureRecognizer *toptap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//               [BXPersonHomeVC toPersonHomeWithUserId:m.user_id isShow:nil nav:self.navigationController handle:nil];
//           }];
//           [self.topImageView addGestureRecognizer:toptap];
//           self.topImageView.userInteractionEnabled = YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.type) {
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __GenScaleWidth(375), __GenScaleWidth(200))];
    BXDaemonListHeadView *view = [[BXDaemonListHeadView alloc]initWithFrame:CGRectMake(0, 0, __GenScaleWidth(375), __GenScaleWidth(200))];
    
    self.deamonListHeadView = view;
    WS(weakSelf);
    self.deamonListHeadView.buyCallBackBlock = ^(BXGift * _Nonnull gift) {
//        点击了购买
        NSLog(@"购买%@",gift.name);
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendGiftWithData:andLianFa:type:)]) {
            [weakSelf.delegate sendGiftWithData:@{@"gift_id":gift.giftId,@"gift_amount":@"1"} andLianFa:@"n" type:@"gift"];
        }
        
    };
    [headview addSubview:view];
    headview.backgroundColor = [UIColor clearColor];
//    if (_allArray.count == 0) {
//        UILabel *nonLabel = [[UILabel alloc]init];
//        [headview addSubview:nonLabel];
//        nonLabel.font = SLPFFont(14);
//        nonLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
//        nonLabel.text  = @"暂无人上榜";
//        [nonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(view.mas_bottom).offset(0);
//        }];
//    }else{
//
//    }
    
    return headview;
    }
    else{
        return nil;
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.type) {
        return __GenScaleWidth(200);
    }
    return 0.01;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allArray.count >  3) {
        return self.allArray.count - 2;
    }else if (self.allArray.count == 0){
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160 * beishu;
    }
    return 63 * beishu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        BXDaemonFirstCell *cell = [BXDaemonFirstCell cellWithTabelView:tableView];
        [cell updateUIWithDataList:self.allArray];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        BXDaemonSecondCell *cell = [BXDaemonSecondCell cellWithTabelView:tableView];
        
        BXDaemonListModel *model = [self.allArray objectAtIndex:indexPath.row+2];
        
        [cell loadCellData:model indexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allArray.count >= 4 ) {
        if (indexPath.row > 0) {
//            BXDaemonListModel *model = self.allArray[indexPath.row + 3];
//            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":model.user_id,@"isShow":@"",@"nav":self.navigationController}];
//            [BXPersonHomeVC toPersonHomeWithUserId:model.user_id isShow:nil nav:self.navigationController handle:nil];
        }
        
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.type) {
        return [UIImage imageNamed:@"空页面状态"];
    }
    return nil;
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"";
    if (self.type) {
        text = @"这里还没有内容哦~";
    }
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
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;{
//    return NO;
//}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;{
    return __GenScaleWidth(60);
}

#pragma - mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end

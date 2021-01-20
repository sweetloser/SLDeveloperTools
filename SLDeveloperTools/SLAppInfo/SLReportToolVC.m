//
//  SLReportToolVC.m
//  BXlive
//
//  Created by sweetloser on 2020/12/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLReportToolVC.h"
#import "BXDynTipOffCell.h"
#import "BXDynTipOffTextView.h"
#import "HttpMakeFriendRequest.h"
#import "SLReportToolModel.h"
#import "SLReportToolCell.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import "NewHttpManager.h"
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>

@interface SLReportToolVC ()<UITableViewDelegate,UITableViewDataSource, ReturnContentTextDelegate>

@property(nonatomic,copy)NSString *apiString;

@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *issueBtn;

@property (strong, nonatomic) BXDynTipOffTextView *tipOffTextView;
@property(nonatomic, strong)UILabel *tipoffObjLabel;
@property(nonatomic, strong)UILabel *tipoffConcentLabel;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selectedArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign)BOOL ifSelected;

@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)NSMutableArray *typeArray;
@end

@implementation SLReportToolVC
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
        self.selectedArray = [[NSMutableArray alloc]init];
        
        self.typeArray = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.fd_prefersNavigationBarHidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [self.tipOffTextView.textView resignFirstResponder];
//    }];
//    [self.view addGestureRecognizer:tap];
    
}
-(void)initView{
    self.ifSelected = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00];
    [self setNavView];
    [self setHeaderView];
    [self initTableView];
}

-(void)setAmwayDetailModel:(SLAmwayDetailModel *)amwayDetailModel{
    _amwayDetailModel = amwayDetailModel;
    _apiString = @"plantinggrass/api/Report/getReportEntryList";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"举报 %@ 发布的内容", amwayDetailModel.usermsg.nickname]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor sl_colorWithHex:0xEF6856] range:NSMakeRange(3, amwayDetailModel.usermsg.nickname.length)];
    _tipoffObjLabel.attributedText = str;
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", amwayDetailModel.usermsg.nickname,amwayDetailModel.content]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor sl_colorWithHex:0xEF6856] range:NSMakeRange(0, amwayDetailModel.usermsg.nickname.length)];
    _tipoffConcentLabel.attributedText = str1;
    
    WS(weakSelf);
    
    [[NewHttpManager sharedNetManager] APIPOST:_apiString parameters:@{@"report_id":amwayDetailModel.msg_id} success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if ([code integerValue] == 0) {
            NSArray *data = responseObject[@"data"];
            if (data && [data isArray] && data.count > 0) {
                for (NSDictionary *dict in data) {
                    SLReportToolModel *model = [SLReportToolModel mj_objectWithKeyValues:dict];
                    model.isSelected = NO;
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"举报内容";
    _viewTitlelabel.textColor = sl_textColors;
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
   UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
    [_issueBtn setTitle:@"提交" forState:UIControlStateNormal];
    _issueBtn.titleLabel.font = SLPFFont(14);
    [_issueBtn setTitleColor:sl_textSubColors forState:UIControlStateNormal];
    _issueBtn.backgroundColor = DynDownLineColor;
    
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
    _issueBtn.userInteractionEnabled = NO;
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
}
-(void)setHeaderView{
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(10);
        make.height.mas_equalTo(87);
    }];
    
    _tipoffObjLabel = [[UILabel alloc]init];
    _tipoffObjLabel.textColor = sl_textSubColors;
    _tipoffObjLabel.font = [UIFont systemFontOfSize:16];
    [backview addSubview:_tipoffObjLabel];
    [_tipoffObjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview.mas_left).offset(12);
        make.right.mas_equalTo(backview.mas_right).offset(-12);
        make.top.mas_equalTo(backview.mas_top).offset(12);
        make.height.mas_equalTo(24);
    }];
    
    _tipoffConcentLabel = [[UILabel alloc]init];
    _tipoffConcentLabel.textColor = sl_textColors;
    _tipoffConcentLabel.font = [UIFont systemFontOfSize:14];
    [backview addSubview:_tipoffConcentLabel];
    [_tipoffConcentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview.mas_left).offset(12);
        make.right.mas_equalTo(backview.mas_right).offset(-12);
        make.top.mas_equalTo(self.tipoffObjLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(backview.mas_bottom).offset(-12);
    }];
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(107);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
    }];
    
    _tipOffTextView = [[BXDynTipOffTextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];
    _tipOffTextView.delegate = self;
    self.tableView.tableFooterView = _tipOffTextView;
    _tipOffTextView.hidden = YES;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionview = [[UIView alloc]init];
    sectionview.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"举报理由";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = 0;
    [sectionview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionview.mas_centerY);
        make.left.mas_equalTo(sectionview.mas_left).offset(12);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(70);
    }];
    return sectionview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *piccell = @"cell1";
    SLReportToolCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[SLReportToolCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }
    
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SLReportToolModel *tm = self.dataArray[indexPath.row];
    
    tm.isSelected = !tm.isSelected;
    
    
    if (tm.isSelected) {
        if (!self.canMutiSelected) {
            for (SLReportToolModel *stm in self.selectedArray) {
                stm.isSelected = NO;
            }
            [self.selectedArray removeAllObjects];
        }
        [self.selectedArray addObject:tm];
    }else{
        [self.selectedArray removeObject:tm];
    }
    if (self.selectedArray.count > 0) {
        
        [_issueBtn setTitleColor:sl_whiteTextColors forState:UIControlStateNormal];
        _issueBtn.backgroundColor = sl_normalColors;
        _issueBtn.userInteractionEnabled = YES;
    }else{
        [_issueBtn setTitleColor:sl_textSubColors forState:UIControlStateNormal];
        _issueBtn.backgroundColor = sl_subBGColors;
        _issueBtn.userInteractionEnabled = NO;
    }
    
    [self.tableView reloadData];
    
//    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
}

-(void)AddClick{
    [self reportAct];
}
-(void)reportAct{
    NSMutableArray *ids = [NSMutableArray new];
    for (SLReportToolModel *trm in self.selectedArray) {
        [ids addObject:trm.report_id];
    }
    WS(weakSelf);
    
    NSString * report_type = @"1";
    if (self.reportType == SLReportTypeAmwayPicture) {
        report_type = @"1";
    }
    if (self.reportType == SLReportTypeComment) {
        report_type = @"2";
    }
    if (self.reportType == SLReportTypeEvaluate) {
        report_type = @"3";
    }
        [[NewHttpManager sharedNetManager] APIPOST:@"plantinggrass/api/Report/report" parameters:@{@"report_type":report_type,@"report_msg_id":self.amwayDetailModel.msg_id,@"type":[ids componentsJoinedByString:@","]} success:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            
            NSNumber *code = responseObject[@"code"];
            NSString *msg = responseObject[@"message"];
            if ([code integerValue] == 0) {
//                成功了
                [weakSelf pop];
            }
            [SLProgressHUD slShowInfoWithMessage:msg];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    
}
-(void)backClick{
    [self pop];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tipOffTextView.textView resignFirstResponder];
}
#pragma - mark ReturnTipOffTextDelegate
-(void)GetTipOffText:(NSString *)string{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tipOffTextView.textView resignFirstResponder];
}
#pragma - mark NSNotification
- (void)keyboardWillHide:(NSNotification *)noti {
//    [self.tableView layoutIfNeeded];
//    [self.tableView layoutSubviews];
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.navView.mas_bottom).offset(107);
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-__kBottomAddHeight);
//    }];
//    [self.tableView beginUpdates];
//    [self.tableView scrollToTop];
//    [self.tableView endUpdates];
     self.view.frame = CGRectMake(0, 0, __kWidth, __kHeight);
}
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo=noti.userInfo;
    NSValue *keyBoardEndBounds=userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    CGFloat keyboardhight=endRect.size.height;
    self.view.frame = CGRectMake(0, -keyboardhight, __kWidth, __kHeight);
}
@end

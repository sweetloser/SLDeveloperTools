//
//  BXShortVideoLocationSearchVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXShortVideoLocationSearchVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "BXLocation.h"
#import "BXAddLocaionCell.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
@interface BXShortVideoLocationSearchVC ()< AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, strong) UILabel *placeLabel;

@property (nonatomic, strong) UIButton *freshBtn;

@property (nonatomic, strong) UILabel *noshowLabel;

@property (assign, nonatomic) NSInteger offset;

@end

@implementation BXShortVideoLocationSearchVC
-(void)viewWillDisappear:(BOOL)animated{
    [self.searchField resignFirstResponder];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
   self.view.backgroundColor = sl_BGColors;
    self.offset = 1;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self loadData];
    [self initNavigationView];
    [self initTableView];
}
-(void)loadData {
    BXLocation *location = (BXLocation *)[CacheHelper objectForKey:@"NowLocation"];
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    //当前位置
    request.location = [AMapGeoPoint locationWithLatitude:[location.lat floatValue] longitude:[location.lng floatValue]];
    //关键字
    request.page = self.offset;
//    request.requireExtension = YES;
    //发起周边搜索
    [self.search AMapPOIAroundSearch:request];
}
- (void)initNavigationView {
    
//    UIImageView *bgImageView = [[UIImageView alloc] init];
//    bgImageView.userInteractionEnabled = YES;
//    bgImageView.image = self.backImage;
//    [self.view addSubview:bgImageView];
//    bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    effectView.frame = self.view.frame;
//    [bgImageView addSubview:effectView];
    
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64 + __kTopAddHeight)];
    
    [self.view addSubview:navtion];
    
    UILabel *labels = [[UILabel alloc]init];
    labels.text = @"添加位置";
    [labels setFont:SLBFont(18)];
    labels.textColor = sl_textColors;
    labels.frame = CGRectMake(0, 20 + __kTopAddHeight,SCREEN_WIDTH,44);
    labels.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labels];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20 + __kTopAddHeight, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_close_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:backBtn];
    
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(__ScaleWidth(12), navtion.height+__ScaleWidth(10), SCREEN_WIDTH-__ScaleWidth(24), __ScaleWidth(34))];
    self.searchField.textColor = sl_textColors;
    self.searchField.backgroundColor = sl_subBGColors;
    self.searchField.layer.cornerRadius = 17;
    self.searchField.font = CFont(14);
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo_icon_sousuo"]];
    icon.contentMode = UIViewContentModeCenter;
    icon.frame = CGRectMake(0, 0, __ScaleWidth(34), __ScaleWidth(34));
    icon.contentMode = UIViewContentModeCenter;
    self.searchField.leftView = icon;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索位置" attributes:@{NSForegroundColorAttributeName:[UIColor sl_colorWithHex:0xB2B2B2],NSFontAttributeName:SLPFFont(14)}];
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchField.delegate = self;
    [self.searchField addTarget:self action:@selector(editTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.searchField];
    UIButton *clearBtn =[self.searchField valueForKey:@"_clearButton"];
    [clearBtn setImage:CImage(@"login_clear") forState:BtnNormal];
    
}
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64 + __kTopAddHeight+44);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    WS(ws);
    MJRefreshBackNormalFooter * foot =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.offset ++;
        if (ws.searchField.text.length>0) {
            [ws getSearchText];
        }else{
            [ws loadData];
        }
    }];
    foot.stateLabel.textColor = [UIColor whiteColor];
//    foot.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_footer= foot;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.tableView.tableHeaderView = topView;
    self.noshowLabel = [UILabel initWithFrame:CGRectZero text:@"不显示我的位置" size:14 color:[UIColor sl_colorWithHex:0xA8AFAF] alignment:0 lines:1 shadowColor:nil];
    [topView addSubview:self.noshowLabel];
    [self.noshowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    
    self.freshBtn = [UIButton buttonWithFrame:CGRectZero Title:@"刷新" Font:CFont(15) Color:[UIColor sl_colorWithHex:0xF8F8F8] Image:nil Target:self action:@selector(freshBtnClick) forControlEvents:BtnTouchUpInside];
    self.freshBtn.layer.masksToBounds = YES;
    self.freshBtn.layer.cornerRadius = 22;
    self.freshBtn.backgroundColor= sl_normalColors;
    [self.tableView addSubview:self.freshBtn];
    [self.freshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tableView).offset(20);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(44);
    }];
    
    
    
    self.placeLabel = [UILabel initWithFrame:CGRectZero size:12 color:sl_subBGColors alignment:1 lines:0];
    
    [self.tableView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.centerX.mas_equalTo(0);
     make.bottom.mas_equalTo(self.freshBtn.mas_top).offset(-16);
    }];
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",@"暂无内容"] attributes:@{NSFontAttributeName:CFont(16), NSForegroundColorAttributeName:TextBrightestColor}];
    
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:@"稍后查看" attributes:@{NSFontAttributeName:SLPFFont(14),NSForegroundColorAttributeName:sl_textSubColors}];
    
    [title appendAttributedString:content];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:10];
    paraStyle.alignment = NSTextAlignmentCenter;
    [title addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, title.length)];
    
    self.placeLabel.attributedText = title;
    
    
    self.noshowLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.noshowLabel addGestureRecognizer:tap];
    
    self.freshBtn.hidden = YES;
    self.placeLabel.hidden = YES;
    
    
}
-(void)tapClick{
    if (self.locationBlock) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DSLocationSelectData" object:nil userInfo:@{@"type":@"1"}];
        BXLocation *location = (BXLocation *)[CacheHelper objectForKey:@"NowLocation"];
        self.locationBlock(location);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)freshBtnClick{
    [self.searchField resignFirstResponder];
    if (self.searchField.text.length>0) {
        [self getSearchText];
    }else{
        [self loadData];
    }
}
#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (self.offset==1) {
        [self.dataArray removeAllObjects];
    }
    [response.tips enumerateObjectsUsingBlock:^(AMapTip *obj, NSUInteger idx, BOOL *stop) {
        
        BXLocation *location = [[BXLocation alloc] init];
        location.region_level = @"4";
        location.uid = obj.uid;
        location.name = obj.name;
        location.typecode = obj.typecode;
        location.lat = [NSString stringWithFormat:@"%f", obj.location.latitude];
        location.lng = [NSString stringWithFormat:@"%f", obj.location.longitude];
        location.address = obj.address;
        location.region_level = @"4";
        if (!IsNilString(obj.address)) {
            [self.dataArray addObject:location];
        }
    
    }];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if (self.offset==1) {
        [self.dataArray removeAllObjects];
        if (self.searchField.text.length<=0) {
            BXLocation *location = (BXLocation *)[CacheHelper objectForKey:@"NowLocation"];
            location.name = location.city;
            location.uid = @"";
            location.region_level = @"2";
            if (location != nil) {
                [self.dataArray addObject:location];
            }
        }
    }
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        BXLocation *location = [[BXLocation alloc] init];
        location.region_level = @"4";
        location.uid = obj.uid;
        location.name = obj.name;
        location.typecode = obj.typecode;
        location.lat = [NSString stringWithFormat:@"%f", obj.location.latitude];
        location.lng = [NSString stringWithFormat:@"%f", obj.location.longitude];
        location.address = obj.address;
        location.tel = obj.tel;
        location.distance = obj.distance;
        location.postcode = obj.postcode;
        if (!IsNilString(obj.address)) {
            [self.dataArray addObject:location];
        }
       
    }];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    if (response.pois.count) {
//        [SLProgressHUD slShowInfoWithMessage:@"搜索完成"];
    }else{
        [SLProgressHUD slShowInfoWithMessage:@"对不起，没有找到相关的位置，请修改关键字后再试试"];
    }
}


#pragma mark - UITableViewDataSource
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count==0) {
        self.freshBtn.hidden = NO;
        self.placeLabel.hidden = NO;
        self.noshowLabel.hidden = YES;
    }else{
        self.noshowLabel.hidden = NO;
        self.placeLabel.hidden = YES;
        self.freshBtn.hidden = YES;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXAddLocaionCell *cell = [BXAddLocaionCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DSLocationSelectData" object:nil userInfo:@{@"type":@"1"}];
    BXLocation *location = self.dataArray[indexPath.row];
    if (self.locationBlock) {
        self.locationBlock(location);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchField resignFirstResponder];
}
#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.offset = 1;
    [self getSearchText];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.offset = 1;
    [self loadData];
    [textField resignFirstResponder];
    return YES;
}

-(void)getSearchText{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    //关键字
    request.keywords = self.searchField.text;
    request.page = self.offset;
//    request.requireExtension = YES;
    //发起周边搜索
    [self.search AMapPOIKeywordsSearch:request];
    [self.searchField resignFirstResponder];
}
- (void)editTextField:(UITextField *)textField
{
    if (textField.text.length<=0) {
        self.offset = 1;
        [self loadData];
    }
}

@end

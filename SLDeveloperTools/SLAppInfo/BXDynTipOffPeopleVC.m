//
//  BXDynTipOffPeopleVC.m
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffPeopleVC.h"
#import "BXDynTipOffCell.h"
#import "BXDynTipOffPeopleFooterView.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynTitleListModel.h"
#import "FilePathHelper.h"
#import "BXDynTipOffPerplePictureFooterView.h"
#import <YYCategories/YYCategories.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "SLAppInfoMacro.h"
#import "SLUpLoadAndDownloadTools.h"
@interface BXDynTipOffPeopleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *issueBtn;

@property (strong, nonatomic) BXDynTipOffPeopleFooterView *tipOffTextView;
@property (strong, nonatomic) BXDynTipOffPerplePictureFooterView *tipOffpicture;
@property(nonatomic, strong)UILabel *tipoffObjLabel;
@property(nonatomic, strong)UILabel *tipoffConcentLabel;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *picurlArray;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign)BOOL ifSelected;

@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)NSMutableArray *typeArray;
@end

@implementation BXDynTipOffPeopleVC
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
    self.dataArray = [[NSMutableArray alloc]init];
    self.typeArray = [[NSMutableArray alloc]init];
    self.picurlArray = [NSMutableArray array];
    [self setNavView];
    [self setHeaderView];
    [self initTableView];
    [self createData];
}
-(void)createData{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest GetReportWithSuccess:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        [self.dataArray removeAllObjects];
        if (flag) {
            NSArray *array = jsonDic[@"data"];
            if (array.count) {
                for (NSDictionary *dic in array) {
                    BXDynTitleListModel *model = [[BXDynTitleListModel alloc]init];
                    model.child_name = dic[@"child_name"];
                    model.child_id = dic[@"id"];
                    model.sel_tip = @"0";
                    [self.dataArray addObject:model];
                }
            }
            [self. tableView reloadData];
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
    }];
}
-(void)setUsername:(NSString *)username{

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"举报用户%@", username]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorHex(#EF6856) range:NSMakeRange(4, username.length)];
    _tipoffObjLabel.attributedText = str;
//    _tipoffConcentLabel.text = [NSString stringWithFormat:@"%@:%@", model.msgdetailmodel.nickname, model.msgdetailmodel.content];
//    [self.tableView reloadData];
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"举报内容";
    _viewTitlelabel.textColor = UIColorHex(#282828);
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
    [_issueBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
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
    _tipoffObjLabel.textColor = UIColorHex(#8C8C8C);
    _tipoffObjLabel.font = [UIFont systemFontOfSize:16];
    [backview addSubview:_tipoffObjLabel];
    [_tipoffObjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview.mas_left).offset(12);
        make.right.mas_equalTo(backview.mas_right).offset(-12);
        make.top.mas_equalTo(backview.mas_top).offset(12);
        make.height.mas_equalTo(24);
    }];
    
    _tipoffConcentLabel = [[UILabel alloc]init];
    _tipoffConcentLabel.textColor = UIColorHex(#282828);
    _tipoffConcentLabel.font = [UIFont systemFontOfSize:14];
    [backview addSubview:_tipoffConcentLabel];
    [_tipoffConcentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview.mas_left).offset(12);
        make.right.mas_equalTo(backview.mas_right).offset(-12);
        make.top.mas_equalTo(self.tipoffObjLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(backview.mas_bottom).offset(-12);
    }];
    
//    _tipoffObjLabel.text = @"举报潮服时装发布的内容";
//    _tipoffConcentLabel.text = @"潮服时装：衣服好看，时尚潮流【图片】";
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.frame.origin.y + self.navView.frame.size.height + 107, self.view.frame.size.width, self.view.bounds.size.height -(self.navView.frame.origin.y + self.navView.frame.size.height + 107 + __kBottomAddHeight)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(107);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
    }];

    _tipOffTextView = [[BXDynTipOffPeopleFooterView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width,  350)];
    self.tableView.tableFooterView = _tipOffTextView;
    self.tipOffTextView.autoresizingMask = UIViewAutoresizingNone;
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
    BXDynTipOffCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[BXDynTipOffCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }

    cell.model = _dataArray[indexPath.row];

//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    return cell;

    

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 45;


}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _type = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] child_id]];
    
    BXDynTitleListModel *model = self.dataArray[indexPath.row];
    if ([model.sel_tip isEqualToString:@"1"]) {
        model.sel_tip = @"0";
        [self.typeArray removeObject:_type];
    }else{
        model.sel_tip = @"1";
        [self.typeArray addObject:_type];
    }
    
    if (indexPath.row == self.dataArray.count - 1) {
        
        for (int i = 0; i < self.dataArray.count - 1; i++) {
            BXDynTitleListModel *model = self.dataArray[i];
            model.sel_tip = @"0";
        }
        if ([model.sel_tip isEqualToString:@"0"]) {
            self.tipOffTextView.hidden = YES;
            self.tipOffTextView.isText = YES;
            [self.typeArray removeAllObjects];
        }else{
            self.tipOffTextView.hidden = NO;
            self.tipOffTextView.isText = YES;
            [self.typeArray removeAllObjects];
            [self.typeArray addObject:_type];
        }
    }
    else{
        BXDynTitleListModel *model = self.dataArray[self.dataArray.count - 1];
        if ([model.sel_tip isEqualToString:@"1"]) {
            model.sel_tip = @"0";
            self.tipOffTextView.hidden = YES;
            self.tipOffTextView.isText = NO;
        }
        else{
            self.tipOffTextView.hidden = NO;
            self.tipOffTextView.isText = NO;

        }
        NSString *lasttype = [NSString stringWithFormat:@"%@",[self.dataArray[self.dataArray.count - 1] child_id]];
        for (int i = 0; i < self.typeArray.count; i++) {
            if ([lasttype isEqualToString:self.typeArray[i]]) {
                [self.typeArray removeObjectAtIndex:i];
                break;
            }
        }

        
        [self.tipOffTextView.textView resignFirstResponder];
    }
    [tableView reloadData];
    if (self.typeArray.count) {
        [_issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _issueBtn.backgroundColor = UIColorHex(#FF2D52);
        _issueBtn.userInteractionEnabled = YES;
        self.tipOffTextView.hidden = NO;
    }else{
        [_issueBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynDownLineColor;
        _issueBtn.userInteractionEnabled = NO;
        self.tipOffTextView.hidden = YES;
    }
}



-(void)AddClick{
     if ([_type isEqualToString:[NSString stringWithFormat:@"%@",[[self.dataArray lastObject] child_id]]]) {
        if ([self.tipOffTextView.textView.text isEqualToString:@" 陈述理由(字数最多140个字)"]|| [self.tipOffTextView.textView.text isEqualToString:@""]) {
            [BGProgressHUD showInfoWithMessage:@"请输入举报内容"];
            return;
        }
        if (self.tipOffTextView.AddPicArray.count > 1) {
            [self uploadImgCurrentIndex:0 totalCount:self.tipOffTextView.AddPicArray.count - 1];
        }else{
            [self reportAct];
        }
        
    }else{
        [self reportAct];
    }
}

-(void)reportAct{
    NSString *picstr = @"";
    NSString *type = [self.typeArray componentsJoinedByString:@","];
     picstr = [self.picurlArray componentsJoinedByString:@","];
    [HttpMakeFriendRequest ReportWithreport_msg_id:_model.fcmid report_img:picstr report_msg:self.tipOffTextView.textView.text type:type report_type:self.reporttype report_uid:self.user_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            [self pop];
        }
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
#pragma mark - 上传图片
-(void)uploadImgCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount{
    UIImage *img = self.tipOffTextView.AddPicArray[currentIndex];
    NSData *data = UIImageJPEGRepresentation(img, .8);
    NSString *path = [self getImageFilePath:data fileName:[NSString stringWithFormat:@"%ld.jpg",(long)currentIndex]];
    WS(weakSelf);
    [BGProgressHUD showLoadingAnimation];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            [weakSelf.picurlArray addObject:jsonDic[@"filePath"]];
            NSLog(@"七牛：%@",jsonDic);
            NSLog(@"~%ld",(long)currentIndex);
            if (currentIndex < totalCount-1) {
                [weakSelf uploadImgCurrentIndex:currentIndex+1 totalCount:totalCount];
            }else{
//                    最后一个任务完成~
                [BGProgressHUD showProgress:1.0 status:@"上传中"];
//                [self startIssue:nil type:@"picture"];
                [weakSelf reportAct];
                [weakSelf.picurlArray removeAllObjects];
               
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"上传失败"];
    }];
}
#pragma mark - 获取临时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData fileName:(NSString *)fileName {
    NSString *dirPath =[[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"manual"];
    BOOL isdir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath isDirectory:&isdir]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [dirPath stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
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
//    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    UIViewAnimationCurve animationCurve =[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
//    [UIView setAnimationCurve:animationCurve];
    
    self.view.frame = CGRectMake(0, -keyboardhight, __kWidth, __kHeight);
    
//    [self.tableView layoutIfNeeded];
//    [self.tableView layoutSubviews];
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.navView.mas_bottom).offset(107);
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-keyboardhight);
//    }];
//    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//        [self.tableView beginUpdates];
//    [self.tableView scrollToBottom];
//    [self.tableView endUpdates];

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

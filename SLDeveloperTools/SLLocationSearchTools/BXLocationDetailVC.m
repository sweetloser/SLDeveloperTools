//
//  BXLocationDetailVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLocationDetailVC.h"
#import "BXPagerView.h"
#import "BXLocationHeaderView.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "BXCustomAnnotationView.h"
//#import "AppDelegate.h"
#import "BXAttentionVideoCell.h"
#import "../SLAppInfo/SLAppInfo.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>

#define TableHeaderViewHeight      178 + __kTopAddHeight

@interface BXLocationDetailVC () <BXPagerViewDelegate, BXLocationHeaderViewDelegate, MAMapViewDelegate>

@property (nonatomic, strong) BXPagerView *pagerView;

@property (nonatomic, strong) BXLocationHeaderView *headerView;

@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UIView *mapContainerView;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, assign) BOOL isGetDetail;

@end

@implementation BXLocationDetailVC

- (void)getLocationDetail {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getLocationDetailWhenOutTime) object:nil];
    
    if (!_lat) {
        _lat = @"";
    }
    if (!_lng) {
        _lng = @"";
    }
    
    [NewHttpManager locationDetailWithLocationId:_location.location_id lat:_lat lng:_lng success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            NSDictionary *dataDic = jsonDic[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                self.location.isGetDetail = YES;
                [self.location updateWithJsonDic:dataDic];
                [self didGetLocationDetail];
            }
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"获取详情信息失败"];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([_pagerView.player.currentPlayerManager isPlaying]) {
        [_pagerView.player.currentPlayerManager pause];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (_pagerView.commentView) {
        [_pagerView.commentView showInView:nil];
    }
    @weakify(self)
    [_pagerView.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (!self.pagerView.tableView.zf_playingIndexPath) {
            [self.pagerView playTheVideoAtIndexPath:self.pagerView.tableView.zf_playingIndexPath scrollToTop:NO];
        }else{
            BXHMovieModel *model = self.pagerView.videos[self.pagerView.currentIndexPath.row];
            BXAttentionVideoCell *cell = (BXAttentionVideoCell *)[self.pagerView.tableView cellForRowAtIndexPath:self.pagerView.tableView.zf_playingIndexPath];
            if (model.isPlay) {
                [self.pagerView.player.currentPlayerManager play];
                [cell.musicName resume];
                cell.playBtn.selected = NO;
            }else{
                [self.pagerView.player.currentPlayerManager pause];
                [cell.musicName pause];
                cell.playBtn.selected = YES;
            }
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };

    if ([_pagerView.player.currentPlayerManager isPlaying]) {
        [_pagerView.player.currentPlayerManager pause];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
   
    [self initViews];
    
    if (_location.isGetDetail) {
        [self didGetLocationDetail];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLocation:) name:kDidGetLocationNotification object:nil];
//        [[AppDelegate shareAppDelegate] startLocation];
        
        [self performSelector:@selector(getLocationDetailWhenOutTime) withObject:nil afterDelay:3.0];
    }
}

- (void)getLocationDetailWhenOutTime {
    [BGProgressHUD showLoadingAnimation];
    self.isGetDetail = YES;
    [self getLocationDetail];
}

- (void)initViews {
    _headerView = [[BXLocationHeaderView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 178 + __kTopAddHeight)];
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    CGFloat topSpace = 64 + __kTopAddHeight;
    NSInteger headerType = 0;
    if ([_location.level integerValue] == 4) {
        headerType = 1;
    }
    _pagerView = [[BXPagerView alloc]initWithFrame:CGRectMake(0, _headerView.height, __kWidth, __kHeight - topSpace) headerType:headerType];
    _pagerView.backgroundColor = PageBackgroundColor;
    _pagerView.topSpace = topSpace;
    _pagerView.bottomSpace = 94 + 44 + __kBottomAddHeight;
    _pagerView.delegate = self;
    _pagerView.vc = self;
    [self.view addSubview:_pagerView];
    
    _mapContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, -_headerView.height, __kWidth, __kHeight - _pagerView.bottomSpace)];
    _mapContainerView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_mapContainerView belowSubview:_headerView];
    
    UIView *gradientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 126 + __kTopAddHeight)];
    [self.view insertSubview:gradientView aboveSubview:_mapContainerView];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.opacity = .4;
    gradientLayer.frame = gradientView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor];
    [gradientView.layer addSublayer:gradientLayer];
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    //初始化地图
    _mapView = [[MAMapView alloc]initWithFrame:_mapContainerView.bounds];
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.delegate = self;
    ///把地图添加至view
    [_mapContainerView addSubview:_mapView];
    
    _navigationBar = [[UIView alloc]init];
    _navigationBar.backgroundColor = [CHHCOLOR_D(0x182328) colorWithAlphaComponent:0];
    _navigationBar.clipsToBounds = YES;
    [self.view addSubview:_navigationBar];
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(64 + __kTopAddHeight);
    }];
    
    UIView *topView = [[UIView alloc]init];
    [_navigationBar addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(20 + __kTopAddHeight);
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = CBFont(16);
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.alpha = 0;
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:CImage(@"icon_return_white") forState:BtnNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [topView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(32);
    }];
    
    _headerView.hidden = YES;
    _pagerView.hidden = YES;
    _mapContainerView.hidden = YES;
}

- (void)isSelectedAnnotationView:(BOOL)isSelected {
    if (isSelected) {
        [_mapView selectAnnotation:_annotation animated:YES];
    } else {
        [_mapView deselectAnnotation:_annotation animated:YES];
    }
}

- (void)didGetLocationDetail {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_location.lat floatValue], [_location.lng floatValue]);
    _annotation = [[MAPointAnnotation alloc]init];
    _annotation.coordinate = coordinate;
    _annotation.title = _location.name;
    _annotation.subtitle = _location.address;
    
    _titleLb.text = _location.name;
    _headerView.imageUrl = _location.cover;
    [_mapView setCenterCoordinate:coordinate animated:YES];
    [_mapView addAnnotation:_annotation];
    _pagerView.location = _location;
    
    _headerView.hidden = NO;
    _pagerView.hidden = NO;
    _mapContainerView.hidden = NO;
    
}

#pragma - mark BXPagerViewDelegate
- (void)pagerViewFrameDidChangeWithContentOffsetY:(CGFloat)contentOffsetY duration:(NSTimeInterval)duration {
    CGFloat headerViewY = 0;
    CGFloat mapContainerViewY = - self.headerView.height;
    CGFloat alpha = 0;
    CGFloat maxContentOffsetY = __kHeight - self.pagerView.initialY - self.pagerView.bottomSpace;
    if (contentOffsetY < 0) {
        headerViewY = contentOffsetY;
        mapContainerViewY = - self.headerView.height + contentOffsetY;
        alpha = -contentOffsetY / (self.pagerView.initialY - self.pagerView.topSpace);
    } else {
        headerViewY = contentOffsetY * (__kHeight - self.pagerView.bottomSpace) / maxContentOffsetY;
        mapContainerViewY = - self.headerView.height + contentOffsetY * self.headerView.height / maxContentOffsetY;
    }
    
    NSInteger type = -1;
    if (contentOffsetY <= 0) {
        type = 0;
    } else if (contentOffsetY == maxContentOffsetY) {
        type = 1;
    }
    
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            self.headerView.y = headerViewY;
            self.mapContainerView.y = mapContainerViewY;
            self.navigationBar.backgroundColor = [CHHCOLOR_D(0x182328) colorWithAlphaComponent:alpha];
            self.titleLb.alpha = alpha;
        } completion:^(BOOL finished) {
            if (type >= 0) {
                [self isSelectedAnnotationView:type];
            }
        }];
    } else {
        self.headerView.y = headerViewY;
        self.mapContainerView.y = mapContainerViewY;
        self.navigationBar.backgroundColor = [CHHCOLOR_D(0x182328) colorWithAlphaComponent:alpha];
        self.titleLb.alpha = alpha;
        if (type >= 0) {
            [self isSelectedAnnotationView:type];
        }
    }
}

#pragma - mark BXLocationHeaderViewDelegate
- (void)locationHeaderViewDidTap {
    [_pagerView open];
}

#pragma - mark MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        BXCustomAnnotationView *annotationView = (BXCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
        if (annotationView == nil) {
            annotationView = [[BXCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
            annotationView.canPop = YES;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, 8);
        }
        return annotationView;
    }
    return nil;
}

#pragma - mark NSNotification
- (void)didGetLocation:(NSNotification *)noti {
    if (!_isGetDetail) {
        NSDictionary *info = noti.userInfo;
        NSInteger type = [info[@"type"] integerValue];
        if (type==0) {
            BXLocation *location = info[@"location"];
            _lat = location.lat;
            _lng = location.lng;
            
        }else if (type==1){
            
        }else{
            
        }
        
        [BGProgressHUD showLoadingAnimation];
        [self getLocationDetail];
    }
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

//
//  HMBeautifyView.m
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMBeautifyView.h"
#import "HMSegmentedControl.h"
#import "HMBeautifySlideView.h"
#import "HMFilterView.h"
#import "HMSlideView.h"
#import "FUManager.h"
#import "../../SLMaskTools/SLMaskTools.h"
#import <MMKV/MMKV.h>
#import "../../SLCategory/SLCategory.h"
#import "../../SLMacro/SLMacro.h"
#import "../SLSelectFilterConst.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import "FUManager+SLExtension.h"

@interface HMBeautifyView ()<UIScrollViewDelegate,HMFilterViewDelegate, HMBeautifySlideViewDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *skinBtn;

@property (nonatomic,strong)UIButton *backBtn;
@end

@implementation HMBeautifyView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {self.backgroundColor = [UIColor clearColor];
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        
//        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 235 + __kBottomAddHeight)];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, __ScaleWidth(357-34) + __kBottomAddHeight)];
        [self addSubview:contentView];
        _contentView = contentView;
        contentView.backgroundColor  = sl_BGColors;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapeLayer;
        
        self.skinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.skinBtn setImage:CImage(@"lc_meiyan_on") forState:BtnNormal];
        [self.skinBtn setImage:CImage(@"lc_meiyan_off") forState:BtnSelected];
        [self.skinBtn addTarget:self action:@selector(skinBtnClick:) forControlEvents:BtnTouchUpInside];
       MMKV *mmkv = [MMKV defaultMMKV];
        self.skinBtn.selected = [mmkv getBoolForKey:kSaveSkipKey];
        [contentView addSubview:self.skinBtn];
        self.skinBtn.sd_layout.rightSpaceToView(contentView, __ScaleWidth(12)).widthIs(33).heightIs(25).topSpaceToView(contentView, __ScaleWidth(10));
        self.skinBtn.titleLabel.sd_layout.leftSpaceToView(self.skinBtn, 0).widthIs(0).heightIs(0).topSpaceToView(self.skinBtn, 0);
        self.skinBtn.imageView.sd_layout.leftSpaceToView(self.skinBtn, 0).topSpaceToView(self.skinBtn, 0).widthIs(33).heightIs(25);
        
        
        self.resetBtn = [UIButton buttonWithFrame:CGRectZero Title:@" 重置" Font:SLPFFont(__ScaleWidth(14)) Color:sl_textSubColors Image:[UIImage imageNamed:@"lc_meiyan_refresh_icon"] Target:self action:@selector(resetBtnClick) forControlEvents:BtnTouchUpInside];
        self.resetBtn.backgroundColor = SLClearColor;
        self.resetBtn.sd_cornerRadius = @(14);

        [contentView addSubview:self.resetBtn];
        self.resetBtn.sd_layout.rightSpaceToView(self.skinBtn, 12).widthIs(50).heightIs(28).topSpaceToView(contentView, 6);
        

        UIView *lineView = [UIView new];
        lineView.backgroundColor = sl_divideLineColor;
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(__ScaleWidth(49));
        }];
        
        WS(weakSelf);
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentView addSubview:_backBtn];
        [_backBtn setImage:[UIImage imageNamed:@"login_icon_back"] forState:BtnNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:BtnTouchUpInside];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(weakSelf.resetBtn);
            make.width.height.mas_equalTo(32);
        }];
        _backBtn.hidden = YES;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, __ScaleWidth(50), self.width, self.height - __ScaleWidth(50))];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(self.width * 2, self.scrollView.height);
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = NO;
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.width, 195) animated:NO];
        [contentView addSubview:self.scrollView];
        
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width , self.scrollView.height)];
        [self.scrollView addSubview:view1];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [view1 addSubview:titleLabel];
        titleLabel.font = SLBFont(14);
        titleLabel.text = @"美颜";
        titleLabel.textColor = sl_blackBGColors;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.top.mas_equalTo(__ScaleWidth(14.5));
            make.height.mas_equalTo(__ScaleWidth(20));
        }];
        
        UIButton *moreBtn = [[UIButton alloc]init];
        [view1 addSubview:moreBtn];
        [moreBtn  setTitle:@"更多设置 >" forState:BtnNormal];
        moreBtn.titleLabel.font  = SLPFFont(__ScaleWidth(11));
        [moreBtn setTitleColor:sl_textSubColors forState:BtnNormal];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel);
            make.right.mas_equalTo(-__ScaleWidth(12));
            make.height.mas_equalTo(__ScaleWidth(20));
        }];
        [moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:BtnTouchUpInside];
        
//        UIView *infoView = [[UIView alloc]init];
//        [view1 addSubview:infoView];
//        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(40);
//            make.left.right.bottom.mas_equalTo(0);
//        }];
        
        
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, self.width , self.scrollView.height)];
        [self.scrollView addSubview:view2];
        
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(self.width*2, 0, self.width , self.scrollView.height)];
        [self.scrollView addSubview:view3];
        
    
        FUManager *manager = [FUManager shareManager];
        
        NSArray *skinArray = @[
                   @{@"name":@"磨皮",@"skin":@"live_meiyan_mopi",@"type":@"0",@"slideType":@(HMFilterSliderTypeBlur),@"value":@(manager.blurLevel),@"defaultValue":@(0.6)},
                   @{@"name":@"瘦脸",@"skin":@"live_meiyan_shoulian",@"type":@"0",@"slideType":@(HMFilterSliderTypeThinFace),@"value":@(manager.thinningLevel),@"defaultValue":@(0.6)},
                   @{@"name":@"大眼",@"skin":@"live_meiyan_dayan",@"type":@"0",@"slideType":@(HMFilterSliderTypeEyeLarge),@"value":@(manager.enlargingLevel),@"defaultValue":@(0.3)},
                   @{@"name":@"美白",@"skin":@"live_meiyan_meibai",@"type":@"0",@"slideType":@(HMFilterSliderTypeColor),@"value":@(manager.whiteLevel),@"defaultValue":@(0.6)},
                               ];
        
        NSArray *ShapeArray = @[
            @{@"name":@"美白",@"skin":@"live_meiyan_meibai",@"type":@"0",@"slideType":@(HMFilterSliderTypeColor),@"value":@(manager.whiteLevel),@"defaultValue":@(0.6)},
            @{@"name":@"磨皮",@"skin":@"live_meiyan_mopi",@"type":@"0",@"slideType":@(HMFilterSliderTypeBlur),@"value":@(manager.blurLevel),@"defaultValue":@(0.6)},
            @{@"name":@"瘦脸",@"skin":@"live_meiyan_shoulian",@"type":@"0",@"slideType":@(HMFilterSliderTypeThinFace),@"value":@(manager.thinningLevel),@"defaultValue":@(0.6)},
            @{@"name":@"大眼",@"skin":@"live_meiyan_dayan",@"type":@"0",@"slideType":@(HMFilterSliderTypeEyeLarge),@"value":@(manager.enlargingLevel),@"defaultValue":@(0.3)},
                                @{@"name":@"红润",@"shape":@"live_meiyan_hongrun",@"type":@"1",@"slideType":@(HMFilterSliderTypeRed),@"value":@(manager.redLevel),@"defaultValue":@(0.3)},
                                @{@"name":@"下巴",@"shape":@"live_meiyan_xiaba",@"type":@"1",@"slideType":@(HMFilterSliderTypeChin),@"value":@(manager.jewLevel),@"defaultValue":@(0.5)},
                                @{@"name":@"额头",@"shape":@"live_meiyan_etou",@"type":@"1",@"slideType":@(HMFilterSliderTypeForehead),@"value":@(manager.foreheadLevel),@"defaultValue":@(0.5)},
                                @{@"name":@"瘦鼻",@"shape":@"live_meiyan_shoubi",@"type":@"1",@"slideType":@(HMFilterSliderTypeNose),@"value":@(manager.noseLevel),@"defaultValue":@(0.2)}
                                ];
        
        
        UIView *lastView =titleLabel;
        for (NSInteger i = 0; i < skinArray.count; i++) {
            HMBeautifySlideView *beaut = [[HMBeautifySlideView alloc] initWithFrame:CGRectZero leftType:i];
            beaut.delegate = self;
            beaut.tag = i+ 19935678;
            beaut.dataDict = skinArray[i];
            [view1 addSubview:beaut];
            [beaut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.width/2);
                make.height.mas_equalTo(__ScaleWidth(64));
                if (i%2 == 0) {
                  make.left.mas_equalTo(0);
                  make.top.mas_equalTo(lastView.mas_bottom).offset(0);
                } else {
                    make.left.mas_equalTo(lastView.mas_right);
                    make.top.mas_equalTo(lastView.mas_top);
                }
            }];
            lastView = beaut;
        }

        UIView *lastView1 =lineView;
        for (NSInteger i = 0; i < ShapeArray.count; i++) {
            HMBeautifySlideView *beaut = [[HMBeautifySlideView alloc] initWithFrame:CGRectZero leftType:i+4];
            beaut.dataDict = ShapeArray[i];
            beaut.delegate = self;
            beaut.tag = i+ 19936789;
            [view2 addSubview:beaut];
            [beaut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.width/2);
                make.height.mas_equalTo(__ScaleWidth(64));
                if (i%2 == 0) {
                    if (i==0) {
                        make.top.mas_equalTo(__ScaleWidth(10));
                    }else{
                        make.top.mas_equalTo(lastView1.mas_bottom);
                    }
                    make.left.mas_equalTo(0);
                    
                } else {
                    
                    make.left.mas_equalTo(lastView1.mas_right);
                    make.top.mas_equalTo(lastView1.mas_top);
                }
            }];
            lastView1 = beaut;
        }
        
        
//滤镜
        NSArray *filterArr = @[
            @{@"filter" : @"原图",@"image":@"origin"},
            @{@"filter":@"白亮",@"image":@"bailiang1"},
            @{@"filter":@"粉嫩",@"image":@"lengsediao1"},
            @{@"filter":@"冷色调",@"image":@"lengsediao1"},
            @{@"filter":@"暖色调",@"image":@"nuansediao1"},
            @{@"filter":@"小清新",@"image":@"xiaoqingxin1"}
                               ];
        HMFilterView *filterView = [[HMFilterView alloc] initWithFrame:CGRectZero filtersName:filterArr];
        for (int i=0; i<filterArr.count; i++) {
            NSDictionary *dict = filterArr[i];
            if (IsEquallString(dict[@"image"], [mmkv getStringForKey:@"DSFilterName"])) {
                filterView.selectedIndex = i;
                break;
            }
        }
        filterView.mDelegate = self;
        filterView.tag = 1993678900;
        [view1 addSubview:filterView];
        [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(__kWidth);
            make.centerX.mas_equalTo(0);
            make.top.equalTo(lastView.mas_bottom).offset(__ScaleWidth(10));
            make.height.mas_equalTo(__ScaleWidth(57+39));
        }];
        [filterView reloadData];
    }
    return self ;
}

-(void)backBtnClicked{
//    [self.scrollView setContentSize:CGSizeMake(0, 0)];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.backBtn.hidden = YES;
}

-(void)moreBtnClicked{
    self.backBtn.hidden = NO;
//    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 0)];
    self.scrollView.contentOffset = CGPointMake(__kWidth, 0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSInteger current = point.x / scrollView.frame.size.width;
    [self.segmentedControl setSelectedSegmentIndex:current animated:YES];
}
//重置
-(void)resetBtnClick {
    
    SLAlertView *alert = [[SLAlertView alloc] initWithFrame:CGRectZero];
    alert.descString = @"清除该调节项，还原到系统默认值？";
    alert.determineTitle = @"好的";
    alert.cancelTitle = @"不允许";
    alert.determineBlock = ^{
        MMKV *mmkv = [MMKV defaultMMKV];
        [mmkv removeValueForKey:@"DSColorLevel"];
        [mmkv removeValueForKey:@"DSBlurLevel"];
        [mmkv removeValueForKey:@"DSEnlargingLevel"];
        [mmkv removeValueForKey:@"DSThinningLevel"];
        [mmkv removeValueForKey:@"DSRedLevel"];
        [mmkv removeValueForKey:@"DSChinLevel"];
        [mmkv removeValueForKey:@"DSForeheadLevel"];
        [mmkv removeValueForKey:@"DSNoseLevel"];
        [mmkv removeValueForKey:@"DSFilterName"];
        
        for (int i=0; i<4; i++) {
            HMBeautifySlideView *view = (HMBeautifySlideView *)[self viewWithTag:19935678 + i];
            [view resetParams];
        }
        for (int i=0; i<4; i++) {
            HMBeautifySlideView *view = (HMBeautifySlideView *)[self viewWithTag:19936789 + i];
            [view resetParams];
        }
        HMFilterView *filterView = (HMFilterView *)[self viewWithTag:1993678900];
        [filterView resetParams];
        
        [[FUManager shareManager] loadFilter];
        [[FUManager shareManager] ckresetALLBeautParams];
    };
    
    alert.cancelBlock = ^{
        
    };
    
    [alert showInView:[UIApplication sharedApplication].keyWindow];
    
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message: @"清除该调节项，还原到系统默认值？" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        MMKV *mmkv = [MMKV defaultMMKV];
//        [mmkv removeValueForKey:@"DSColorLevel"];
//        [mmkv removeValueForKey:@"DSBlurLevel"];
//        [mmkv removeValueForKey:@"DSEnlargingLevel"];
//        [mmkv removeValueForKey:@"DSThinningLevel"];
//        [mmkv removeValueForKey:@"DSRedLevel"];
//        [mmkv removeValueForKey:@"DSChinLevel"];
//        [mmkv removeValueForKey:@"DSForeheadLevel"];
//        [mmkv removeValueForKey:@"DSNoseLevel"];
//        [mmkv removeValueForKey:@"DSFilterName"];
//
//        for (int i=0; i<4; i++) {
//            HMBeautifySlideView *view = (HMBeautifySlideView *)[self viewWithTag:19935678 + i];
//            [view resetParams];
//        }
//        for (int i=0; i<4; i++) {
//            HMBeautifySlideView *view = (HMBeautifySlideView *)[self viewWithTag:19936789 + i];
//            [view resetParams];
//        }
//        HMFilterView *filterView = (HMFilterView *)[self viewWithTag:1993678900];
//        [filterView resetParams];
//
//        [[FUManager shareManager] loadFilter];
//        [[FUManager shareManager] ckresetALLBeautParams];
//    }]];
//    [[[UIApplication sharedApplication] activityViewController] presentViewController:alertController animated:YES completion:nil];
}
//关闭和开启美颜
-(void)skinBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    MMKV *mmkv = [MMKV defaultMMKV];
    [mmkv setBool:sender.selected forKey:kSaveSkipKey];
    [mmkv sync];
    
    if ([mmkv getBoolForKey:kSaveSkipKey]) {
        [BGProgressHUD showInfoWithMessage:@"美颜关闭了"];
        [FUManager shareManager].showFaceUnityEffect = NO;
    }else{
        [BGProgressHUD showInfoWithMessage:@"美颜开启了"];
        [FUManager shareManager].showFaceUnityEffect = YES;
    }
    
}
- (void)tapAction {
    [self removeFromSuperview];

}
-(void)show{
    [UIView animateWithDuration:.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.height);
    }];
}

#pragma mark - HMBeautifySlideViewDelegate
- (void)slideViewValueChangedWithType:(HMSliderType)type value:(CGFloat)value {
    NSString *key = @"DSNoseLevel";
    switch (type) {
        case HMFilterSliderTypeColor:
            key = @"DSColorLevel";
            [FUManager shareManager].whiteLevel = value;
            break;
            
        case HMFilterSliderTypeBlur:
            key = @"DSBlurLevel";
            [FUManager shareManager].blurLevel = value;
            break;
            
        case HMFilterSliderTypeEyeLarge:
            key = @"DSEnlargingLevel";
            [FUManager shareManager].enlargingLevel = value;
            [FUManager shareManager].enlargingLevel_new = value;
            break;
            
        case HMFilterSliderTypeThinFace:
            key = @"DSThinningLevel";
            [FUManager shareManager].thinningLevel = value;
            [FUManager shareManager].thinningLevel_new = value;
            break;
            
        case HMFilterSliderTypeRed:
            key = @"DSRedLevel";
            [FUManager shareManager].redLevel = value;
            break;
            
        case HMFilterSliderTypeChin:
            key = @"DSChinLevel";
            [FUManager shareManager].jewLevel = value;
            break;
            
        case HMFilterSliderTypeForehead:
            [FUManager shareManager].foreheadLevel = value;
            key = @"DSForeheadLevel";
            break;
            
        default://HMFilterSliderTypeNose
            [FUManager shareManager].noseLevel = value;
            break;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    [mmkv setFloat:value forKey:key];
    [mmkv sync];
}

#pragma mark - HMFilterViewDelegate
-(void)filterViewDidSelectedFilter:(NSString *)filterName selectedIndex:(NSInteger)selectedIndex {
    MMKV *mmkv = [MMKV defaultMMKV];
    [mmkv setString:filterName forKey:@"DSFilterName"];
    [mmkv sync];
    [FUManager shareManager].selectedFilter = filterName;
    [[FUManager shareManager] loadFilter];
}

@end

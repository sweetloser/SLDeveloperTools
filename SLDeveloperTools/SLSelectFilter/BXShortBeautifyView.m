//
//  BXShortBeautifyView.m
//  BXlive
//
//  Created by bxlive on 2019/4/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXShortBeautifyView.h"
#import "HMSegmentedControl.h"
#import "HMBeautifySlideView.h"
#import "HMSlideView.h"
#import "FUManager.h"
@interface BXShortBeautifyView ()<HMBeautifySlideViewDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation BXShortBeautifyView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mj_h, self.mj_w, 235 + __kBottomAddHeight)];
        [self addSubview:contentView];
        _contentView = contentView;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapeLayer;
        
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *backView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        [contentView insertSubview:backView atIndex:0];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(contentView);
        }];
        
        UIView *lineView = [UIView new];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(39);
        }];
        
        
        NSArray *data = @[@"美颜", @"增强"];
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 5, 100, 35)];
        self.segmentedControl.backgroundColor = [UIColor clearColor];
        self.segmentedControl.sectionTitles = data;
        self.segmentedControl.selectedSegmentIndex = 0;
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:CFont(16)};
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :sl_normalColors,NSFontAttributeName:CFont(16)};
        self.segmentedControl.selectionIndicatorColor = [UIColor clearColor];
        self.segmentedControl.selectionIndicatorBoxColor = [UIColor clearColor];
        self.segmentedControl.verticalDividerColor = [UIColor clearColor];
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        
        ZZL(weakSelf);
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(self.mj_w * index, 0, weakSelf.mj_w, 195) animated:YES];
        }];
        
        [contentView addSubview:self.segmentedControl];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.mj_w, 195)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(self.mj_w * data.count, 195);
        self.scrollView.scrollEnabled = NO;
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.mj_w, 195) animated:NO];
        [contentView addSubview:self.scrollView];
        
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w , 195)];
        [self.scrollView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(self.mj_w, 0, self.mj_w , 195)];
        [self.scrollView addSubview:view2];
        
        
        FUManager *manager = [FUManager shareManager];
        
        NSArray *skinArray = @[
                               @{@"skin":@"美白",@"type":@"0",@"slideType":@(HMFilterSliderTypeColor),@"value":@(manager.whiteLevel),@"defaultValue":@(0.6)},
                               @{@"skin":@"磨皮",@"type":@"0",@"slideType":@(HMFilterSliderTypeBlur),@"value":@(manager.blurLevel),@"defaultValue":@(0.6)},
                               @{@"skin":@"瘦脸",@"type":@"0",@"slideType":@(HMFilterSliderTypeThinFace),@"value":@(manager.thinningLevel),@"defaultValue":@(0.6)},
                               @{@"skin":@"大眼",@"type":@"0",@"slideType":@(HMFilterSliderTypeEyeLarge),@"value":@(manager.enlargingLevel),@"defaultValue":@(0.3)}
                               ];
        
        NSArray *ShapeArray = @[
                                @{@"shape":@"红润",@"type":@"1",@"slideType":@(HMFilterSliderTypeRed),@"value":@(manager.redLevel),@"defaultValue":@(0.3)},
                                @{@"shape":@"下巴",@"type":@"1",@"slideType":@(HMFilterSliderTypeChin),@"value":@(manager.jewLevel),@"defaultValue":@(0.5)},
                                @{@"shape":@"额头",@"type":@"1",@"slideType":@(HMFilterSliderTypeForehead),@"value":@(manager.foreheadLevel),@"defaultValue":@(0.5)},
                                @{@"shape":@"瘦鼻",@"type":@"1",@"slideType":@(HMFilterSliderTypeNose),@"value":@(manager.noseLevel),@"defaultValue":@(0.2)}
                                ];
        
        
        UIView *lastView =lineView;
        for (NSInteger i = 0; i < skinArray.count; i++) {
            HMBeautifySlideView *beaut = [[HMBeautifySlideView alloc] initWithFrame:CGRectZero leftType:i%2];
            beaut.delegate = self;
            beaut.tag = i+ 19935678;
            beaut.dataDict = skinArray[i];
            [view1 addSubview:beaut];
            [beaut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.mj_w/2);
                make.height.mas_equalTo(70);
                if (i%2==0) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                    
                } else {
                    make.left.mas_equalTo(lastView.mas_right);
                    make.top.mas_equalTo(lastView.mas_top);
                }
            }];
            lastView = beaut;
        }
        
        UIView *lastView1 =lineView;
        for (NSInteger i = 0; i < ShapeArray.count; i++) {
            HMBeautifySlideView *beaut = [[HMBeautifySlideView alloc] initWithFrame:CGRectZero leftType:i%2];
            beaut.dataDict = ShapeArray[i];
            beaut.delegate = self;
            beaut.tag = i+ 19936789;
            [view2 addSubview:beaut];
            [beaut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.mj_w/2);
                make.height.mas_equalTo(70);
                if (i%2==0) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(lastView1.mas_bottom).offset(15);
                    
                } else {
                    
                    make.left.mas_equalTo(lastView1.mas_right);
                    make.top.mas_equalTo(lastView1.mas_top);
                }
            }];
            lastView1 = beaut;
        }
        
        UIPanGestureRecognizer* panGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (handlePanSlide)];
        [self addGestureRecognizer:panGensture];
    }
    return self ;
}

- (void)handlePanSlide {
    
}

- (void)tapAction {
    [self removeFromSuperview];
    if (self.hiddenCallBack) {
        self.hiddenCallBack();
    }
    
}
-(void)show{
    self.hidden = NO;
    [UIView animateWithDuration:.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.mj_h);
    }];
}

#pragma mark - HMBeautifySlideViewDelegate
- (void)slideViewValueChangedWithType:(HMSliderType)type value:(CGFloat)value {
    NSString *key = @"DSNoseLevelShort";
    switch (type) {
        case HMFilterSliderTypeColor:
            key = @"DSColorLevelShort";
            [FUManager shareManager].whiteLevel = value;
            break;
            
        case HMFilterSliderTypeBlur:
            key = @"DSBlurLevelShort";
            [FUManager shareManager].blurLevel = value;
            break;
            
        case HMFilterSliderTypeEyeLarge:
            key = @"DSEnlargingLevelShort";
            [FUManager shareManager].enlargingLevel = value;
            [FUManager shareManager].enlargingLevel_new = value;
            break;
            
        case HMFilterSliderTypeThinFace:
            key = @"DSThinningLevelShort";
            [FUManager shareManager].thinningLevel = value;
            [FUManager shareManager].thinningLevel_new = value;
            break;
            
        case HMFilterSliderTypeRed:
            key = @"DSRedLevelShort";
            [FUManager shareManager].redLevel = value;
            break;
            
        case HMFilterSliderTypeChin:
            key = @"DSChinLevelShort";
            [FUManager shareManager].jewLevel = value;
            break;
            
        case HMFilterSliderTypeForehead:
            [FUManager shareManager].foreheadLevel = value;
            key = @"DSForeheadLevelShort";
            break;
            
        default://HMFilterSliderTypeNose
            [FUManager shareManager].noseLevel = value;
            break;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    [mmkv setFloat:value forKey:key];
    [mmkv sync];
}



@end



//
//  TiUIMangagerNew.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIManager.h"
#import "TIConfig.h"
#import "TiUIMainMenuView.h"


@interface TiUIManager ()

@property(nonatomic, weak) id <TiUIManagerDelegate> delegate;

//主窗口
@property(nonatomic, strong) UIWindow *superWindow;
//添加退出手势的View
@property(nonatomic, strong) UIView *exitTapView;
//美颜模块主要功能UI
@property(nonatomic, strong) TiUIMainMenuView *tiUIViewBoxView;

//互动贴纸提示语
@property(nonatomic, strong) UILabel *interactionHint;
 
@end

static TiUIManager *shareManager = NULL;
static dispatch_once_t token;

@implementation TiUIManager
// MARK: --单例初始化方法--
+ (TiUIManager *)shareManager {
    dispatch_once(&token, ^{
        shareManager = [[TiUIManager alloc] init];
    });
    return shareManager;
}
+(void)releaseShareManager{
   token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//   [shareManager release];
   shareManager = nil;
}

-(instancetype)init{
    if ([super init]) {
        self.showsDefaultUI = NO;
        
    }
    return self;
}
// MARK: --懒加载--
-(UIWindow *)superWindow{
    if (_superWindow==nil) {
        _superWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _superWindow.windowLevel = UIWindowLevelAlert;
        _superWindow.userInteractionEnabled = YES;
        [_superWindow makeKeyAndVisible];
        _superWindow.hidden = YES;//初始隐藏
    }
    return _superWindow;
}
-(TiUIDefaultButtonView *)defaultButton{
    if (!self.showsDefaultUI) {
        [_defaultButton removeFromSuperview];
        _defaultButton =nil;
        return _defaultButton;
    }
    
    if (_defaultButton==nil) {
        _defaultButton = [[TiUIDefaultButtonView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TiUIViewBoxTotalHeight, SCREEN_WIDTH, TiUIViewBoxTotalHeight)];
        WeakSelf; 
        [_defaultButton setOnClickBlock:^(NSInteger tag) {
                switch (tag) {
                    case 0:
                        //显示美颜UI
                        [weakSelf showMainMenuView];
                        break;
                    case 1:
                    //拍照
                        [weakSelf.delegate didClickCameraCaptureButton];
                        break;
                    case 2:
                    //切换摄像头
                        [weakSelf.delegate didClickSwitchCameraButton];
                        break;
                        
                    default:
                        break;
                }
           
        }];
    }
    return _defaultButton;
}
-(UIView *)exitTapView{
    if (_exitTapView ==nil) {
        _exitTapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TiUIViewBoxTotalHeight)];
        _exitTapView.hidden = YES;
        _exitTapView.userInteractionEnabled = YES;
        [_exitTapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onExitTap:)]];
    }
    return _exitTapView;
}

-(TiUIMainMenuView *)tiUIViewBoxView{
    if (_tiUIViewBoxView==nil) {
        // 展示高度 SCREEN_HEIGHT - TiUIViewBoxTotalHeight
        // 隐藏高度 SCREEN_HEIGHT
            _tiUIViewBoxView = [[TiUIMainMenuView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, TiUIViewBoxTotalHeight)];
    }
    return _tiUIViewBoxView;
}

-(UILabel *)interactionHint{
    if (_interactionHint==nil) {
        _interactionHint = [[UILabel alloc]init];
        _interactionHint.textColor = [UIColor whiteColor];
        _interactionHint.font = [UIFont systemFontOfSize:14];
        _interactionHint.textAlignment =  NSTextAlignmentCenter;
        _interactionHint.contentMode = UIViewContentModeCenter;
        [_interactionHint sizeToFit];
    }
    return _interactionHint;
}
 

-(void)setInteractionHintL:(NSString *)hint{
   
    if ([hint isEqualToString:@""]) {
      
        [_interactionHint removeFromSuperview];
        _interactionHint = nil;
        
    }else{
    
       if (_interactionHint == nil) {
           
           UIWindow *window = [self mainWindow];
           
           [window addSubview:self.interactionHint];
           [self.interactionHint mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerX.equalTo(window);
               make.centerY.equalTo(window.mas_centerY).multipliedBy(1.3);
           }];
             
         }
        _interactionHint.text = hint;
    }

}

-(UIWindow*)mainWindow{
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
     
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    
    return nil;
}

// MARK: --弹出美颜UI相关--
-(void)showMainMenuView{
    [self hiddenAllViews:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tiUIViewBoxView.frame = CGRectMake(0,SCREEN_HEIGHT- TiUIViewBoxTotalHeight, SCREEN_WIDTH , TiUIViewBoxTotalHeight);
    }];
    
}
// MARK: --退出手势相关--
- (void)onExitTap:(UITapGestureRecognizer *)recognizer {
      
    if (self.tiUIViewBoxView.isClassifyShow) {
        
       if ([self.delegate respondsToSelector:@selector(didClickOnExitTap)]) {
                      [self.delegate didClickOnExitTap];
               }
        [self popAllViews];
    }else{
        self.tiUIViewBoxView.frame = CGRectMake(0,SCREEN_HEIGHT- TiUIViewBoxTotalHeight, SCREEN_WIDTH , TiUIViewBoxTotalHeight);
        [self.tiUIViewBoxView showClassifyView];
    }
     
}

- (void)popAllViews {
    [UIView animateWithDuration:0.3 animations:^{
         self.tiUIViewBoxView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, TiUIViewBoxTotalHeight);
        
    } completion:^(BOOL finished) {
        
        [self hiddenAllViews:YES];
        if (self.PopBlock) {
            self.PopBlock();
        }
    }];
    
}
-(void)hiddenAllViews:(BOOL)YESNO{
    
    self.tiUIViewBoxView.hidden = YESNO;
    self.exitTapView.hidden = YESNO;
    
    if (_defaultButton) {
        _defaultButton.hidden = !YESNO;
    }
    
    if (_superWindow) {
        _superWindow.hidden = YESNO;
    }
}

// MARK: --loadToWindow 相关代码--
- (void)loadToWindowDelegate:(id<TiUIManagerDelegate>)delegate{
  
    self.delegate = delegate;
    
//     if (self.showsDefaultUI) {
//           [self.superWindow addSubview:self.defaultButton];
//       }
    [self.superWindow addSubview:self.exitTapView];
    [self.superWindow addSubview:self.tiUIViewBoxView];
    
  
}


- (void)loadToView:(UIView* )view forDelegate:(id<TiUIManagerDelegate>)delegate{
    
    self.delegate = delegate;
    
       if (self.showsDefaultUI) {
       [view addSubview:self.defaultButton];
       }
       [view addSubview:self.exitTapView];
       [view addSubview:self.tiUIViewBoxView];
}

- (UIView*)returnLoadToViewDelegate:(id<TiUIManagerDelegate>)delegate{
    self.delegate = delegate;
    UIView *view = [UIView new];
    view.frame = [UIScreen mainScreen].bounds;
    
    if (self.showsDefaultUI) {
    [view addSubview:self.defaultButton];
    }
    [view addSubview:self.exitTapView];
    [view addSubview:self.tiUIViewBoxView];
    return view;
}

 

// MARK: --destroy释放 相关代码--
- (void)destroy{
    // TODO: --此处代码属性获取应使用 _(下划线) --
    
    _interactionHint.text = @"";
    [_interactionHint removeFromSuperview];
    _interactionHint = nil;
    
    [_defaultButton removeFromSuperview];
    _defaultButton = nil;
    
    [_exitTapView removeFromSuperview];
    _exitTapView = nil;
    
    [_tiUIViewBoxView removeFromSuperview];
    _tiUIViewBoxView = nil;
    
    [_superWindow removeFromSuperview];
    _superWindow = nil;
    
    [TiUIManager releaseShareManager];
}

@end


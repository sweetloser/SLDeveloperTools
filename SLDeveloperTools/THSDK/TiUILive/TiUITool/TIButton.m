//
//  TiUIButton.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/4.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TIButton.h"
#import "TIConfig.h"

@interface TiIndicatorAnimationView ()
 
@property(nonatomic,assign)CGFloat angle;
@end

@implementation TiIndicatorAnimationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.angle = 0;
        
    }
    return self;
}



 

-(void)startAnimation
{
        self.hidden = NO;
        [self setAnimation];
}
-(void)endAnimation
{
    self.hidden = YES;
    [self.layer removeAllAnimations];
}
-(void)setAnimation{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
      } completion:^(BOOL finished) {
        if (finished) {
        self.angle += 70;
        [self startAnimation];
        }
      }];
}


//1.画线条（实线，虚线）
- (void)drawRect:(CGRect)rect
{
      
     CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取绘制上下文对象实例

    //    [UIColor colorWithRed:88/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
        CGContextSetRGBStrokeColor(contextRef, 0.345f, 0.866f, 0.866f, 1.0); //设置笔画颜色
        CGContextSetLineWidth(contextRef, 3); //设置线条粗细大小
    
    //voidCGContextAddArc(CGContextRef c,CGFloat x,CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle,int clockwise)
    //1弧度＝180°/π（≈57.3°）度
    //360°＝360 * π/180＝2π弧度
    //x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为结束的弧度，clockwise0为顺时针，1为逆时针。
           CGContextAddArc(contextRef, rect.size.width/2, rect.size.height/2, rect.size.width/2 - 5, 1.5*M_PI, 0, 1);
    
    //添加一个圆；M_PI为180度
       CGContextDrawPath(contextRef, kCGPathStroke); //绘制路径
}
 
@end


@interface TIButton ()

@property(nonatomic,strong)UIView *selectView;
@property(nonatomic,strong)UIImageView *topView;
@property(nonatomic,strong)UILabel *bottomLabel;

@property(nonatomic,strong)UIImageView *downloadView;
@property(nonatomic,strong)TiIndicatorAnimationView *indicatorView;


@property(nonatomic,strong)NSString *normalTitle;
@property(nonatomic,strong)NSString *selectedTitle;

@property(nonatomic,strong)UIImage *normalImage;
@property(nonatomic,strong)UIImage *selectedImage;

@property(nonatomic,strong)UIColor *normalColor;
@property(nonatomic,strong)UIColor *selectedColor;

@property(nonatomic,strong)UIColor *normalBorderColor;
@property(nonatomic,strong)UIColor *selectedBorderColor;
@property(nonatomic,assign)CGFloat normalBorderW;
@property(nonatomic,assign)CGFloat selectedBorderW;


@end

@implementation TIButton
 
-(UIView *)selectView{
    if (_selectView==nil) {
        _selectView = [[UIView alloc]init];
        _selectView.userInteractionEnabled = NO;
    }
    return _selectView;
}

-(UIImageView *)topView{
    if (_topView==nil) {
        _topView = [[UIImageView alloc]init];
        _topView.contentMode = UIViewContentModeScaleAspectFit;
        _topView.userInteractionEnabled = NO;
    }
    return  _topView;
}

-(UILabel *)bottomLabel{
    if (_bottomLabel==nil) {
        _bottomLabel = [[UILabel alloc]init];
        [_bottomLabel setFont:TI_Font_Default_Size_Medium];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

-(UIImageView *)downloadView{
    if (_downloadView==nil) {
        _downloadView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_download.png"]];
        _downloadView.contentMode = UIViewContentModeScaleAspectFit;
        _downloadView.hidden = YES;
        _downloadView.userInteractionEnabled = NO;
    }
    return _downloadView;
}

-(TiIndicatorAnimationView *)indicatorView{
    if (_indicatorView==nil) {
        _indicatorView = [[TiIndicatorAnimationView alloc]init];
    }
    return _indicatorView;
}


-(instancetype)initWithScaling:(CGFloat)scaling{
    
    self = [super init];
       if (self) {
                   [self addSubview:self.selectView];
                   [self.selectView addSubview:self.topView];
                   [self addSubview:self.bottomLabel];
                   [self addSubview:self.downloadView];
           
                    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.top.equalTo(self.mas_top);
                      make.left.equalTo(self.mas_left);
                      make.right.equalTo(self.mas_right);
                      make.height.mas_equalTo(self.mas_width);
                    }];
            
                   [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.selectView.mas_centerX);
                    make.centerY.equalTo(self.selectView.mas_centerY);
                    make.width.mas_equalTo(self.selectView.mas_width).multipliedBy(scaling);
                    make.height.mas_equalTo(self.selectView.mas_width).multipliedBy(scaling);
                    }];
                   
                   [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(self);
                       make.bottom.equalTo(self.mas_bottom).offset(-5);
                   }];
                     
                   [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.right.equalTo(self.mas_right).offset(-1);
                       make.bottom.equalTo(self.mas_bottom).offset(-1);
                       make.width.height.mas_offset(15);
                   }];
                   
           
                   [self.selectView addSubview:self.indicatorView];
                   [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.top.equalTo(self.selectView).offset(5);
                       make.right.bottom.equalTo(self.selectView).offset(-5);
                   }];
                   
           
       }
       return self;
}

  
-(void)setSelected:(BOOL)selected {
 
    if (selected) {
        [self.topView setImage:self.selectedImage];
        [self.bottomLabel setText:self.selectedTitle];
        [self.bottomLabel setTextColor:self.selectedColor];
        if (self.selectedBorderColor) {
            self.selectView.layer.borderWidth = 2.0;
            self.selectView.layer.borderColor = self.selectedBorderColor.CGColor;
        }
    }else{
        [self.topView setImage:self.normalImage];
        [self.bottomLabel setText:self.normalTitle];
        [self.bottomLabel setTextColor:self.normalColor];
        if (self.normalBorderColor) {
            self.selectView.layer.borderWidth = 0.0;
            self.selectView.layer.borderColor = self.normalBorderColor.CGColor;
        }
    }
}



 
- (void)setTitle:(nullable NSString *)title withImage:(nullable UIImage *)image withTextColor:(nullable UIColor *)color forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
             self.normalTitle = title;
             self.normalImage = image;
             self.normalColor = color;
            break;
        case UIControlStateSelected:
               self.selectedTitle = title;
               self.selectedImage = image;
               self.selectedColor = color;
              break;
        default:
            break;
    }
    
    [self setSelected:NO];
    
}

-(void)setBorderWidth:(CGFloat)W BorderColor:(UIColor *)color forState:(UIControlState)state{
 
     
        switch (state) {
            case UIControlStateNormal:
                
                self.normalBorderW = W;
                
                if (color) {
                self.normalBorderColor =color;
                }else{
                    self.normalBorderColor = self.topView.backgroundColor;
                }
                
                break;
            case UIControlStateSelected:
                
                self.selectedBorderW = W;
                
                if (color) {
                   self.selectedBorderColor = color;
                }else{
                    self.selectedBorderColor = self.selectedColor;
                }
                break;
                
            default:
                break;
        }
//        [self setSelected:NO];
}

-(void)setDownloaded:(BOOL)downloaded{
    self.downloadView.hidden = downloaded;
}

-(void)startAnimation{
    self.downloadView.hidden = YES;
    [self.indicatorView startAnimation];
}
-(void)endAnimation{;
    [self.indicatorView endAnimation];
}


@end

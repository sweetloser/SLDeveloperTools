//
//  BXTextScrollView.m
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTextScrollView.h"
#import "NSString+QT.h"
#import "../SLMacro/SLMacro.h"

NSString * const kCircleTextViewAnim           = @"CircleAnim";
NSString * const kCircleTextViewSeparateText   = @"   ";

@interface BXTextScrollView()

@property(nonatomic, strong) CATextLayer   *textLayer;
@property(nonatomic, strong) CAShapeLayer  *maskLayer;
@property(nonatomic, assign) CGFloat       textSeparateWidth;
@property(nonatomic, assign) CGFloat       textWidth;
@property(nonatomic, assign) CGFloat       textHeight;
@property(nonatomic, assign) CGRect        textLayerFrame;
@property(nonatomic, assign) CGFloat       translationX;

@end


@implementation BXTextScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _text = @"";
        _textColor = TextBrightestColor;
        _font = CFont(15);
        _textSeparateWidth = [kCircleTextViewSeparateText singleLineSizeWithText:_font].width;
        [self initLayer];
    }
    return self;
}

- (void)initLayer {
    _textLayer = [[CATextLayer alloc] init];
    _textLayer.alignmentMode = kCAAlignmentNatural;
    _textLayer.truncationMode = kCATruncationNone;
    _textLayer.wrapped = NO;
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_textLayer];
    
    _maskLayer = [[CAShapeLayer alloc] init];
    self.layer.mask = _maskLayer;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _textLayer.frame = CGRectMake(0, self.bounds.size.height/2 - _textLayerFrame.size.height/2, _textLayerFrame.size.width, _textLayerFrame.size.height);
    _maskLayer.frame = self.bounds;
    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [CATransaction commit];
}

- (void)drawTextLayer {
    _textLayer.foregroundColor = _textColor.CGColor;
    CFStringRef fontName = (__bridge CFStringRef)_font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    _textLayer.font = fontRef;
    _textLayer.fontSize = _font.pointSize;
    CGFontRelease(fontRef);
    _textLayer.string = [NSString stringWithFormat:@"%@%@%@%@%@",_text,kCircleTextViewSeparateText,_text,kCircleTextViewSeparateText,_text];
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.x";
    animation.fromValue = @(self.bounds.origin.x);
    animation.toValue = @(self.bounds.origin.x - _translationX);
    animation.duration = _textWidth * 0.035f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_textLayer addAnimation:animation forKey:kCircleTextViewAnim];
}

- (void)pause {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pauseAllLayer) object:nil];
    [self performSelector:@selector(pauseAllLayer) withObject:nil afterDelay:.1];
}

- (void)resume {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pauseAllLayer) object:nil];
    
    if (!self.layer.speed) {
        [self resumeLayer:self.layer];
    }
}

- (void)pauseAllLayer {
    if (self.layer.speed) {
        [self stopLayer:self.layer];
    }
}

#pragma update method
- (void)setText:(NSString *)text {
    [self resetView];
    _text = text;
    CGSize size = [text singleLineSizeWithAttributeText:_font];
    _textWidth = size.width;
    _textHeight = size.height;
    _textLayerFrame = CGRectMake(0, 0, _textWidth*3 + _textSeparateWidth*2, _textHeight);
    _translationX = _textWidth + _textSeparateWidth;
    [self drawTextLayer];
    [self startAnimation];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    CGSize size = [_text singleLineSizeWithAttributeText:_font];
    _textWidth = size.width;
    _textHeight = size.height;
    _textLayerFrame = CGRectMake(0, 0, _textWidth*3 + _textSeparateWidth*2, _textHeight);
    _translationX = _textWidth + _textSeparateWidth;
    [self drawTextLayer];
    [self startAnimation];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textLayer.foregroundColor = _textColor.CGColor;
}

-(void)stopLayer:(CALayer*)layer{
    // 将当前时间CACurrentMediaTime转换为layer上的时间, 即将parent time转换为local time
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设置layer的timeOffset, 在继续操作也会使用到
    layer.timeOffset = pauseTime;
    
    // local time与parent time的比例为0, 意味着local time暂停了
    layer.speed = 0;
    
}

/**
 *  恢复
 *
 *  @param layer 被恢复的layer
 */
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pauseTime = layer.timeOffset;
    // 计算暂停时间
    CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime;
    // 取消
    layer.timeOffset = 0;
    // local time相对于parent time世界的beginTime
    layer.beginTime = timeSincePause;
    // 继续
    layer.speed = 1;
}



-(void)KPauseNotiCenter:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    NSInteger type = [info[@"type"] integerValue];
    if (type) {
        [self resumeLayer:self.layer];
    }else{
        [self stopLayer:self.layer];
    }
}

-(void)resetView{
    if([_textLayer animationForKey:kCircleTextViewAnim]) {
        [_textLayer removeAnimationForKey:kCircleTextViewAnim];
    }
    _textColor = [UIColor clearColor];
    _text = @"";
}

@end

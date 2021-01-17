//
//  BXMuisicAlbumView.m
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMuisicAlbumView.h"


@interface BXMuisicAlbumView ()

@property (nonatomic, strong) UIView                        *albumContainer;
@property (nonatomic, strong) NSMutableArray<CALayer *>     *noteLayers;

@end



@implementation BXMuisicAlbumView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 50, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _noteLayers = [NSMutableArray array];
        
        _albumContainer =[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_albumContainer];
        
        CALayer *backgroudLayer = [CALayer layer];
        backgroudLayer.frame = self.bounds;
        backgroudLayer.contents = (id)[UIImage imageNamed:@"icon_music_cover"].CGImage;
        [_albumContainer.layer addSublayer:backgroudLayer];
        
        _album = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        _album.contentMode = UIViewContentModeScaleAspectFill;
        [_albumContainer addSubview:_album];
        _album.layer.masksToBounds = YES;
        _album.layer.cornerRadius = 10;
        
    }
    return self;
}

- (void)startAnimation:(CGFloat)rate {
    rate = rate <= 0 ? 15 : rate;
    [self resetView];
    
    [self initMusicNotoAnimation:@"icon_home_music1" delayTime:0.0f rate:rate index:0];
    [self initMusicNotoAnimation:@"icon_home_music2" delayTime:1.0f rate:rate index:1];
    [self initMusicNotoAnimation:@"icon_home_music1" delayTime:2.0f rate:rate index:2];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 5.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.albumContainer.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)pause {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pauseAllLayer) object:nil];
    [self performSelector:@selector(pauseAllLayer) withObject:nil afterDelay:.1];
}
- (void)resume {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pauseAllLayer) object:nil];
    
    if (!self.albumContainer.layer.speed) {
        [self resumeLayer:self.albumContainer.layer];
    }
    [_noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
        if (!noteLayer.speed) {
            [self resumeLayer:noteLayer];
        }
    }];
}

- (void)pauseAllLayer {
    if (self.albumContainer.layer.speed) {
        [self stopLayer:self.albumContainer.layer];
    }
    [_noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
        if (noteLayer.speed) {
            [self stopLayer:noteLayer];
        }
    }];
}

- (void)resetView {
    [_noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
        [noteLayer removeAllAnimations];
    }];
    [self.albumContainer.layer removeAllAnimations];
}

- (void)initMusicNotoAnimation:(NSString *)imageName delayTime:(NSTimeInterval)delayTime rate:(CGFloat)rate index:(NSInteger)index{
    //bezier路径帧动画
    CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGFloat sideXLength = 40.0f;
    CGFloat sideYLength = 100.0f;
    
    CGPoint beginPoint = CGPointMake(CGRectGetMidX(self.bounds) - 5, CGRectGetMaxY(self.bounds));
    CGPoint endPoint = CGPointMake(beginPoint.x - sideXLength, beginPoint.y - sideYLength);
    NSInteger controlLength = 45;
    
    CGPoint controlPoint = CGPointMake(beginPoint.x - sideXLength/2.0f - controlLength, beginPoint.y - sideYLength/2.0f + controlLength);
    
    UIBezierPath *customPath = [UIBezierPath bezierPath];
    [customPath moveToPoint:beginPoint];
    [customPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    pathAnimation.path = customPath.CGPath;
    
    
    //旋转帧动画
    CAKeyframeAnimation * rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    [rotationAnimation setValues:@[
                                   [NSNumber numberWithFloat:0],
                                   [NSNumber numberWithFloat:M_PI * 0.10],
                                   [NSNumber numberWithFloat:M_PI * -0.10]]];
    //透明度帧动画
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setValues:@[
                                  [NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:0.2f],
                                  [NSNumber numberWithFloat:0.7f],
                                  [NSNumber numberWithFloat:0.2f],
                                  [NSNumber numberWithFloat:0]]];
    //缩放帧动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(1.0f);
    scaleAnimation.toValue = @(2.0f);
    
    CALayer *layer = nil;
    if (index < _noteLayers.count) {
        layer = _noteLayers[index];
    } else {
        layer = [CALayer layer];
        layer.opacity = 0.0f;
        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
        layer.frame = CGRectMake(beginPoint.x, beginPoint.y, 10, 10);
        [self.layer addSublayer:layer];
        [_noteLayers addObject:layer];
    }
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
    [animationGroup setAnimations:@[pathAnimation, scaleAnimation,  rotationAnimation,opacityAnimation]];
    animationGroup.duration = rate/4.0f;
    animationGroup.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayTime;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animationGroup forKey:@"animationGroup"];
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
        [self stopLayer:self.albumContainer.layer];
        [_noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
            [self stopLayer:noteLayer];
        }];
    }else{
        [self resumeLayer:self.albumContainer.layer];
        [_noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
            [self resumeLayer:noteLayer];
        }];
    }
}



@end


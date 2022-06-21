
#import "continueGift.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import <Lottie/Lottie.h>
#import "SLDeveloperTools.h"

@implementation continueGift


-(void)GiftPopView:(NSDictionary *)giftData andLianSong:(NSString *)liansong{
    _haohualiwus = liansong;
    
    NSString *user_id = [giftData valueForKey:@"user_id"];
    int giftid = [[giftData valueForKey:@"giftid"] intValue];
    NSString *nicename  = [giftData valueForKey:@"nicename"];
    NSString *giftname  = [giftData valueForKey:@"giftname"];
    NSString *giftcount =  [NSString stringWithFormat:@"%@",[giftData valueForKey:@"giftcount"]];
    NSString *avatar    = [giftData valueForKey:@"avatar"];
    NSString *gifticon  = [giftData valueForKey:@"gifticon"];
    NSString *content   = [NSString stringWithFormat:@"送了%@",giftname];
    UIView * GiftPopView = [[UIView alloc] init];//礼物
    self.shakeLabel = [[BXShakeLabel alloc] init];//礼物数量
    int tagID = [user_id intValue]+60000+giftid;
    self.shakeLabel.tag = [user_id intValue]+60000+giftid;
    int height = 40;
    int width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)*0.425;
    int x = 12;
    int flag = 0;
    if (_popListItem1!=0) {
        if (_popListItem1 == tagID && _previousGiftID1 == [giftData valueForKey:@"giftid"]) {
            _popShowTime1=3;
            [self GiftNumAdd:tagID lian:liansong count:[giftcount intValue]];
            flag = 1;
        }
        
        else if(_popListItem1 == tagID  && _previousGiftID1 != [giftData valueForKey:@"giftid"])
        {
            [_GiftqueueArray addObject:giftData];
            [self startGiftTimer];
            flag = 1;
            
        }
    }
    if (_popListItem2!=0) {
        if (_popListItem2 == tagID  && _previousGiftID2 == [giftData valueForKey:@"giftid"]) {
            _popShowTime2 = 3;
            [self GiftNumAdd:tagID lian:liansong count:[giftcount intValue]];
            flag = 1;
        }
        else  if(_popListItem2 == tagID  && _previousGiftID1 != [giftData valueForKey:@"giftid"])
        {
            //如果换了礼物则替换礼物
            [_GiftqueueArray addObject:giftData];
            [self startGiftTimer];
            flag = 1;
        }
    }
    if (flag == 1) {
        
        return;
    }
    int y = 0;
    if (_GiftPosition ==0) {//全空显示在第一
        y = SCREEN_HEIGHT/3;
        _GiftPosition = 1;
        _popListItem1 = (int)self.shakeLabel.tag;
        _previousGiftID1 = [giftData valueForKey:@"giftid"];
        
        
    }
    else if(_GiftPosition ==1)//一位有显示在二
    {
        y = SCREEN_HEIGHT/3+height+5;
        _GiftPosition = 3;
        _popListItem2 = (int)self.shakeLabel.tag;
        _previousGiftID2 = [giftData valueForKey:@"giftid"];
        
    }
    else if (_GiftPosition == 2)//二为有显示在一
    {
        y = SCREEN_HEIGHT/3;
        _GiftPosition = 3;
        _popListItem1 = (int)self.shakeLabel.tag;
        _previousGiftID1 = [giftData valueForKey:@"giftid"];
        
    }
    else                       //全有执行队列
    {
        y = 0;
    }
    if(y==0)//当前位置已满，启动队列
    {
        [_GiftqueueArray addObject:giftData];
        [self startGiftTimer];
        return;
    }
    GiftPopView.frame = CGRectMake(x, y, width, height);
    GiftPopView.backgroundColor = [UIColor clearColor];
    //pop背景图
    UIView *giftBGView = [[UIView alloc] init];
    giftBGView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    giftBGView.layer.opacity = 0.3;
    giftBGView.frame = CGRectMake(0, 0, width, height);
    giftBGView.layer.masksToBounds = YES;
    giftBGView.layer.cornerRadius = height/2;
    giftBGView.layer.contents = (__bridge id)([UIImage imageNamed:@"gift_bg"].CGImage);
    [GiftPopView addSubview:giftBGView];
    
    [self addSubview:GiftPopView];
    //用户显示头像
    UIImage *headerImg = [UIImage imageNamed:@"placeplaceholder"];
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, height, height)];
    [headerView zzl_setImageWithURLString:[NSURL URLWithString:avatar] placeholder:headerImg];
    headerView.layer.masksToBounds = YES;
    [headerView.layer setCornerRadius:(height)/2];
    headerView.alpha = 1;
//    headerView.layer.borderColor = normalColors.CGColor;
//    headerView.layer.borderWidth = 1.0;
    [GiftPopView addSubview:headerView];
    
    //礼物名称
    UILabel *labName = [[UILabel alloc] init];
    labName.textColor = [UIColor whiteColor];
    labName.text = nicename;
    labName.font = [UIFont fontWithName:@"Arial-ItalicMT" size:13];
    labName.frame = CGRectMake(height+5,3,width - 10,20);
    [GiftPopView addSubview:labName];
    
    //礼物信息
    UILabel *labContent = [[UILabel alloc] init];
    labContent.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GradientTextLabel"]];
    labContent.text = content;
    labContent.font = [UIFont fontWithName:@"Arial-ItalicMT" size:13];
    labContent.frame = CGRectMake(height+5,20, width/2,20);
    [GiftPopView addSubview:labContent];
    
    
    //礼物图片
    UIImageView *giftImage = [[UIImageView alloc] initWithFrame:CGRectMake(width,0,height*1.2,height *1.2)];
    NSURL *giftImageURL = [NSURL URLWithString:gifticon];
    [giftImage zzl_setImageWithURLString:giftImageURL placeholder:nil];
    giftImage.alpha = 0;
    GiftPopView.clipsToBounds = NO;
    [GiftPopView addSubview:giftImage];
    
    
    //礼物数量
    self.shakeLabel.frame = CGRectMake(width ,0,90,height);
    self.shakeLabel.textColor = [UIColor sl_colorWithHex:0xF13F6E];
    self.shakeLabel.text = [NSString stringWithFormat:@"x%@",giftcount];
    self.shakeLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:height];
    self.shakeLabel.borderColor = [UIColor whiteColor];
    self.shakeLabel.textAlignment = NSTextAlignmentCenter;
    [GiftPopView addSubview:self.shakeLabel];
    
    [UIView animateWithDuration:0.4 animations:^{
        GiftPopView.frame = CGRectMake(x, y, width, height);
    }];
    [UIView animateWithDuration:0.6 animations:^{
        giftImage.frame = CGRectMake(width - height,0,height, height);
        giftImage.alpha = 1;
    }];
    
    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    cakanimation.duration = 0.7;
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0,3.0,1.0)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    cakanimation.values = @[value1,value2,value3,value4];
    [self.shakeLabel.layer addAnimation:cakanimation forKey:nil];
    cakanimation.removedOnCompletion = NO;
    cakanimation.fillMode = kCAFillModeForwards;

    CGPoint center = [self.shakeLabel.superview convertPoint:self.shakeLabel.center fromView:self.shakeLabel.superview];
    CGRect frame = CGRectMake(center.x-height*3/4, center.y-height*3/4, height*3/2, height*3/2);
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"gift_animation"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    animationView.frame = frame;
    animationView.completionBlock = ^(BOOL animationFinished) {
        
    };
    [self.shakeLabel.superview addSubview:animationView];
    [animationView play];

    if(_GiftPosition == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(hideGiftPop1:) withObject:GiftPopView  waitUntilDone:NO];
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(hideGiftPop2:) withObject:GiftPopView  waitUntilDone:NO];
        });
    }
    
    
    
}
-(void)startGiftTimer{
    if (_GiftqueueTIME==nil) {
        _GiftqueueTIME = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(EnGiftqueue) userInfo:nil repeats:YES];
    }
}
-(int)returnGiftPos:(int)height
{
    int y = 0;
    if (_GiftPosition ==0) {//全空显示在第一
        y = SCREEN_HEIGHT/3;
        _GiftPosition = 1;
    }
    else if(_GiftPosition ==1)//一位有显示在二
    {
        y = SCREEN_HEIGHT/3+height+5;
        _GiftPosition = 3;
    }
    else if (_GiftPosition == 2)//二为有显示在一
    {
        y = SCREEN_HEIGHT/3;
        _GiftPosition = 3;
    }
    else                       //全有执行队列
    {
        y = 0;
    }
    
    return y;
    
}
-(void)hideGiftPop2:(UIView *)agr
{
    
    UIView *GiftPopView = agr;
    int height = SCREEN_HEIGHT/15;
    int width = SCREEN_WIDTH/2;
    
    __weak typeof(self) weakSelf = self;
    if (_popListItem2 != 0) {
        //判断显示时间 如果显示时间大于0则继续递归 否则 让其消失
        
        if (_popShowTime2 >0) {
            _popShowTime2 -= 0.5;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self performSelectorOnMainThread:@selector(hideGiftPop2:) withObject:GiftPopView  waitUntilDone:NO];
            });
        }
        else
        {
            [UIView animateWithDuration:0.8 animations:^{
                GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
                GiftPopView.alpha = 0;
                
                if (GiftPopView.frame.origin.y<= SCREEN_HEIGHT/3) {
                    //移除一级弹出
                    weakSelf.popListItem1 = 0;
                    if(weakSelf.GiftPosition == 3)
                        weakSelf.GiftPosition = 2;//如果现在上下都有则设置成仅下有
                    else weakSelf.GiftPosition = 0;                   //否则设置成全无
                }
                else
                {
                    weakSelf.popListItem2 = 0;
                    //移除二级弹出
                    if(weakSelf.GiftPosition == 3)   weakSelf.GiftPosition = 1;//如果现在上下都有则设置成仅上有
                    else weakSelf.GiftPosition = 0;                   //否则设置成全无
                }
            }];
            
            //0.8秒后删除视图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
            });
            
        }
        
        
        
        return;
    }
    [UIView animateWithDuration:0.8 animations:^{
        GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
        GiftPopView.alpha = 0;
        
        if (GiftPopView.frame.origin.y<= SCREEN_HEIGHT/3) {
            //移除一级弹出
            weakSelf.popListItem1 = 0;
            if(weakSelf.GiftPosition == 3)
                weakSelf.GiftPosition = 2;//如果现在上下都有则设置成仅下有
            else weakSelf.GiftPosition = 0;                   //否则设置成全无
        }
        else
        {
            weakSelf.popListItem2 = 0;
            //移除二级弹出
            if(weakSelf.GiftPosition == 3)   weakSelf.GiftPosition = 1;//如果现在上下都有则设置成仅上有
            else weakSelf.GiftPosition = 0;                   //否则设置成全无
        }
    }];
    
    //0.8秒后删除视图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
    });
    
    
}
-(void)hideGiftPop1:(UIView *)agr
{
    
    UIView *GiftPopView = agr;
    int height = SCREEN_HEIGHT/15;
    int width = SCREEN_WIDTH/2;
    
    __weak typeof(self) weakSelf = self;
    if (_popListItem1 != 0) {
        //判断显示时间 如果显示时间大于0则继续递归 否则 让其消失
        
        if (_popShowTime1 >0) {
            _popShowTime1 -= 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self performSelectorOnMainThread:@selector(hideGiftPop1:) withObject:GiftPopView  waitUntilDone:NO];
            });
        }
        else
        {
            [UIView animateWithDuration:0.8 animations:^{
                GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
                GiftPopView.alpha = 0;
                
                if (GiftPopView.frame.origin.y<= SCREEN_HEIGHT/3) {
                    //移除一级弹出
                    weakSelf.popListItem1 = 0;
                    if(weakSelf.GiftPosition == 3)
                        weakSelf.GiftPosition = 2;//如果现在上下都有则设置成仅下有
                    else weakSelf.GiftPosition = 0;                   //否则设置成全无
                }
                else
                {
                    weakSelf.popListItem2 = 0;
                    //移除二级弹出
                    if(weakSelf.GiftPosition == 3)   weakSelf.GiftPosition = 1;//如果现在上下都有则设置成仅上有
                    else weakSelf.GiftPosition = 0;                   //否则设置成全无
                }
            }];
            
            //0.8秒后删除视图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
            });
        }
        return;
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
        GiftPopView.alpha = 0;
        
        if (GiftPopView.frame.origin.y<= SCREEN_HEIGHT/3) {
            //移除一级弹出
            weakSelf.popListItem1 = 0;
            if(weakSelf.GiftPosition == 3)
                weakSelf.GiftPosition = 2;//如果现在上下都有则设置成仅下有
            else weakSelf.GiftPosition = 0;                   //否则设置成全无
        }
        else
        {
            weakSelf.popListItem2 = 0;
            //移除二级弹出
            if(weakSelf.GiftPosition == 3)   weakSelf.GiftPosition = 1;//如果现在上下都有则设置成仅上有
            else weakSelf.GiftPosition = 0;                   //否则设置成全无
        }
    }];
    
    //0.8秒后删除视图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
    });
}
-(void)removeGiftPop:(UIView *)viewa
{
    [viewa removeFromSuperview];
    viewa=nil;
}
//礼物队列
-(void)EnGiftqueue {
    NSLog(@"当前队列个数:%lu",(unsigned long)_GiftqueueArray.count);
    if (_GiftqueueArray.count == 0 || _GiftqueueArray == nil) {//判断队列中有item且不是满屏
        [_GiftqueueTIME invalidate];
        _GiftqueueTIME = nil;
        return;
    }
    
    NSDictionary *Dic = [_GiftqueueArray firstObject];
    
    [_GiftqueueArray removeObjectAtIndex:0];
    
    [self GiftPopView:Dic andLianSong:_haohualiwus];
}
//添加礼物数量
-(void)GiftNumAdd:(int)tag lian:(NSString *)lian count:(int)count
{
    int height = SCREEN_HEIGHT/15;
    __weak UILabel *labGiftNum = [self viewWithTag:tag];
    int oldnum = [[labGiftNum.text substringFromIndex:1] intValue];
    int newnum;
    if (IsEquallString(lian, @"1")) {
        newnum = oldnum +count;
    }else{
         newnum = oldnum +1;
    }
    
    labGiftNum.text = [NSString stringWithFormat:@"x%d",newnum];
    if(labGiftNum == nil) return;
    
    if(labGiftNum == nil)
    {
       
        return;
    }
    
    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    cakanimation.duration = 0.7;
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0,3.0,1.0)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    cakanimation.values = @[value1,value2,value3,value4];
    [labGiftNum.layer addAnimation:cakanimation forKey:nil];
    cakanimation.removedOnCompletion = NO;
    cakanimation.fillMode = kCAFillModeForwards;
    
    CGPoint center = [labGiftNum.superview convertPoint:labGiftNum.center fromView:labGiftNum.superview];
    CGRect frame = CGRectMake(center.x-height*3/4, center.y-height*3/4, height*3/2, height*3/2);
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"gift_animation"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    animationView.frame = frame;
    animationView.completionBlock = ^(BOOL animationFinished) {
        
    };
    [labGiftNum.superview addSubview:animationView];
    [animationView play];

}
-(void)stopTimerAndArray{
    _GiftqueueArray = nil;
    _GiftqueueArray = [NSMutableArray array];
    [_GiftqueueTIME invalidate];
    _GiftqueueTIME = nil;
}
-(void)initGift{
    
    _GiftPosition = 0;
    _popListItem1 = 0;
    _popListItem2 = 0;
    _previousGiftID1 = 0;
    _previousGiftID1 = 0;
    _GiftqueueArray = [[NSMutableArray alloc] init];
}

@end

//
//  continueGift.h
//  BXlive
//
//  Created by bxlive on 2016/11/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BXShakeLabel.h"

@interface continueGift : UIView

@property(nonatomic,strong)NSString *haohualiwus;//判断是不是连送
@property(nonatomic,strong)UIButton *imageVs;
@property(nonatomic,strong)UIButton *imageView;

@property(nonatomic,strong)NSNumber *previousGiftID2;//礼物上次id 2
@property(nonatomic,strong)NSNumber *previousGiftID1;//礼物上次id 1 用于判断是否是连送礼物
@property(nonatomic,assign)int popShowTime2;//礼物下显示时间
@property(nonatomic,assign)int popShowTime1;//礼物上显示时间
@property(nonatomic,assign)int popListItem2;
@property(nonatomic,assign)int popListItem1;
@property(nonatomic,assign)int GiftPosition;//标记礼物位置 0 全无 1上有，2下有，3全有；
@property(nonatomic,strong)NSMutableArray *GiftqueueArray;
@property(nonatomic,strong)NSTimer *GiftqueueTIME;

@property (nonatomic , strong) UIView * giftPopView;
@property (nonatomic , strong) UILabel * labGiftNum;
@property (nonatomic , strong) UIView * giftBGView;
@property (nonatomic , strong) UIImageView *headerView;
@property (nonatomic , strong) UILabel *labName;
@property (nonatomic , strong) UILabel *labContent;
@property (nonatomic , strong) UIImageView *giftImage;

@property (nonatomic , strong) BXShakeLabel *shakeLabel;


-(void)GiftPopView:(NSDictionary *)giftData andLianSong:(NSString *)liansong;

-(void)initGift;//初始化礼物

-(void)stopTimerAndArray;

@end

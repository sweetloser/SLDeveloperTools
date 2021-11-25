//
//  BXexpensiveGiftV.h
//  BXlive
//
//  Created by bxlive on 2017/1/9.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHLuxuryGiftForSproutsister.h"//萌妹子
#import "BXHLuxuryGiftForCastleOfLove.h"//城堡


@protocol haohuadelegate <NSObject>

@optional
-(void)expensiveGiftdelegate:(NSDictionary *)giftData;
-(void)expensiveGiftEndEffect:(NSString *)giftId userId:(NSString *)userId;

@end

@interface BXexpensiveGiftV : UIView

@property(nonatomic,assign) id<haohuadelegate>delegate;
@property(nonatomic,strong) NSMutableArray *expensiveGiftCount;
@property(nonatomic,assign) int haohuaCount;

-(void)addArrayCount:(NSDictionary *)dic;
-(void)enGiftEspensive;
-(void)stopHaoHUaLiwu;

@end

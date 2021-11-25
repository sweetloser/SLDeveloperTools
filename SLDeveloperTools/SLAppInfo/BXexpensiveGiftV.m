
#import "BXexpensiveGiftV.h"
#import "BXDeluxeGiftTool.h"
#import "BXDeluxeGiftEmptyView.h"



@interface BXexpensiveGiftV () <BXDeluxeGiftViewDelegate>

@property (strong, nonatomic) BXDeluxeGiftView *deluxeGiftView;



@end

@implementation BXexpensiveGiftV
-(instancetype)init{
    self = [super init];
    if (self) {
        _haohuaCount = 0;
        _expensiveGiftCount = [NSMutableArray array];
    }
    return self;
}
-(void)sethaohuacount{
    if (_haohuaCount == 0) {
        _haohuaCount = 1;
    }
    else{
        _haohuaCount = 0;
    }
}
-(void)addArrayCount:(NSDictionary *)dic{
    [_expensiveGiftCount addObject:dic];
}
-(void)stopHaoHUaLiwu{
    _expensiveGiftCount = nil;
}
-(void)enGiftEspensive{
    if (_expensiveGiftCount && _expensiveGiftCount.count) {
        NSDictionary *Dic = [_expensiveGiftCount firstObject];
        [_expensiveGiftCount removeObjectAtIndex:0];
        [self expensiveGiftPopView:Dic];
    }
}

-(void)expensiveGiftPopView:(NSDictionary *)giftData{
    NSString *giftId =  [NSString stringWithFormat:@"%ld",[giftData[@"giftid"] integerValue]];
    NSString *duration = giftData[@"duration"];
    NSString *layout = giftData[@"layout"];
    NSString *icon = giftData[@"icon"];
    NSInteger number = [giftId intValue];
    //137感恩有你
    if (number == 97) {//城堡
        _deluxeGiftView = [[BXHLuxuryGiftForCastleOfLove alloc]initWithAvatar:giftData[@"avatar"] Anchor_avatar:giftData[@"anchor_avatar"] GiftId:giftId oneFrameDuration:[duration floatValue] layout:[layout integerValue]];
    } else if (number == 101) {//萌妹子
        _deluxeGiftView = [[BXHLuxuryGiftForSproutsister alloc]init];
    } else {
        if (number == 132) {
            number = 131;
            giftId = [NSString stringWithFormat:@"%ld",(long)number];
        }
        if ([BXDeluxeGiftTool giftIsExistWithGiftId:giftId]) {
            _deluxeGiftView = [[BXDeluxeGiftView alloc]initWithGiftId:giftId oneFrameDuration:[duration floatValue] layout:[layout integerValue]];
        } else {
            [BXDeluxeGiftTool updatePriorityWithGiftId:giftId];
            
            BXDeluxeGiftEmptyView *giftEmptyView = [[BXDeluxeGiftEmptyView alloc]initWithFrame:CGRectZero];
            [giftEmptyView addGiftUrlImage:icon];
            _deluxeGiftView = giftEmptyView;
        }
        _deluxeGiftView.userId =  giftData[@"user_id"];
    }

    if (_deluxeGiftView) {
        _deluxeGiftView.delegate = self;
        [self sethaohuacount];
        [self addSubview:_deluxeGiftView];
    }
}

#pragma - mark BXDeluxeGiftViewDelegate
- (void)deluxeGiftViewDidCompleted:(NSString *)giftId userId:(NSString *)userId{
    if (_deluxeGiftView) {
        [_deluxeGiftView removeFromSuperview];
        _deluxeGiftView = nil;
        [self sethaohuacount];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(expensiveGiftEndEffect:userId:)]) {
            [self.delegate expensiveGiftEndEffect:giftId userId:userId];
        }
        
        if (_expensiveGiftCount.count > 0) {
            [self.delegate expensiveGiftdelegate:nil];
        }
    }
}

@end

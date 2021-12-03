//
//  BXDaemonListVC.h
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BaseVC.h"

/**
 守护列表
 */

@protocol BXDaemonListBuyGuardGiftDelegate <NSObject>

-(void)sendGiftWithData:(NSDictionary *)data andLianFa:(NSString *)lianFa type:(NSString *)type;

@end

@interface BXDaemonListVC : BaseVC


@property(nonatomic,assign)NSInteger type;

@property(nonatomic,assign)id<BXDaemonListBuyGuardGiftDelegate> delegate;

@end

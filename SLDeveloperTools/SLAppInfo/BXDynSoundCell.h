//
//  BXDynSoundCell.h
//  BXlive
//
//  Created by mac on 2020/7/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynBaseTableviewCell.h"
//#import "BXDynamicModel.h"
@class BXDynSoundCell;
NS_ASSUME_NONNULL_BEGIN

@interface BXDynSoundCell : BXDynBaseTableviewCell
@property (copy, nonatomic) void (^DidSoundIndex)(NSString *voiceurl, BXDynSoundCell *cell);
@property(nonatomic, strong)UIImageView *soundImageView;
@property(nonatomic, strong)UILabel *timeLable;
@property(nonatomic, strong)NSString *originTime;
- (void)StopPalyVoice;
- (void)rotateView;
- (void)StoprotateView;
//@property(nonatomic, strong)BXDynamicModel *model;
@end

NS_ASSUME_NONNULL_END

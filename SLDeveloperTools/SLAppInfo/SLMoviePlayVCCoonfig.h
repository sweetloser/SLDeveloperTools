//
//  SLMoviePlayVCCoonfig.h
//  BXlive
//
//  Created by sweetloser on 2020/8/12.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
@class BXLiveBaseVC;
@interface SLMoviePlayVCCoonfig : BaseObject

@property(nonatomic, strong)NSMutableArray *liveRooms;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, assign)NSInteger lastIndex;
@property(nonatomic, weak)BXLiveBaseVC *movieVC;

@property(nonatomic, copy)NSDictionary *additionalParams;


@property(nonatomic, copy, nullable)NSString *loadUrl;
@property(nonatomic,assign)BOOL hasMore;

+(SLMoviePlayVCCoonfig *)shareMovePlayConfig;

-(void)getMoreLive:(void(^)(void))complateBlock;



@end

NS_ASSUME_NONNULL_END

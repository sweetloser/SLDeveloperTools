//
//  TMSeedingBaseDynVC.h
//  BXlive
//
//  Created by mac on 2020/11/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface TMSeedingBaseDynVC : BaseVC<JXCategoryListContentViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger page;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

-(void)getData:(dispatch_group_t __nullable)group;

-(void)TableDragWithDown;

-(void)loadMoreData;

@end

NS_ASSUME_NONNULL_END

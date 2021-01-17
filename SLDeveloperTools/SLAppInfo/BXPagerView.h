//
//  BXPagerView.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLocation.h"
#import "BXCommentView.h"
#import <ZFPlayer/ZFPlayer.h>
@protocol BXPagerViewDelegate <NSObject>

- (void)pagerViewFrameDidChangeWithContentOffsetY:(CGFloat)contentOffsetY duration:(NSTimeInterval)duration;

@end

@interface BXPagerView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) BXCommentView *commentView;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) BXLocation *location;

@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, assign) CGFloat bottomSpace;
@property (nonatomic, assign, readonly) CGFloat initialY;
@property (nonatomic, weak) id<BXPagerViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

//headerType 0：无距离信息 1：有距离信息
- (instancetype)initWithFrame:(CGRect)frame headerType:(NSInteger)headerType;
- (void)open;

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop;

@end



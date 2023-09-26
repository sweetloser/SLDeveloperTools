//
//  BXVideoRecordProcessView.m
//  TXLiteAVDemo
//
//  Created by zhangxiang on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "BXVideoRecordProcessView.h"
#import "UIView+Additions.h"
#import "../SLMacro/SLMacro.h"
#import "BXLiveUser.h"

#define VIEW_PAUSE_WIDTH 2
#define MAX_RECORD_TIME  15.f
#define MIN_RECORD_TIME  5.f

@implementation BXVideoRecordProcessView
{
    UIView *    _processView;
    UIView *    _deleteView;
    CGSize      _viewSize;
    NSMutableArray * _pauseViewList;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewSize = frame.size;
        _processView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _viewSize.height)];
        _processView.backgroundColor = sl_normalColors;
        [self addSubview:_processView];
        CGFloat progressWidth = 0;
        if ([[BXLiveUser currentBXLiveUser].is_creation integerValue]) {
            progressWidth = MIN_RECORD_TIME / (MAX_RECORD_TIME * 5 * 4);
        }else{
            progressWidth = MIN_RECORD_TIME / MAX_RECORD_TIME;
        }
        UIView * minimumView = [[UIView alloc] initWithFrame:CGRectMake(self.width * progressWidth, 0, 3, self.frame.size.height)];
        minimumView.backgroundColor = sl_normalColors;
        [self addSubview:minimumView];
      
        _pauseViewList = [NSMutableArray array];
    }
    return self;
}

-(void)update:(CGFloat)progress
{
    _processView.frame = CGRectMake(0, 0, _viewSize.width * progress, _viewSize.height);
}

-(void)pause
{
    UIView *pauseView = [[UIView alloc] initWithFrame:CGRectMake(_processView.right - VIEW_PAUSE_WIDTH, _processView.y, VIEW_PAUSE_WIDTH, _processView.height)];
    pauseView.backgroundColor = [UIColor whiteColor];
    [_pauseViewList addObject:pauseView];
    [self addSubview:pauseView];
}

-(void)prepareDeletePart
{
    if (_pauseViewList.count == 0) {
        return;
    }
    UIView *lastPauseView = [_pauseViewList lastObject];
    UIView *beforeLastPauseView = nil;
    if (_pauseViewList.count > 1) {
        beforeLastPauseView = [_pauseViewList objectAtIndex:_pauseViewList.count - VIEW_PAUSE_WIDTH];
    }
    
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(beforeLastPauseView.right, _processView.y, lastPauseView.left - beforeLastPauseView.right, _processView.height)];
//    _deleteView.backgroundColor = CHHCOLOR_D(0x10acc0);
    _deleteView.backgroundColor = sl_normalColors;
    [self addSubview:_deleteView];
}

-(void)cancelDelete
{
    if (_deleteView) {
        [_deleteView removeFromSuperview];
    }
}

-(void)comfirmDeletePart
{
    UIView *lastPauseView = [_pauseViewList lastObject];
    if (lastPauseView) {
        [lastPauseView removeFromSuperview];
    }
    [_pauseViewList removeObject:lastPauseView];
    [_deleteView removeFromSuperview];
}

-(void)deleteAllPart
{
    for(UIView *view in _pauseViewList)
    {
        [view removeFromSuperview];
    }
    [_pauseViewList removeAllObjects];
    [_deleteView removeFromSuperview];
}
@end

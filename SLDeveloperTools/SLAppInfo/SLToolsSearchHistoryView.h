//
//  SLToolsSearchHistoryView.h
//  BXlive
//
//  Created by sweetloser on 2020/11/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLToolsSearchHistoryViewProtocol <NSObject>

-(void)cellDidClickWithKeyword:(NSString *)keyword;
-(void)cleanAllKeyword;

@end

@interface SLToolsSearchHistoryView : UIView

@property(nonatomic,weak)id <SLToolsSearchHistoryViewProtocol> delegate;

@property(nonatomic,copy)NSString *mkid;

-(void)reloadHistoryData;

@end

NS_ASSUME_NONNULL_END

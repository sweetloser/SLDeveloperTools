//
//  SLToolsSearchHotView.h
//  BXlive
//
//  Created by sweetloser on 2020/11/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLToolsSearchHotViewTypeSmallShop,
    SLToolsSearchHotViewTypeTaokeThirdShop,
} SLToolsSearchHotViewType;

@protocol SLToolsSearchHotViewProtocol <NSObject>

-(void)cellDidClickWithKeyword:(NSString *)keyword;

@end

@interface SLToolsSearchHotView : UIView

@property(nonatomic,weak)id <SLToolsSearchHotViewProtocol> delegate;

-(instancetype)initWithFrame:(CGRect)frame type:(SLToolsSearchHotViewType)type;

@end

NS_ASSUME_NONNULL_END

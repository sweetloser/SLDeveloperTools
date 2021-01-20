//
//  BXDynCircleHeaderView.h
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircleHeaderView : UIView
@property(nonatomic, strong)BXDynCircleModel *model;
@property (nonatomic,copy)void(^DidClickCircle)(NSInteger type);
@property(nonatomic, assign)BOOL isHiddenPart;
- (void)scrollViewDidScroll:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END

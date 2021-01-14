//
//  BXDynCircelOperAlert.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircelOperAlert : UIView
@property(nonatomic,copy)void(^DidOpeClick)(NSInteger tag);
-(instancetype)initWithItemArray:(NSArray *)ItemArray;


-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

//
//  BXDynTipOffPerplePictureFooterView.h
//  BXlive
//
//  Created by mac on 2020/9/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ReturnPictureDelegate <NSObject>

-(void)GetTipOffPicArray:(NSArray *)array;

@end
@interface BXDynTipOffPerplePictureFooterView : UIView
@property(nonatomic, weak)id<ReturnPictureDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *AddPicArray;
@property(nonatomic, strong)NSMutableArray *picArray;
@end

NS_ASSUME_NONNULL_END

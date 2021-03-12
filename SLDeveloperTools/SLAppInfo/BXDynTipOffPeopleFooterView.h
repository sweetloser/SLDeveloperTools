//
//  BXDynTipOffPeopleFooterView.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHPlaceholderTextView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ReturnContentTextDelegate <NSObject>

-(void)GetTipOffText:(NSString *)string picArray:(NSArray *)array;
-(void)GetTipOffText:(NSString *)string;
@end
@interface BXDynTipOffPeopleFooterView : UIView
@property(nonatomic, weak)id<ReturnContentTextDelegate>delegate;
//@property(nonatomic, strong)GHPlaceholderTextView *textView;
@property(nonatomic, strong)NSMutableArray *AddPicArray;
@property(nonatomic, strong)NSMutableArray *picArray;
@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, assign)BOOL isText;
@end

NS_ASSUME_NONNULL_END

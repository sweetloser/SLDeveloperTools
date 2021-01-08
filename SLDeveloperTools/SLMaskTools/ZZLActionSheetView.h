//
//  ZZLActionSheetView.h
//  BXlive
//
//  Created by bxlive on 2018/4/18.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sl_ActionSheetCancelBlock)(void);
typedef void (^sl_ActionSheetselectBlock)(NSInteger);

@interface ZZLActionSheetView : UIView


/**
 ActionSheet 自定义
 
 @param titleView 头部视图 (可以为空, 默认有一个头部视图)
 @param optionsArr 需要显示的内容数组
 @param cancelTitle 取消名称
 @param cancelBlock 取消回调
 @param selectBlock 选择回调
 */
- (instancetype)initWithTitleView:(UIView *)titleView
                       optionsArr:(NSArray *)optionsArr
                      cancelTitle:(NSString *)cancelTitle
                      cancelBlock:(sl_ActionSheetCancelBlock)cancelBlock
                      selectBlock:(sl_ActionSheetselectBlock)selectBlock;

- (void)show;

@end

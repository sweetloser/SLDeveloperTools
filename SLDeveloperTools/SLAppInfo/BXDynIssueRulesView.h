//
//  BXDynIssueRulesView.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynIssueRulesView : UIView
@property (copy, nonatomic) void (^ChooseRules)(NSInteger type);

@property(nonatomic, strong)UIImageView *image1, *image2, *image3, *image4;
@property(nonatomic, strong)UILabel *label1, *label2, *label3, *label4;

@end

NS_ASSUME_NONNULL_END

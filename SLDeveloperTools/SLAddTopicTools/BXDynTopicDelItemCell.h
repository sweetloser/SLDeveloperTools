//
//  BXDynTopicDelItemCell.h
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicDelItemCell : UICollectionViewCell
@property(nonatomic, strong)NSString *topicStr;
@property(nonatomic, strong)NSString *StrType;
@property(nonatomic, strong)UILabel *concentLabel;
@property(nonatomic, strong)UIButton *button;
@property (copy, nonatomic) void (^DidDelIndex)();
@end

NS_ASSUME_NONNULL_END

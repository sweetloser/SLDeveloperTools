//
//  BXInsetsLable.h
//  BXlive
//
//  Created by mac on 2020/6/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXInsetsLable : UILabel
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;
@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) UIEdgeInsets textInsets;

@end

NS_ASSUME_NONNULL_END

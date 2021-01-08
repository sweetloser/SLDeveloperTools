//
//  BXRefreshHeader.h
//  BXlive
//
//  Created by bxlive on 2018/9/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface BXRefreshHeader : MJRefreshHeader

@property (strong, nonatomic) UIColor *StrokeCircleColor;
@property (strong, nonatomic) UIColor *TitleColor;

@property (strong, nonatomic) UIImageView *logoView;
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) CAShapeLayer *circleLayer;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UILabel *titleLb;

@end

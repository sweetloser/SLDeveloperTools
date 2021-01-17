//
//  HMovieModel+DescribeAttri.h
//  BXlive
//
//  Created by bxlive on 2019/2/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXHMovieModel.h"

@interface BXHMovieModel (DescribeAttri)

@property (copy, nonatomic) NSMutableAttributedString *describeAttri;

@property (assign, nonatomic) CGFloat describeHeight;

@property (assign, nonatomic) NSInteger selectStatus;

@property (assign, nonatomic) NSInteger tapStatus;

@end


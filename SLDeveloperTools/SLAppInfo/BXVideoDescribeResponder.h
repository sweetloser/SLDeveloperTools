//
//  BXliveDescribeResponder.h
//  BXlive
//
//  Created by bxlive on 2019/3/4.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXHMovieModel.h"
#import "SLAmwayListModel.h"
#import "SLAmwayDetailModel.h"

@interface BXVideoDescribeResponder : NSObject

+ (void)processVideoDescribeAttri:(BXHMovieModel *)video;

+ (void)processAmwayVideoContentAttri:(SLAmwayListModel *)video;

+ (void)processAmwayDetailContentAttri:(SLAmwayDetailModel *)video;

@end



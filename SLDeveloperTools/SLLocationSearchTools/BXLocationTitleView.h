//
//  BXLocationTitleView.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLocation.h"

@interface BXLocationTitleView : UIView

@property (strong, nonatomic) BXLocation *location;

- (instancetype)initWithType:(NSInteger)type;

@end



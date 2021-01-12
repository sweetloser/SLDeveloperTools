//
//  BXliveSelectSpeedView.h
//  BXlive
//
//  Created by bxlive on 2019/4/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXVideoSelectSpeedView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^didSelectedSpeed)(NSInteger speed);

@end



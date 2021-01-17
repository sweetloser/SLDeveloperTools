//
//  BXFocusView.h
//  BXlive
//
//  Created by bxlive on 2019/2/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXFocusView : UIImageView

@property (copy, nonatomic) void (^tapAction)();
@property(nonatomic,assign)BOOL sl_animationing;
-(void)VisiableViewFocusStatus:(BOOL)status;
- (void)resetView;
- (void)didfocusView;

@end

NS_ASSUME_NONNULL_END

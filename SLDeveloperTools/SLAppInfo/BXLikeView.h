//
//  BXLikeView.h
//  BXlive
//
//  Created by bxlive on 2019/3/19.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXLikeView : UIView

@property (nonatomic, strong) UIImageView      *likeBefore;
@property (nonatomic, strong) UIImageView      *likeAfter;

- (void)resetView;

-(void)startLikeAnim:(BOOL)isLike;

@property(nonatomic,copy)void(^likeView)(void);

@end


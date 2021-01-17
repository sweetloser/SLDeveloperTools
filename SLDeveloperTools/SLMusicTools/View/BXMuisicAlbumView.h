//
//  BXMuisicAlbumView.h
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHMovieModel.h"


@interface BXMuisicAlbumView : UIView

@property (nonatomic, strong) UIImageView      *album;

- (void)startAnimation:(CGFloat)rate;
- (void)resetView;

- (void)pause;
- (void)resume;

@end

//
//  BXMuiscReusableView.h
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DSMuiscReusableViewDelegate <NSObject>

- (void)playMuiscBtn:(UIButton *)sender;

@end


@interface BXMuiscReusableView : UICollectionReusableView

@property (nonatomic, weak) id<DSMuiscReusableViewDelegate> delegate;

@property (nonatomic, strong) BXMusicModel *music;

@property (nonatomic, assign) CGFloat offset;


@property (nonatomic, strong) UIButton *playBtn;

@end

NS_ASSUME_NONNULL_END

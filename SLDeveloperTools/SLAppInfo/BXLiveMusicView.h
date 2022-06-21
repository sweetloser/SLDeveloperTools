//
//  BXLiveMusicView.h
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMusicModel.h"

@protocol BXLiveMusicViewDelegate <NSObject>

- (void)liveMusicViewOperationType:(NSInteger)type; //0：歌词报错 1：音效 2：重唱 3：结束

@end

@interface BXLiveMusicView : UIView

@property (nonatomic, strong) BXMusicModel *music;
@property (nonatomic, weak) id<BXLiveMusicViewDelegate> delegate;

- (instancetype)initWithMusic:(BXMusicModel *)music;
- (void)setCurrentTime:(CGFloat)currentTime duration:(CGFloat)duration;

- (void)stopDisplayLink;

@end



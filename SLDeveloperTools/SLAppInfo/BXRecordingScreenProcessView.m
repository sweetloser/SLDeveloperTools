//
//  BXRecordingScreenProcessView.m
//  BXlive
//
//  Created by bxlive on 2019/1/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXRecordingScreenProcessView.h"
#import "SLDeveloperTools.h"

@interface BXRecordingScreenProcessView ()

@property (strong, nonatomic) UIImageView *progressView;
@property (assign, nonatomic) CGSize viewSize;

@end

@implementation BXRecordingScreenProcessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewSize = frame.size;
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
        
        UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(_viewSize.width * BX_MIN_RECORD_TIME / BX_MAX_RECORD_TIME - 3, 0, 3, 3)];
        pointView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pointView];
        
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, _viewSize.height)];
        _progressView.image = CImage(@"progress_left_2");
        [self addSubview:_progressView];
    
    }
    return self;
}

- (void)update:(CGFloat)progress {
    [UIView animateWithDuration:.2 animations:^{
        self.progressView.frame = CGRectMake(0, 0, self.viewSize.width * progress, self.viewSize.height);
    }];
}

- (void)updateProgressWithTime:(NSInteger)time {
    CGFloat progress = time * 1.0 / BX_MAX_RECORD_TIME;
    [self update:progress];
}

@end

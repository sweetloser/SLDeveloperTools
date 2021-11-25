//
//  GYNoticeViewCell.m
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import "GYNoticeViewCell.h"
#import <Masonry/Masonry.h>
@implementation GYNoticeViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (GYRollingDebugLog) {
            NSLog(@"init a cell from code: %p", self);
        }
        _textLabelLeading = 10;
        _textLabelTrailing = 10;
        _reuseIdentifier = reuseIdentifier;
        [self setupInitialUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        if (GYRollingDebugLog) {
            NSLog(@"init a cell from xib");
        }
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithReuseIdentifier:@""];
}

- (void)setupInitialUI
{
    self.backgroundColor = [UIColor clearColor];
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    _imageV = [[UIImageView  alloc]init];
    [self.contentView addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(15);
    }];
    _imageV.image = [UIImage imageNamed:@"lc_play_laba"];
    
    _textLabelContentView = [UIView new];
    _textLabelContentView.clipsToBounds = YES;
    [_contentView addSubview:_textLabelContentView];
    
    
    _textLabel = [[UILabel alloc]init];
    [_textLabelContentView addSubview:_textLabel];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    if (nil != _textLabel) {
        CGFloat lead = _textLabelLeading;
        if (lead < 0) {
            NSLog(@"⚠️⚠️textLabelLeading must >= 0⚠️⚠️");
            lead = 0;
        }
        CGFloat trai = _textLabelTrailing;
        if (trai < 0) {
            NSLog(@"⚠️⚠️textLabelTrailing must >= 0⚠️⚠️");
            trai = 0;
        }
        CGFloat width = self.frame.size.width - lead - trai;
        if (width < 0) {
            NSLog(@"⚠️⚠️width must >= 0⚠️⚠️");
            width = 0;
        }
        _textLabelContentView.frame = CGRectMake(lead, 0, width, self.frame.size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
        label.text = self.textLabel.text;
        label.font = self.textLabel.font;
        [label sizeToFit];
        CGFloat textW = CGRectGetWidth(label.frame);
        self.textLabel.frame = CGRectMake(0, 0, textW, _textLabelContentView.frame.size.height);
        if (textW>width) {
//            [self.textLabel.layer removeAllAnimations];
        //添加帧动画 实现滚动效果 其实就是改变x的值
            CAKeyframeAnimation* keyFrame = [CAKeyframeAnimation animation];
            keyFrame.keyPath = @"transform.translation.x";
            keyFrame.values = @[@(0), @(-textW - 10 + self.textLabelContentView.bounds.size.width)];
            keyFrame.repeatCount = NSIntegerMax;
            keyFrame.autoreverses = NO;
            keyFrame.duration = 0.3 * self.textLabel.text.length*0.8;
            [self.textLabel.layer addAnimation:keyFrame forKey:@"keyFrame"];
        }
    }
}

- (void)setContentText:(NSString *)contentText{
    _contentText = contentText;
    self.textLabel.text = contentText;
}

- (void)dealloc
{
    if (GYRollingDebugLog) {
        NSLog(@"%p, %s", self, __func__);
    }
    
}


@end

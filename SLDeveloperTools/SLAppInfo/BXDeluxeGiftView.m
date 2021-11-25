//
//  BXDeluxeGiftView.m
//  BXlive
//
//  Created by bxlive on 2018/10/30.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXDeluxeGiftView.h"
#import <YYImage.h>
#import "BXDeluxeGiftTool.h"
#import "CALayer+FXAnimationEngine.h"
#import "SLDeveloperTools.h"


@interface BXDeluxeGiftView ()<FXAnimationDelegate>

@property (nonatomic, copy) NSString *giftId;



@end

@implementation BXDeluxeGiftView

- (instancetype)initWithGiftId:(NSString *)giftId oneFrameDuration:(NSTimeInterval)oneFrameDuration layout:(NSInteger)layout {
    if ([super init]) {
        _giftId = giftId;
        
        NSMutableArray *images = [NSMutableArray array];
        BOOL giftIsExistInLocation = [BXDeluxeGiftTool giftIsExistInLocationWithGiftId:giftId];
        if (giftIsExistInLocation) {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *path = [bundle pathForResource:@"Gift" ofType:@"plist"];
            NSDictionary *giftsDic = [NSDictionary dictionaryWithContentsOfFile:path];
            NSDictionary *giftDic = giftsDic[giftId];
            NSString *name = giftDic[@"name"];
            NSInteger count = [giftDic[@"count"] integerValue];
            
            for (NSInteger i = 1; i <= count; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@_%03ld",name,i];
                NSString *imagePath = [bundle pathForResource:imageName ofType:@"png"];
                [images addObject:imagePath];
            }
        } else {
            NSString *path = [BXDeluxeGiftTool getGiftPathWithGiftId:giftId];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDirectoryEnumerator *enumerator =[fileManager enumeratorAtPath:path];
            NSString *filePath = nil;
            while(filePath = [enumerator nextObject]) {
                filePath = [path stringByAppendingPathComponent:filePath];
                [images addObject:filePath];
            }
            [images sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
        }
        
        NSMutableArray *pathImage = [NSMutableArray array];
        for (int i =0; i<images.count; i++) {
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:images[i]];
            if (savedImage) {
                [pathImage addObject:savedImage];
            }
        }
        UIImage *image = pathImage[0];
        CGFloat y = 0;
        CGFloat height = __kHeight;
        if (layout && image.size.width) {
            height = __kWidth * image.size.height / image.size.width;
            if (layout == 1) {
                y = __kHeight - height;
            } else if (layout == 2) {
                y = (__kHeight - height) / 2;
            }
        }
        UIView *backImage = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)];
        [self addSubview:backImage];
        FXKeyframeAnimation *animation = [FXKeyframeAnimation animation];
        animation.delegate = self;
        animation.count = pathImage.count;
        animation.duration = pathImage.count * oneFrameDuration;
        animation.repeats = 1;
        animation.frames = pathImage;
        [backImage.layer fx_playAnimation:animation];
    }
    return self;
}

- (void)animationEffectDidEnd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deluxeGiftViewDidCompleted:userId:)]) {
        [self.delegate deluxeGiftViewDidCompleted:self.giftId userId:self.userId];
    }
}

- (void)removeWithDuration:(NSTimeInterval)duration {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration + .5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationEffectDidEnd];
    });
}

- (void)dealloc {
    NSLog(@"==========:销毁了");
}

#pragma - mark FXAnimationDelegate
- (void)fxAnimationDidStop:(FXAnimation *)anim finished:(BOOL)finished{
    [self animationEffectDidEnd];
}

@end

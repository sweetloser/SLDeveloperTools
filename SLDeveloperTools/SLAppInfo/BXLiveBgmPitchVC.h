//
//  BXLiveBgmPitchVC.h
//  BXlive
//
//  Created by bxlive on 2019/6/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import <STPopup/STPopup.h>
#import "BXSLPopupController.h"


@protocol BXLiveBgmPitchVCDelegate <NSObject>
@optional
/**
 伴奏
 */
-(void)accompanySliderValue:(CGFloat)value;
/**
 人声
 */
-(void)voiceSliderValue:(CGFloat)value;
/**
 音调
 */
-(void)pitchSliderValue:(CGFloat)value;
/**
 混音
 */
-(void)mixingVoiceIndex:(NSInteger)selectIndex;

@end

/**
  设置音效
 */

@interface BXLiveBgmPitchVC : BaseVC

- (instancetype)initImage:(UIImage *)image accompanySliderValue:(CGFloat)accompanySliderValue voiceSliderValue:(CGFloat)voiceSliderValue pitchSliderValue:(CGFloat)pitchSliderValue mixingVoiceIndex:(NSInteger)mixingVoiceIndex;

@property (nonatomic, weak) id<BXLiveBgmPitchVCDelegate> delegate;


@end


@interface LiveBgnPitchViewCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *textLabel;

@property(nonatomic,strong)UIImageView *noneImage;

@property(nonatomic,strong)UIImageView *backImage;

-(void)loadData:(NSString *)title index:(NSInteger)index;


@end



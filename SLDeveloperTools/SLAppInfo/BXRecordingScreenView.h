//
//  BXRecordingScreenView.h
//  BXlive
//
//  Created by bxlive on 2019/7/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>

@protocol BXRecordingScreenViewDelegate <NSObject>

- (void)startRecordingScreenCompletion:(void (^)(int code))completion;   //开始录屏
- (void)stopRecordingScreen;                                             //停止录屏
- (void)giveUpRecordingScreen;                                           //放弃录屏

- (void)endRecordingScreen;                                              //结束录屏（页面退出）

- (void)didGetVideoWithFilePath:(NSString *)filePath coverImage:(UIImage *)coverImage;

@end

@interface BXRecordingScreenView : UIView <TXLiveRecordListener>

@property (nonatomic, weak) id<BXRecordingScreenViewDelegate> delegate;

- (instancetype)initWithCaptureView:(UIView *)captureView;

+ (void)screenCaptureWithView:(UIView *)view;

@end



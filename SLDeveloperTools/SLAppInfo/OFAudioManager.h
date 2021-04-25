#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface OFAudioManager : NSObject
/// 单例
+ (instancetype)sharedIntance;
/// 是否开启后台自动播放无声音乐
@property (nonatomic, assign) BOOL  openBackgroundAudioAutoPlay;
@end

NS_ASSUME_NONNULL_END

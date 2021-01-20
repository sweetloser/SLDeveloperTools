//
//  DynRecoderVoice.h
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynRecoderVoice : NSObject
@property (copy, nonatomic) void (^GetMp3Path)(NSString *Mp3Path);
@property (copy, nonatomic) void (^GetRecoder)(BOOL isRecoder);
- (void)recordStart;
- (void)recordEnd;
-(void)deleteMp3Folder;
@end

NS_ASSUME_NONNULL_END

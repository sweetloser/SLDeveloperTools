//
//  BXliveWatcerHelp.h
//  BXlive
//
//  Created by bxlive on 2019/6/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BXVideoWatcerHelp : NSObject

+ (void)watermarkingWithVideoUrl:(NSURL *)videoUrl waterImg:(NSString *)waterImg text:(NSString *)text isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion isSystem:(BOOL)isSystem;

@end

NS_ASSUME_NONNULL_END

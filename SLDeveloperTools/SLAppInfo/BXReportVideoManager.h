//
//  BXReportVideoManager.h
//  BXlive
//
//  Created by bxlive on 2019/4/23.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXReportVideoManager : NSObject

+ (BXReportVideoManager *)shareReportVideoManager;
+ (void)addWatchHistoryWithVideoId:(NSString *)videoId startTime:(NSString *)startTime duration:(NSString *)duration;

@end



//
//  BXYYImageCacheManager.h
//  BXlive
//
//  Created by bxlive on 2019/5/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXYYImageCacheManager : NSObject


+ (BXYYImageCacheManager *)sharedCacheManager;



- (void)addImageURLForKey:(NSURL *)imageURL;



@end

NS_ASSUME_NONNULL_END

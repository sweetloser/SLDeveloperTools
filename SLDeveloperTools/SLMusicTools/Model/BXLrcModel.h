//
//  BXLrcModel.h
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXLrcModel : NSObject

/** 开始时间 */
@property (nonatomic ,assign) NSTimeInterval beginTime;

/** 结束时间 */
@property (nonatomic ,assign) NSTimeInterval endTime;

/** 歌词内容 */
@property (nonatomic ,copy) NSString *lrcText;

@end


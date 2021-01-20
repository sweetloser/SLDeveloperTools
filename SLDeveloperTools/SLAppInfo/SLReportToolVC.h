//
//  SLReportToolVC.h
//  BXlive
//
//  Created by sweetloser on 2020/12/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "SLAmwayDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLReportTypeAmwayPicture,
    SLReportTypeAmwayVideo,
    SLReportTypeOthers,
    SLReportTypeComment,//评论
    SLReportTypeEvaluate,//留言
} SLReportType;

@interface SLReportToolVC : BaseVC

@property(nonatomic, strong)SLAmwayDetailModel *amwayDetailModel;

@property(nonatomic, assign)SLReportType reportType;

@property(nonatomic, assign)BOOL canMutiSelected;

@end

NS_ASSUME_NONNULL_END

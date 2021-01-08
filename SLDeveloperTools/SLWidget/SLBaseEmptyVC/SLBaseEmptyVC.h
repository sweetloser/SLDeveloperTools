//
//  SLBaseEmptyVC.h
//  BXlive
//
//  Created by sweetloser on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "../../SLBaseClass/SLBaseClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLBaseEmptyVC : BaseVC

@property(nonatomic,copy)void(^refreshBlock)(void);

@end

NS_ASSUME_NONNULL_END

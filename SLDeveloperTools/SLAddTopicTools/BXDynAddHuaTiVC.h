//
//  BXDynAddHuaTiVC.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynAddHuaTiVC : BaseVC

@property(nonatomic,copy)NSArray *topicArray;
@property (nonatomic,strong)NSMutableArray *ItemArray;
@property (nonatomic,strong)NSMutableArray *SelectedArray;
@property (nonatomic,assign)NSInteger itemNumber;
@property (nonatomic,assign)NSInteger MAXNumber;
@property(nonatomic,copy)void(^SelTopicBlock)(NSMutableArray *array);

@end

NS_ASSUME_NONNULL_END

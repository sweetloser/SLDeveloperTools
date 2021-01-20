//
//  BXDynNewModel.h
//  BXlive
//
//  Created by mac on 2020/6/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynNewModel : NSObject
@property(nonatomic, strong)NSString *boyName;//男昵称
@property(nonatomic, strong)NSString *girlName;//女昵称
@property(nonatomic, strong)NSString *boyHeaderImage;
@property(nonatomic, strong)NSString *girlHeaderImage;
@property(nonatomic, strong)NSString *dian_zan;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *backImage;
@property(nonatomic, strong)NSArray *ImageArray;
@property(nonatomic, strong)NSMutableArray *commentList;
@property(nonatomic, assign)BOOL isUnfold;
@end

NS_ASSUME_NONNULL_END

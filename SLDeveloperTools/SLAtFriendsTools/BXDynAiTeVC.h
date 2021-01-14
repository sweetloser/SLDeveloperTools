//
//  BXDynAiTeVC.h
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynAiTeVC : BaseVC<JXCategoryListContentViewDelegate>
@property(nonatomic,copy)void(^SelFriendBlock)(NSString *user_id, NSString *user_name, BOOL isSelect);
@property(nonatomic,copy)void(^ExpressFriendBlock)(NSString *user_id, NSString *user_name);
@property(nonatomic, strong)NSString *friendType;

@property(nonatomic,copy)void (^selectTextArray)(NSMutableArray *array);

@property(nonatomic,strong)NSMutableArray *friendArray;
@property(nonatomic,strong)NSString *aite_type;
@end

NS_ASSUME_NONNULL_END

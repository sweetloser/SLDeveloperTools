//
//  BXMusicCategoryModel.h
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"
#import "BXMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXMusicCategoryModel : BaseObject
/** 类别id */
@property (nonatomic , strong) NSString *category_id;
/** 图标 */
@property (nonatomic , strong) NSString *icon;
/** 名称 */
@property (nonatomic , strong) NSString *title;
/** 类别对应的音乐 */
@property (nonatomic , strong) NSMutableArray *itemArray;
@end

NS_ASSUME_NONNULL_END

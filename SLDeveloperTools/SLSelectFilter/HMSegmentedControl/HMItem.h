//
//  HMItem.h
//  BXlive
//
//  Created by bxlive on 2019/5/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"

@interface HMItem : BaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *file_url;

@property (nonatomic, assign) NSInteger status;     //0：已下载 1：未下载 2：正在下载

- (NSString *)allFilePath;
+ (NSString *)allFilePathWithName:(NSString *)name;

@end



//
//  DynUploadToolModel.h
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXUGCPublish.h"
#import "BXDynamicModel.h"

@protocol DSUploadToolDelegate <NSObject>
@optional
- (void)uploadProgress:(CGFloat)progress dynmodel:(BXDynamicModel *)movie;
- (void)uploadComplete:(TXPublishResult *)result dynmodel:(BXDynamicModel *)movie;
@end

@interface DynUploadToolModel : NSObject
@property (strong, nonatomic) BXDynamicModel *dynmodel;
@property (weak, nonatomic) id<DSUploadToolDelegate> delegate;

- (void)uploadMovie:(BXDynamicModel *)dynmodel;
- (void)cancelUploadMovie;

@end


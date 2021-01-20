//
//  BXUploadMovieTool.h
//  BXlive
//
//  Created by bxlive on 2018/4/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXUGCPublish.h"
#import "BXHMovieModel.h"

@protocol BXUploadMovieToolDelegate <NSObject>
@optional
- (void)uploadMovieProgress:(CGFloat)progress movie:(BXHMovieModel *)movie;
- (void)uploadMovieComplete:(TXPublishResult *)result movie:(BXHMovieModel *)movie;
@end

@interface BXUploadMovieTool : NSObject
@property (strong, nonatomic) BXHMovieModel *movie;
@property (weak, nonatomic) id<BXUploadMovieToolDelegate> delegate;

- (void)uploadMovie:(BXHMovieModel *)movie;
- (void)cancelUploadMovie;

@end

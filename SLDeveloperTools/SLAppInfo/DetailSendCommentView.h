//
//  DetailCommentView.h
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
#import "BXDynCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailSendCommentView : UIView
@property (copy, nonatomic) NSString *replyName;
@property (assign, nonatomic) BOOL isReply;
@property(nonatomic, strong)BXDynamicModel *model;
@property (copy, nonatomic) void (^sendComment)(BXDynCommentModel *model);
@property (copy, nonatomic) void (^replyComment)(BXDynCommentModel *model);

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array model:(BXDynamicModel *__nullable)model contentid:(NSString *)contentid touid:(NSString *)touid;

- (void)show:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END

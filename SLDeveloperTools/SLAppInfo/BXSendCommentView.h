//
//  BXSendCommentView.h
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXSendCommentView : UIView

@property (copy, nonatomic) NSString *replyName;

@property (copy, nonatomic) void (^sendComment)(NSString *text,NSString *jsonString);

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

- (void)show:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END

//
//  BXIssueDynCommentView.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPGrowingTextView;
@class BXHHEmoji;
NS_ASSUME_NONNULL_BEGIN
@protocol IssueViewTextDelegate <NSObject>

@optional
-(void)sendEmojiMsg:(BXHHEmoji *)emoji;
-(void)deleteEmojiMsg;
-(void)sendAiTeFriend;
-(void)AddPicture;
-(void)LuYinAct;

@end

@interface BXIssueDynCommentView : UIView
@property(nonatomic, weak)id<IssueViewTextDelegate>delegate;
@property (copy, nonatomic) NSString *replyName;

@property (copy, nonatomic) void (^sendComment)(NSString *text,NSString *jsonString);
@property (copy, nonatomic) void (^sendtag)(NSInteger tag);


-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array IssueType:(NSInteger)issuetype;
-(void)setTypeWithRecoder:(BOOL)recoder Picture:(BOOL)picture Emoji:(BOOL)emoji AiTe:(BOOL)Aite KeyWord:(BOOL)KeyWord;

@end

NS_ASSUME_NONNULL_END

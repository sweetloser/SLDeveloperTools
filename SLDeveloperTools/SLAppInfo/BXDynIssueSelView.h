//
//  BXDynIssueSelView.h
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHHEmojiView.h"
NS_ASSUME_NONNULL_BEGIN
@class BXHHEmoji;
@protocol IssueDataDelegate <NSObject>

@optional
-(void)sendEmojiMsg:(BXHHEmoji *)emoji;
-(void)deleteEmojiMsg;
-(void)SkipAiTeFriend;
-(void)LuYinAct;
-(void)ClickBtn:(NSInteger)flag;

@end
@interface BXDynIssueSelView : UIView
@property(nonatomic, weak)id<IssueDataDelegate>delegate;
@property (copy, nonatomic) void (^ReturnPath)(NSString *mp3Path);
@property(nonatomic, assign) NSInteger ShowType;

@property (strong, nonatomic) BXHHEmojiView *emojiView;
@property(nonatomic, strong)UIView *micrBackView;
@end

NS_ASSUME_NONNULL_END

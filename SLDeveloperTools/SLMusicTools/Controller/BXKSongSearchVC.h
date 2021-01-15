//
//  BXKSongSearchVC.h
//  BXlive
//
//  Created by bxlive on 2019/6/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

@protocol DSKSongSearchVCDelegate <NSObject>
/** 关闭 */
- (void)deleteAction;
/** 取消 */
- (void)cancelSearch;

@optional

@end

@interface BXKSongSearchVC : BaseVC

@property (nonatomic, weak) id<DSKSongSearchVCDelegate> delegate;

@end



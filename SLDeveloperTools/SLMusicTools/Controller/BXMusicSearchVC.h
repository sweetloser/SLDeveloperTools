//
//  BXMusicSearchVC.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

@protocol DSMusicSearchVCDelegate <NSObject>
/** 关闭 */
- (void)deleteAction;
/** 取消 */
- (void)cancelSearch;

@optional

@end

@interface BXMusicSearchVC : BaseVC
@property (nonatomic, weak) id<DSMusicSearchVCDelegate> delegate;

@end


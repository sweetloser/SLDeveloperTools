//
//  BXKSongSearchResualtVC.h
//  BXlive
//
//  Created by bxlive on 2019/6/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

@protocol DSKSongSearchResualtVCDelegate <NSObject>

- (void)deleteAction;
- (void)cancelSearch;
- (void)removeResault;

@optional
- (void)searchText:(NSString *)text;

@end

@interface BXKSongSearchResualtVC : BaseVC

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) id<DSKSongSearchResualtVCDelegate> delegate;

@end

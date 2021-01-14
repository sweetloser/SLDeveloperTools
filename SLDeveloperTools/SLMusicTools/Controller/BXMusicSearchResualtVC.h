//
//  BXMusicSearchResualtVC.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

@protocol BXMusicSearchResualtVCDelegate <NSObject>

- (void)deleteAction;
- (void)cancelSearch;
- (void)removeResault;

@optional
- (void)searchText:(NSString *)text;

@end

@interface BXMusicSearchResualtVC : BaseVC
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) id<BXMusicSearchResualtVCDelegate> delegate;

@end


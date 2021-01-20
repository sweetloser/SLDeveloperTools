//
//  BXSLSearchingVC.h
//  BXlive
//
//  Created by bxlive on 2019/3/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"

#define SearchTextFieldNormalWidth   __kWidth - 50 - 16
#define SearchTextFieldInputWidth    __kWidth - 40 - __ScaleWidth(12) * 2 - __ScaleWidth(10)

@protocol YHSearchingVCDelegate <NSObject>

- (void)cancelSearch;

@optional
- (void)searchText:(NSString *)text;

@end

@interface BXSLSearchingVC : BaseVC

@property (nonatomic, assign) NSInteger type; //0：BXSLSearchVC 1：BXSLSearchResultVC
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) id<YHSearchingVCDelegate> delegate;

@end


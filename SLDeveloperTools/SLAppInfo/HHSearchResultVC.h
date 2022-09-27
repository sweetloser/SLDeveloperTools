//
//  HHSearchResultVC.h
//  BXlive
//
//  Created by bxlive on 2018/9/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseVC.h"

@interface HHSearchResultVC : BaseVC <UISearchResultsUpdating>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *countrySections;

@property (copy, nonatomic) void (^didSelectCountry)(NSString *country, NSString *code);

@end

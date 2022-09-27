//
//  HHSelectCountryVC.h
//  BXlive
//
//  Created by bxlive on 2018/9/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BaseVC.h"

@interface HHSelectCountryVC : BaseVC 

@property (copy, nonatomic) void (^didSelectCountry)(NSString *country, NSString *code);

@end

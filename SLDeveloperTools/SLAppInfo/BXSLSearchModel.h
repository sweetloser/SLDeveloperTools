//
//  BXSLSearchModel.h
//  BXlive
//
//  Created by bxlive on 2019/3/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface BXSLSearchModel : NSObject

@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, copy) NSString *rank_score;
@property (nonatomic, copy) NSString *rank_score_str;
@property (nonatomic, copy) NSString *rank_score_total;


@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *film_id;
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, copy) NSString *animate_url;
@property (copy, nonatomic) NSString *nickname;


@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *avatar;

@end

NS_ASSUME_NONNULL_END

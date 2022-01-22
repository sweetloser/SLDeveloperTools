//
//  ListCollection.h
//  BXlive
//
//  Created by bxlive on 2017/1/10.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol listDelegate <NSObject>

-(void)GetInformessage:(NSDictionary *)subdic;

@end
@interface ListCollection : UIView

@property(weak, nonatomic) id<listDelegate>delegate;

@property(copy, nonatomic) NSString *room_id;

@property(nonatomic,copy)void(^headerGuardClick)(void);

-(instancetype)initWithID:(NSString *)roomId;

-(void)updateGuardData:(NSArray *)guardData;

@end

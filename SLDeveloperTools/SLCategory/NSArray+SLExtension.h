//
//  NSArray+SLExtension.h
//  BXlive
//
//  Created by sweetloser on 2020/12/31.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (SLExtension)
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

NS_ASSUME_NONNULL_END

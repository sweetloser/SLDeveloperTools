//
//  BXShortBeautifyView.h
//  BXlive
//
//  Created by bxlive on 2019/4/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 美化
 */
@interface BXShortBeautifyView : UIView

@property(nonatomic,copy)void(^hiddenCallBack)(void);

-(void)show;


@end

NS_ASSUME_NONNULL_END
